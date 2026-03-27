//
//  ContrectLocallySigningVC.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ContrectLocallySigningVC.h"
#import "ZYContrectUnderSigningDetailEditVc.h"
#import "ZYMoulageHelperSearchVc.h"
#import "ZYMoulageHelperVcTableViewCell.h"

static NSString * const moulageHelperVcTableViewCellID = @"ZYMoulageHelperVcTableViewCell";

@interface ContrectLocallySigningVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ContrectLocallySigningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"草稿箱";
    [self rightBarButtonItemCustom];
    [self setUI];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf requestContractTemplateData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf requestContractTemplateData];
        // 禁用header
        weakSelf.tableView.mj_header.hidden = YES;
    }];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_Dark) {
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    // 自动加载数据
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.superview).offset(5);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {

    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [navRightBtn setImage:[[ZYThemeManager shareManager] themeImageNamed:@"search-all"] forState:UIControlStateNormal];
    navRightBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}

- (void)navRightBtnAction{

    NSLog(@"搜索");
    ZYMoulageHelperSearchVc *vc = [[ZYMoulageHelperSearchVc alloc] init];
    vc.type = self.type;
    vc.isSystemTemplate = NO;
    [self pushVc:vc];
}

#pragma mark - 懒加载
- (ZYEmptyDataTableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        // 设置单元格自适应
        _tableView.estimatedRowHeight = 82;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        // 设置代理
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // 设置tableView样式
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 注册单元格
        [_tableView registerNib:[UINib nibWithNibName:@"ZYMoulageHelperVcTableViewCell" bundle:nil] forCellReuseIdentifier:moulageHelperVcTableViewCellID];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 请求合同模板数据
- (void)requestContractTemplateData {

    NSDictionary *parms = @{@"pageNum" : @(self.currentPage), @"pageSize" : @(10), @"attr" : @(NO)};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractTemplatesUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;

        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                ZYAllContractTemplatesDataModel *dataModel = [ZYAllContractTemplatesDataModel yy_modelWithJSON:jsonStr];
                // 先移除所有数据
                if (self.currentPage == 1) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:dataModel.list];
                // 判断数据是否加载完了
                if (self.dataArray.count >= dataModel.total) {
                    // 表示没有数据可以请求，设置UITableView footer的状态
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    // 重置提示加载更多数据
                    [self.tableView.mj_footer resetNoMoreData];
                }
                
                if (!self.dataArray.count) {
                    self.tableView.mj_footer.hidden = YES;
                    // 空占位图文
                    [self.tableView emptyDataDelegate];
                }
                
                // 刷新tableView
                [self.tableView reloadData];
            }else {
                if (self.currentPage > 1) {
                    self.currentPage -= 1;
                }
                if (self.currentPage == 1) {
                    self.tableView.mj_footer.hidden = YES;
                }
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            if (self.currentPage > 1) {
                self.currentPage -= 1;
            }
            if (self.currentPage == 1) {
                self.tableView.mj_footer.hidden = YES;
            }
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYMoulageHelperVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moulageHelperVcTableViewCellID forIndexPath:indexPath];
    cell.showButton.layer.borderWidth = 1;
    cell.showButton.layer.borderColor = Y_RGBA(38, 114, 249, 1).CGColor;
    cell.showButton.userInteractionEnabled = NO;
    ZYAllContractTemplatesDataListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZYContrectUnderSigningDetailEditVc *vc = [[ZYContrectUnderSigningDetailEditVc alloc] init];
    ZYAllContractTemplatesDataListModel *model = self.dataArray[indexPath.row];
    vc.uuid = model.uuid;
    vc.contractTemplatesDataListModel = model;
    vc.isImmediatelySign = NO;
    vc.isDraft = YES;
    [self pushVc:vc];
}

@end
