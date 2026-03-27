//
//  ZYCommunityFairSoldOutVC.m
//  Community
//
//  Created by ZY on 2021/8/6.
//

#import "ZYCommunityFairSoldOutVC.h"
#import "ZYCommunityFairDetailVC.h"
#import "ZYCommunityFairEditVC.h"
#import "ZYCommunityFairCell.h"

static NSString * const communityFairCellID = @"ZYCommunityFairCell";

#define kCommunityFairCellHeight 125

@interface ZYCommunityFairSoldOutVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ZYCommunityFairSoldOutVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"下架商品";
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYEmptyDataTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
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
// 所有下架的商品
- (void)initSelectMarketPageData {
    NSDictionary *parms = @{@"page" : @(self.currentPage), @"size" : @(10), @"query" : @{@"state" : @(0)}};
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

// 加载重新上架商品数据
- (void)initShelvesMarketDataWith:(ZYCommunityFairListDataListModel *)model {
    NSDictionary *params = @{@"id" : model.ID, @"state" : @(1)};
    [[ToolOfNetWork sharedTools] YrequestPostPinURLStrWithAllURLNoParmsNotMainQueue:[NSString stringWithFormat:@"%@%@", BASE_URL, kUpdateStateUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self.dataArray removeObject:model];
                [self.tableView reloadData];
                [ZYProgressHUDTool showCustomHUDTextMessage:@"商品上架成功" toView:self.view];
                
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"MARKET_SHELVES_BACK")
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
                [self.tableView reloadData];
                [ZYProgressHUDTool showCustomHUDTextMessage:@"删除成功" toView:self.view];
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
    cell.editStr = @"重新上架";
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
// 重新上架
- (void)editButtonClicked:(UIButton *)sender {
    
    NSLog(@"重新上架");
    NSInteger index = sender.tag - 200;
    ZYCommunityFairListDataListModel *model = self.dataArray[index];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"上架中..."];
    [self initShelvesMarketDataWith:model];
}

// 更多
- (void)moreButtonClicked:(UIButton *)sender {
    
    NSLog(@"更多");
    NSInteger index = sender.tag - 500;
    ZYCommunityFairListDataListModel *model = self.dataArray[index];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除");
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"删除中..."];
        [self initDeleteMarketDataWith:model];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:deleteAction];
    [alertVC addAction:cancleAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
