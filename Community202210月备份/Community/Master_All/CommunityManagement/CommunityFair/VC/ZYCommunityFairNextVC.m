//
//  ZYCommunityFairNextVC.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYCommunityFairNextVC.h"
#import "ZYCommunityFairDetailVC.h"
#import "ZYCommunityFairCell.h"

static NSString * const communityFairCellID = @"ZYCommunityFairCell";

#define kCommunityFairCellHeight 125

@interface ZYCommunityFairNextVC () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ZYCommunityFairNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加返回手势
    self.transitioningDelegate = self;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setUI];
    [self customTableView];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf initSelectMarketAllPageData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf initSelectMarketAllPageData];
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
    Y_NSNotificationCenter_Creat_NameAction(@"MARKET_DELETE_BACK", marketSubmitBack)
}

// 通知回调
- (void)marketSubmitBack {
    
    self.currentPage = 1;
    [self initSelectMarketAllPageData];
}

// 销毁通知
- (void)dealloc {
    
    Y_NSNotificationCenter_RemoveNotice_Name(@"MARKET_SUBMIT_BACK")
    Y_NSNotificationCenter_RemoveNotice_Name(@"MARKET_DELETE_BACK")
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].windows.lastObject].x / [UIApplication sharedApplication].windows.lastObject.bounds.size.width);
    if ((edgePan.edges == UIRectEdgeLeft) && (progress > 0.2)) {
        Y_NSNotificationCenter_PostNotice_NilObject_Name(@"ZY_CUSTOM_POP_BACK")
    }
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.superview).offset(8);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYEmptyDataTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] init];
        _tableView.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
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
// 所有发布的商品
- (void)initSelectMarketAllPageData {
    NSDictionary *parms = @{@"page" : @(self.currentPage), @"size" : @(10), @"query" : @{@"categoryId" : self.categoryId}};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kSelectMarketAllPageUrl] withBody:parms finished:^(id responsObject, NSError *error) {
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
    
    ZYCommunityFairListDataListModel *model = self.dataArray[indexPath.row];
    ZYCommunityFairCell *cell = [tableView dequeueReusableCellWithIdentifier:communityFairCellID forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 131, 0, 16);
    cell.editView.hidden = YES;
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
    [self.navigationController pushViewController:vc animated:YES];
}

@end
