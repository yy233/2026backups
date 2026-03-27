//
//  ZYContrectManageVC.m
//  Community
//
//  Created by ZY on 2021/8/30.
//

#import "ZYContrectManageVC.h"
#import "ContrectAllDetailVc.h"
#import "ZYContractSignCompleteDetailVc.h"
#import "ZYContrectAllListSearchVC.h"
#import "ZYRentContractDetailVC.h"
#import "ZYContrectManageTopView.h"
#import "ZYContrectManageTopListView.h"
#import "ContrectAllListBaseTableViewCell.h"
#import "ZYContrectAllListModel.h"
#import "ZYContrectManageTopListModel.h"

static CGFloat topListViewDuration = 0.25;
#define  ContrectAllListBaseTableViewCell_Identifier    @"ContrectAllListBaseTableViewCell"
#define kContrectManageTopListCellHeight 40

@interface ZYContrectManageVC () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate,  ZYContrectManageTopListViewDelegate>

@property (nonatomic, strong) ZYContrectManageTopView *topView;

@property (nonatomic, strong) ZYContrectManageTopListView *topListView;

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

// 合同类型
@property (nonatomic,assign) ContrectList_Type listVcType;

@property (nonatomic, strong) NSString *urlStr;

@property (nonatomic, assign) BOOL isShowTopListView;

@property (nonatomic, strong) NSArray *topListTitleArray;

@property (nonatomic, strong) NSMutableArray *topListDataArray;

@end

@implementation ZYContrectManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.isShowTopListView = NO;
    self.listVcType = ContrectList_Type_All;
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
        make.height.offset(44 + status_height);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
    
    [self.view addSubview:self.topListView];
    [_topListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(_topListView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYContrectManageTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYContrectManageTopView" owner:nil options:nil].lastObject;
        _topView.titleView.userInteractionEnabled = NO;
        [_topView.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewTap)]];
        [_topView.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_topView.searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _topView;
}

- (ZYContrectManageTopListView *)topListView {
    if (!_topListView) {
        _topListView = [[NSBundle mainBundle] loadNibNamed:@"ZYContrectManageTopListView" owner:nil options:nil].lastObject;
        _topListView.tableViewHeightConstraint.constant = 0;
        _topListView.hidden = YES;
        _topListView.delegate = self;
    }
    
    return _topListView;
}

- (ZYEmptyDataTableView *)tableView {
    if (!_tableView){
        _tableView = [[ZYEmptyDataTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
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

- (NSArray *)topListTitleArray {
    if (!_topListTitleArray) {
        _topListTitleArray = @[@"全部合同", @"待我签", @"待他签", @"我发起的", @"已完成"];
    }
    
    return _topListTitleArray;
}

- (NSMutableArray *)topListDataArray {
    if (!_topListDataArray) {
        _topListDataArray = [NSMutableArray array];
    }
    
    return _topListDataArray;
}

#pragma mark - 加载数据
// 合同列表数据
- (void)initContrectListData {
    
    switch (self.listVcType) {
        case ContrectList_Type_All:
        {
            self.urlStr = kAllContractsUrl;
        }
            break;
        case ContrectList_Type_MyWait:
        {
            self.urlStr = kAllContractsAwaitingAttentionUrl;
        }
            break;
        case ContrectList_Type_OtherWait:
        {
            self.urlStr = kContractToBeSignedUrl;
        }
            break;
        case ContrectList_Type_Complete:
        {
            self.urlStr = kCompletedContractUrl;
        }
            break;
        case ContrectList_Type_Expire:
        {
            self.urlStr = kContractAboutToExpireUrl;
        }
            break;
        case ContrectList_Type_Invalid:
        {
            self.urlStr = kContractIsInvalidUrl;
        }
            break;
        case ContrectList_Type_Close:
        {
            self.urlStr = kContractIsAboutToCloseUrl;
        }
            break;
        case ContrectList_Type_MySend:
        {
            self.urlStr = kContractMySendUrl;
        }
            break;
        default:
            break;
    }
    
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
                ZYContrectAllListDataMapModel *mapModel = dataModel.map;
                if (isNotNil(mapModel)) {
                    if (self.topListDataArray.count > 0) {
                        [self.topListDataArray removeAllObjects];
                    }
                    for (int i = 0; i < self.topListTitleArray.count; i++) {
                        ZYContrectManageTopListModel *model = [[ZYContrectManageTopListModel alloc] init];
                        model.title = self.topListTitleArray[i];
                        if (i == 0) {
                            model.isSelected = YES;
                            self.topView.titleView.userInteractionEnabled = YES;
                            self.topView.titleLabel.text = self.topListTitleArray[i];
                            self.topView.numLabel.text = [NSString stringWithFormat:@"(%ld)", mapModel.allContracts];
                        }else {
                            model.isSelected = NO;
                        }
                        if (i == 0) {
                            model.num = mapModel.allContracts;
                        }else if (i == 1) {
                            model.num = mapModel.waitForMeToSignContracts;
                        }else if (i == 2) {
                            model.num = mapModel.contractToBeSigned;
                        }else if (i == 3) {
                            model.num = mapModel.allInitiatedContractToMe;
                        }else if (i == 4) {
                            model.num = mapModel.completedContract;
                        }
                        [self.topListDataArray addObject:model];
                    }
                    self.topListView.dataArray = self.topListDataArray;
                }
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
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - ZYContrectManageTopListViewDelegate
- (void)contrectManageTopListViewTapEvent {
    
    [self hiddenTopListView];
}

- (void)contentViewTapWithIndex:(NSInteger)index {
    
    [self hiddenTopListView];
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    [self.tableView reloadData];
    
    for (int i = 0; i < self.topListDataArray.count; i++) {
        ZYContrectManageTopListModel *tempModel = self.topListDataArray[i];
        if (i == index) {
            tempModel.isSelected = YES;
        }else {
            tempModel.isSelected = NO;
        }
    }
    self.topListView.dataArray = self.topListDataArray;
    
    ZYContrectManageTopListModel *model = self.topListDataArray[index];
    self.topView.titleLabel.text = model.title;
    self.topView.numLabel.text = [NSString stringWithFormat:@"(%ld)", model.num];
    
    if (index == 0) {
        self.listVcType = ContrectList_Type_All;
    }else if (index == 1) {
        self.listVcType = ContrectList_Type_MyWait;
    }else if (index == 2) {
        self.listVcType = ContrectList_Type_OtherWait;
    }else if (index == 3) {
        self.listVcType = ContrectList_Type_MySend;
    }else if (index == 4) {
        self.listVcType = ContrectList_Type_Complete;
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 处理点击事件
- (void)titleViewTap {
    
    if (!self.isShowTopListView) {
        [self showTopListView];
    }else {
        [self hiddenTopListView];
    }
}

// 显示topListView
- (void)showTopListView {
    
    self.isShowTopListView = YES;
    self.topListView.hidden = NO;
    self.topListView.alpha = 0;
    [UIView animateWithDuration:topListViewDuration animations:^{
        self.topListView.tableViewHeightConstraint.constant = kContrectManageTopListCellHeight * self.topListDataArray.count + 10;
        self.topListView.alpha = 1;
        [self.view layoutIfNeeded];
    }];
}

// 隐藏topListView
- (void)hiddenTopListView {
    
    self.isShowTopListView = NO;
    self.topListView.alpha = 1;
    [UIView animateWithDuration:topListViewDuration animations:^{
        self.topListView.tableViewHeightConstraint.constant = 0;
        self.topListView.alpha = 0;
        [self.view layoutIfNeeded];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(topListViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.topListView.hidden = YES;
    });
}

- (void)backButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchButtonClicked {
    
    NSLog(@"搜索");
    ZYContrectAllListSearchVC *vc = [[ZYContrectAllListSearchVC alloc] init];
    vc.listVcType = self.listVcType;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
