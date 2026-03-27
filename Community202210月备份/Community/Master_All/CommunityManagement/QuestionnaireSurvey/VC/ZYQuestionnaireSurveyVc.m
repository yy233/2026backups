//
//  ZYQuestionnaireSurveyVc.m
//  Community
//
//  Created by ZY on 2022/6/7.
//

#import "ZYQuestionnaireSurveyVc.h"
#import "ZYQuestionnaireSurveyEditVc.h"
#import "ZYQuestionnaireSurveyStatisticalVc.h"
#import "ZYQuestionnaireSurveyResultVc.h"
#import "ZYQuestionnaireSurveyCell.h"

static NSString * const ZYQuestionnaireSurveyCellID = @"ZYQuestionnaireSurveyCell";

@interface ZYQuestionnaireSurveyVc () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ZYQuestionnaireSurveyVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问卷调查";
    [self setUI];
    [self customTableView];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf initData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf initData];
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
    Y_NSNotificationCenter_Creat_NameAction(@"OWNERS_VOTE_SUBMIT_BACK", ownersVoteSumbitBack);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

// 通知回调
- (void)ownersVoteSumbitBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentPage = 1;
        [self initData];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"OWNERS_VOTE_SUBMIT_BACK");
}

#pragma mark - 布局视图
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
- (void)initData {
    NSDictionary *parms = @{@"page" : @(self.currentPage), @"size" : @(10), @"query" : @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)}};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kOwnersVoteListUrl] withBody:parms finished:^(id responsObject, NSError *error) {
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
                ZYQuestionnaireSurveyModel *model = [ZYQuestionnaireSurveyModel yy_modelWithJSON:responsObject[@"data"]];
                [self.dataArray addObjectsFromArray:model.list];
                // 判断数据是否加载完了
                if (self.dataArray.count >= model.total) {
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
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYQuestionnaireSurveyCellID bundle:nil] forCellReuseIdentifier:ZYQuestionnaireSurveyCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYQuestionnaireSurveyCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYQuestionnaireSurveyCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    ZYQuestionnaireSurveyCell *cell = (ZYQuestionnaireSurveyCell *)currentCell;
    ZYQuestionnaireSurveyListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:ZYQuestionnaireSurveyCellID configuration:^(ZYQuestionnaireSurveyCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYQuestionnaireSurveyListModel *model = self.dataArray[indexPath.row];
    if (!model.status || model.isSeeSubmit || (model.isSeeSubmit && model.isOpenStatistics)) {
        ZYQuestionnaireSurveyEditVc *vc = [[ZYQuestionnaireSurveyEditVc alloc] init];
        vc.model = model;
        [self pushVc:vc];
    }else if (model.status && !model.isSeeSubmit && model.isOpenStatistics) {
        ZYQuestionnaireSurveyStatisticalVc *vc = [[ZYQuestionnaireSurveyStatisticalVc alloc] init];
        vc.ID = model.ID;
        [self pushVc:vc];
    }else if (model.status && !model.isSeeSubmit && !model.isOpenStatistics) {
        if (model.voteStatus == 2) {
            ZYQuestionnaireSurveyResultVc *vc = [[ZYQuestionnaireSurveyResultVc alloc] init];
            vc.type = ZYQuestionnaireSurveyResult_Type_Underway;
            [self pushVc:vc];
        }else if (model.voteStatus == 3) {
            ZYQuestionnaireSurveyResultVc *vc = [[ZYQuestionnaireSurveyResultVc alloc] init];
            vc.type = ZYQuestionnaireSurveyResult_Type_Over;
            [self pushVc:vc];
        }
    }
}

@end
