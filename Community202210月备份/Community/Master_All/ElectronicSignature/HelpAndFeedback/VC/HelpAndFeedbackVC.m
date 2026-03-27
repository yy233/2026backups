//
//  HelpAndFeedbackVC.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
// 帮助和反馈

#import "HelpAndFeedbackVC.h"
#import "HelpAndFeedbackHeaderView.h"
#import "ElectronicSignatureFeedBackVc.h"
#import "ZYHelpAndFeedbackCell.h"

static NSString * const helpAndFeedbackCellID = @"ZYHelpAndFeedbackCell";
#define kHelpAndFeedbackCellHeight 60

@interface HelpAndFeedbackVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) HelpAndFeedbackHeaderView *headerView;

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation HelpAndFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助反馈";
    
    [self setUI];
    [self customTableView];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf initCommonProblemData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf initCommonProblemData];
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

#pragma mark - 懒加载
- (HelpAndFeedbackHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HelpAndFeedbackHeaderView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 80)];
        [_headerView.feedbackBtn addTarget:self action:@selector(feedbackBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _headerView;
}

- (ZYEmptyDataTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
        _tableView.tableFooterView  = [UIView new];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYHelpAndFeedbackCell" bundle:nil] forCellReuseIdentifier:helpAndFeedbackCellID];
}

#pragma mark - 加载数据
// 加载常见问题数据
- (void)initCommonProblemData {
    NSDictionary *parms = @{@"pageNum" : @(self.currentPage), @"pageSize" : @(10)};
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kCommonProblemUrl withBody:parms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.currentPage == 1) {
                    [self.dataArray removeAllObjects];
                }
                ZYHelpAndFeedbackModel *model = [ZYHelpAndFeedbackModel yy_modelWithJSON:responsObject];
                NSArray *array = model.data.list;
                for (ZYHelpAndFeedbackDataListModel *tempModel in array) {
                    tempModel.isSelected = NO;
                    [self.dataArray addObject:tempModel];
                }
                // 判断数据是否加载完了
                if (self.dataArray.count >= model.data.total) {
                    if (model.data.total > 10) {
                        // 表示没有数据可以请求，设置UITableView footer的状态
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        self.tableView.mj_footer.hidden = YES;
                    }
                }else {
                    // 重置提示加载更多数据
                    [self.tableView.mj_footer resetNoMoreData];
                }
                self.tableView.tableHeaderView = self.headerView;
                
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
    
    ZYHelpAndFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:helpAndFeedbackCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    
    ZYHelpAndFeedbackCell *cell = (ZYHelpAndFeedbackCell *)currentCell;
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.titleView.tag = 200 + indexPath.row;
    [cell.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewTap:)]];
    ZYHelpAndFeedbackDataListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYHelpAndFeedbackDataListModel *model = self.dataArray[indexPath.row];
    if (model.isSelected) {
        
        return [tableView fd_heightForCellWithIdentifier:helpAndFeedbackCellID cacheByIndexPath:indexPath configuration:^(ZYHelpAndFeedbackCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
    
    return kHelpAndFeedbackCellHeight;
}

#pragma mark - 点击事件
// 问题反馈
- (void)feedbackBtnAction {
    
    NSLog(@"问题反馈");
    ElectronicSignatureFeedBackVc *vc = [[ElectronicSignatureFeedBackVc alloc]init];
    [self pushVc:vc];
}

- (void)titleViewTap:(UITapGestureRecognizer *)tap {
    
    NSInteger index = tap.view.tag  - 200;
    ZYHelpAndFeedbackDataListModel *model = self.dataArray[index];
    if (!model.isSelected) {
        model.isSelected = YES;
    }else {
        model.isSelected = NO;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
