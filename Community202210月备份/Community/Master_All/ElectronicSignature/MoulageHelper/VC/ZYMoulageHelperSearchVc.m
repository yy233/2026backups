//
//  ZYMoulageHelperSearchVc.m
//  Community
//
//  Created by ZY on 2021/7/12.
//

#import "ZYMoulageHelperSearchVc.h"
#import "ZYMoulageHelperDetailVc.h"
#import "ZYContrectUnderSigningDetailEditVc.h"
#import "ZYContractingPartyInformationSearchTopView.h"
#import "ZYMoulageHelperVcTableViewCell.h"
#import "ZYAllContractTemplatesModel.h"

static NSString * const moulageHelperVcTableViewCellID = @"ZYMoulageHelperVcTableViewCell";

@interface ZYMoulageHelperSearchVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) ZYContractingPartyInformationSearchTopView *topView;

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *searchStr;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ZYMoulageHelperSearchVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self customTableView];
    [self tableViewHandle];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self hiddenNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setupNavigationBarClearTransparentStyle];
}

- (void)setUI {
    
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(64 + status_height);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).with.offset(10);
        make.bottom.left.right.equalTo(_tableView.superview);
    }];
}

- (void)tableViewHandle {
    
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
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - 懒加载
- (ZYContractingPartyInformationSearchTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYContractingPartyInformationSearchTopView" owner:nil options:nil].lastObject;
        _topView.searchTF.delegate = self;
        _topView.searchTF.placeholder = @"请输入合同名称";
        _topView.searchTF.keyboardType = UIKeyboardTypeDefault;
        _topView.searchTF.returnKeyType = UIReturnKeySearch;
        [_topView.searchTF becomeFirstResponder];
        [_topView.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_topView.searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _topView;
}

- (ZYEmptyDataTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
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

    NSDictionary *parms = parms = @{@"pageNum" : @(self.currentPage), @"pageSize" : @(10), @"attr" : @(self.isSystemTemplate), @"search" : self.searchStr};
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

#pragma mark - 定制TableView
- (void)customTableView {
    
    // 设置单元格自适应
    self.tableView.estimatedRowHeight = 82;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 设置tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYMoulageHelperVcTableViewCell" bundle:nil] forCellReuseIdentifier:moulageHelperVcTableViewCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYMoulageHelperVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moulageHelperVcTableViewCellID forIndexPath:indexPath];
    cell.showButton.layer.borderWidth = 1;
    cell.showButton.layer.borderColor = Y_RGBA(58, 71, 109, 1).CGColor;
    cell.showButton.userInteractionEnabled = NO;
    ZYAllContractTemplatesDataListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZYAllContractTemplatesDataListModel *model = self.dataArray[indexPath.row];
    if ([self.type isEqualToString:@"合同模板"]) {
        ZYMoulageHelperDetailVc *vc = [[ZYMoulageHelperDetailVc alloc] init];
        vc.uuid = model.uuid;
        vc.contractTemplatesDataListModel = model;
        if ([model.belongTo isEqualToString:@"system"]) {
            vc.isSystemTemplate = YES;
        }else {
            vc.isSystemTemplate = NO;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.type isEqualToString:@"在线签约"]) {
        ZYContrectUnderSigningDetailEditVc *vc = [[ZYContrectUnderSigningDetailEditVc alloc] init];
        vc.uuid = model.uuid;
        vc.contractTemplatesDataListModel = model;
        vc.isImmediatelySign = NO;
        vc.rentSignInfoModel = self.rentSignInfoModel;
        vc.isDraft = self.isDraft;
        vc.isSystemTemplate = self.isSystemTemplate;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    self.searchStr = textField.text;
    if (!self.searchStr.length) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        [self.tableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"搜索");
    [self.view endEditing:YES];
    if (self.searchStr.length > 0) {
        self.tableView.mj_header.hidden = NO;
        [self.tableView.mj_header beginRefreshing];
    }else {
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"搜索内容不能为空!" toView:self.view];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    self.searchStr = @"";
    
    return YES;
}

#pragma mark - 处理点击事件
- (void)backButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchButtonClicked {
    
    NSLog(@"搜索");
    [self.view endEditing:YES];
    if (self.searchStr.length > 0) {
        self.tableView.mj_header.hidden = NO;
        [self.tableView.mj_header beginRefreshing];
    }else {
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"搜索内容不能为空!" toView:self.view];
    }
}

@end
