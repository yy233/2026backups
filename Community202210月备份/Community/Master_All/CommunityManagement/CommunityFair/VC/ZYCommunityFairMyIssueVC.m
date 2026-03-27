//
//  ZYCommunityFairMyIssueVC.m
//  Community
//
//  Created by ZY on 2021/8/6.
//

#import "ZYCommunityFairMyIssueVC.h"
#import "ZYCommunityFairSoldOutVC.h"
#import "ZYCommunityFairDetailVC.h"
#import "ZYCommunityFairEditVC.h"
#import "ZYCommunityFairCell.h"
#import "ZYCommunityFairMyIssueEmptyView.h"

static NSString * const communityFairCellID = @"ZYCommunityFairCell";

#define kCommunityFairCellHeight 125

@interface ZYCommunityFairMyIssueVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ZYCommunityFairMyIssueEmptyView *emptyView;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ZYCommunityFairMyIssueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的发布";
    [self rightBarButtonItemCustom];
    [self setUI];
    [self customTableView];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf initSelectMarketPageData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf initSelectMarketPageData];
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
    Y_NSNotificationCenter_Creat_NameAction(@"MARKET_SUBMIT_BACK", marketSubmitBack)
    Y_NSNotificationCenter_Creat_NameAction(@"MARKET_SHELVES_BACK", marketShelvesBack)
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *vcsArray = [NSMutableArray array];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (![vc isKindOfClass:[ZYCommunityFairEditVC class]]) {
            [vcsArray addObject:vc];
        }
    }
    self.navigationController.viewControllers = [vcsArray copy];
}

// 通知回调
- (void)marketSubmitBack {
    
    self.currentPage = 1;
    // 自动加载数据
    [self.tableView.mj_header beginRefreshing];
}

- (void)marketShelvesBack {
    
    self.currentPage = 1;
    // 自动加载数据
    [self.tableView.mj_header beginRefreshing];
    // 发送通知
    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"MARKET_DELETE_BACK")
}

// 销毁通知
- (void)dealloc {
    
    Y_NSNotificationCenter_RemoveNotice_Name(@"MARKET_SUBMIT_BACK")
    Y_NSNotificationCenter_RemoveNotice_Name(@"MARKET_SHELVES_BACK")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithThemeColor];
}

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {

    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [navRightBtn setTitle:@"下架商品" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[ZYThemeManager shareManager].navigationItemThemeColor forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    
    [self.view addSubview:self.emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_emptyView.superview);
    }];
    [self.view bringSubviewToFront:self.emptyView];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    }
    
    return _tableView;
}

- (ZYCommunityFairMyIssueEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairMyIssueEmptyView" owner:nil options:nil].lastObject;
        _emptyView.hidden = YES;
        _emptyView.releaseViewHeightConstraint.constant = 50 + button_bottom_height;
        [_emptyView.releaseButton addTarget:self action:@selector(releaseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _emptyView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
// 所有发布的商品
- (void)initSelectMarketPageData {    
    NSDictionary *parms = @{@"page" : @(self.currentPage), @"size" : @(10), @"query" : @{@"state" : @(1)}};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kSelectMarketPageUrl] withBody:parms finished:^(id responsObject, NSError *error) {
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
                ZYCommunityFairListModel *model = [ZYCommunityFairListModel yy_modelWithJSON:responsObject];
                ZYCommunityFairListDataModel *dataModel = model.data;
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
                if (self.dataArray.count > 0) {
                    self.emptyView.hidden = YES;
                }else {
                    self.emptyView.hidden = NO;
                    self.tableView.mj_footer.hidden = YES;
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

// 加载下架商品数据
- (void)initSoldOutMarketDataWith:(ZYCommunityFairListDataListModel *)model {
    NSDictionary *params = @{@"id" : model.ID, @"state" : @(0)};
    [[ToolOfNetWork sharedTools]  YrequestPostPinURLStrWithAllURLNoParmsNotMainQueue:[NSString stringWithFormat:@"%@%@", BASE_URL, kUpdateStateUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.dataArray removeObject:model];
                    if (self.dataArray.count > 0) {
                        self.emptyView.hidden = YES;
                    }else {
                        self.emptyView.hidden = NO;
                        self.tableView.mj_footer.hidden = YES;
                    }
                    // 刷新tableView
                    [self.tableView reloadData];
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"商品下架成功" toView:self.view];
                    // 发送通知
                    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"MARKET_DELETE_BACK")
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载删除商品数据
- (void)initDeleteMarketDataWith:(ZYCommunityFairListDataListModel *)model {
    NSDictionary *params = @{@"id" : model.ID};
    [[ToolOfNetWork sharedTools] YrequestDeleteALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kDeleteMarketUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self.dataArray removeObject:model];
                if (self.dataArray.count > 0) {
                    self.emptyView.hidden = YES;
                }else {
                    self.emptyView.hidden = NO;
                    self.tableView.mj_footer.hidden = YES;
                }
                // 刷新tableView
                [self.tableView reloadData];
                [ZYProgressHUDTool showCustomHUDTextMessage:@"删除成功" toView:self.view];
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"MARKET_DELETE_BACK")
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYCommunityFairCell" bundle:nil] forCellReuseIdentifier:communityFairCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYCommunityFairCell *cell = [tableView dequeueReusableCellWithIdentifier:communityFairCellID forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 131, 0, 16);
    cell.editView.hidden = NO;
    cell.editButton.tag = 200 + indexPath.row;
    cell.editStr = @"编辑";
    [cell.editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.moreButton.tag = 500 + indexPath.row;
    [cell.moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    ZYCommunityFairListDataListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kCommunityFairCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld", indexPath.row);
    ZYCommunityFairDetailVC *vc = [[ZYCommunityFairDetailVC alloc] init];
    ZYCommunityFairListDataListModel *model = self.dataArray[indexPath.row];
    vc.ID = model.ID;
    [self pushVc:vc];
}

#pragma mark - 点击事件
// 下架商品
- (void)navRightBtnAction {
    
    NSLog(@"下架商品");
    ZYCommunityFairSoldOutVC *vc = [[ZYCommunityFairSoldOutVC alloc] init];
    [self pushVc:vc];
}

// 编辑
- (void)editButtonClicked:(UIButton *)sender {
    
    NSLog(@"编辑");
    NSInteger index = sender.tag - 200;
    ZYCommunityFairListDataListModel *model = self.dataArray[index];
    ZYCommunityFairEditVC *vc = [[ZYCommunityFairEditVC alloc] init];
    vc.typeStr = @"编辑";
    vc.listModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

// 更多
- (void)moreButtonClicked:(UIButton *)sender {
    
    NSLog(@"更多");
    NSInteger index = sender.tag - 500;
    ZYCommunityFairListDataListModel *model = self.dataArray[index];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *soldOutAction = [UIAlertAction actionWithTitle:@"下架" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"下架");
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"下架中..."];
        [self initSoldOutMarketDataWith:model];
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除");
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"删除中..."];
        [self initDeleteMarketDataWith:model];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:soldOutAction];
    [alertVC addAction:deleteAction];
    [alertVC addAction:cancleAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 我要发布
- (void)releaseButtonClicked {
    
    NSLog(@"我要发布");
    ZYCommunityFairEditVC *vc = [[ZYCommunityFairEditVC alloc] init];
    vc.typeStr = @"发布";
    vc.listModel = [[ZYCommunityFairListDataListModel alloc] init];
    [self pushVc:vc];
}

@end
