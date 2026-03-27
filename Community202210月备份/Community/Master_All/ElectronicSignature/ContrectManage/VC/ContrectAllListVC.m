//
//  ContrectAllListVC.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "ContrectAllListVC.h"
#import "ContrectAllDetailVc.h"
#import "ZYContractSignCompleteDetailVc.h"
#import "ZYContrectAllListSearchVC.h"
#import "ZYRentContractDetailVC.h"
#import "ContrectAllListBaseTableViewCell.h"
#import "ZYContrectAllListModel.h"

#define  ContrectAllListBaseTableViewCell_Identifier    @"ContrectAllListBaseTableViewCell"
@interface ContrectAllListVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSString *urlStr;

@end

@implementation ContrectAllListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.listVcType ) {
        case ContrectList_Type_All:
        {
            self.title = @"全部合同";
            self.urlStr = kAllContractsUrl;
        }
            break;
        case ContrectList_Type_MyWait:
        {
            self.title = @"待签合同";
            self.urlStr = kAllContractsAwaitingAttentionUrl;
        }
            break;
        case ContrectList_Type_OtherWait:
        {
            self.title = @"待他人处理合同";
            self.urlStr = kContractToBeSignedUrl;
        }
            break;
        case ContrectList_Type_Complete:
        {
            self.title = @"已完成合同";
            self.urlStr = kCompletedContractUrl;
        }
            break;
        case ContrectList_Type_Expire:
        {
            self.title = @"即将截止签署合同";
            self.urlStr = kContractAboutToExpireUrl;
        }
            break;
        case ContrectList_Type_Close:
        {
            self.title = @"即将过期合同";
            self.urlStr = kContractIsAboutToCloseUrl;
        }
            break;
        default:
            break;
    }
   
    [self rightBarButtonItemCustom];
    [self setUI];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf initContrectListData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf initContrectListData];
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
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"CONTRACT_ALL_DETAIL_BACK", contractAllDetailBack)
}

// 通知回调
- (void)contractAllDetailBack {
    
    self.currentPage = 1;
    [self.tableView.mj_header beginRefreshing];
}

// 销毁通知
- (void)dealloc {
    
    Y_NSNotificationCenter_RemoveNotice_Name(@"CONTRACT_ALL_DETAIL_BACK")
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
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
    ZYContrectAllListSearchVC *vc = [[ZYContrectAllListSearchVC alloc] init];
    vc.listVcType = self.listVcType;
    [self pushVc:vc];
}

#pragma mark - 懒加载
- (ZYEmptyDataTableView *)tableView {
    if (!_tableView){
        _tableView = [[ZYEmptyDataTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
// 合同列表数据
- (void)initContrectListData {
    NSString *uuid =  [ShareUserInfo sharedUserInfo].userInfo.uid;
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNum" : @(self.currentPage), @"pageSize" : @(10), @"userId" : uuid}];
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:self.urlStr withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 移除所有数据
                if (self.currentPage == 1) {
                    [self.dataArray removeAllObjects];
                }
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                ZYContrectAllListDataModel *dataModel = [ZYContrectAllListDataModel yy_modelWithJSON:jsonStr];
                NSArray *array = dataModel.list;
                [self.dataArray addObjectsFromArray:array];
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
                    self.tableView.emptyTitle = @"当前暂无合同";
                    self.tableView.emptyImageName = @"blank_";
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContrectAllListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContrectAllListBaseTableViewCell_Identifier];
    if (!cell) {
        cell = [[ContrectAllListBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ContrectAllListBaseTableViewCell_Identifier];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    ZYContrectAllListDataListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZYContrectAllListDataListModel *model = self.dataArray[indexPath.row];
    
    if ((model.conState == 1) && (model.partASignState == 1) && (model.partBSignState == 1)) {
        if (model.assetId.length > 0 && [model.type isEqual:@"temp_type_rent"]) {
            ZYRentContractDetailVC *vc = [[ZYRentContractDetailVC alloc] init];
            vc.contractId = model.signId;
            if (model.signRole == 1) {
                vc.identityType = 2;
            }else {
                vc.identityType = 1;
            }
            [self pushVc:vc];
        }else {
            ZYContractSignCompleteDetailVc *vc = [[ZYContractSignCompleteDetailVc alloc] init];
            vc.conId = model.conId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        ContrectAllDetailVc *vc = [[ContrectAllDetailVc alloc] init];
        vc.conId = model.conId;
        [self pushVc:vc];
    }
}

@end
