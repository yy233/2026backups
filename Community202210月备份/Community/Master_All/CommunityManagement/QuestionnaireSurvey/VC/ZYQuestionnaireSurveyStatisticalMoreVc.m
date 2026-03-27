//
//  ZYQuestionnaireSurveyStatisticalMoreVc.m
//  Community
//
//  Created by ZY on 2022/6/9.
//

#import "ZYQuestionnaireSurveyStatisticalMoreVc.h"
#import "ZYQuestionnaireSurveyEditHeaderView.h"
#import "ZYQuestionnaireSurveyStatisticalTextCell.h"
#import "ZYQuestionnaireSurveyStatisticalMoreModel.h"

static NSString * const ZYQuestionnaireSurveyStatisticalTextCellID = @"ZYQuestionnaireSurveyStatisticalTextCell";

@interface ZYQuestionnaireSurveyStatisticalMoreVc () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) ZYQuestionnaireSurveyStatisticalMoreModel *model;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ZYQuestionnaireSurveyStatisticalMoreVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self setupNavigationBarStyleWithThemeColor];
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
        _tableView = [[ZYEmptyDataTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.hidden = YES;
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
    NSDictionary *parms = @{@"page" : @(self.currentPage), @"size" : @(20), @"query" : @{@"voteId" : self.voteId, @"topicId" : self.topicId}};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kOwnersVoteGetMoreUrl] withBody:parms finished:^(id responsObject, NSError *error) {
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
                ZYQuestionnaireSurveyStatisticalMoreModel *model = [ZYQuestionnaireSurveyStatisticalMoreModel yy_modelWithJSON:responsObject[@"data"]];
                self.model = model;
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
                
                self.tableView.hidden = NO;
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
    [self.tableView registerNib:[UINib nibWithNibName:ZYQuestionnaireSurveyStatisticalTextCellID bundle:nil] forCellReuseIdentifier:ZYQuestionnaireSurveyStatisticalTextCellID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYQuestionnaireSurveyStatisticalTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYQuestionnaireSurveyStatisticalTextCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    ZYQuestionnaireSurveyStatisticalTextCell *cell = (ZYQuestionnaireSurveyStatisticalTextCell *)currentCell;
    cell.content = self.dataArray[indexPath.row];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:ZYQuestionnaireSurveyStatisticalTextCellID configuration:^(ZYQuestionnaireSurveyStatisticalTextCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGSize size = [self.model.content boundingRectWithSize:CGSizeMake(kScreenW - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
    
    return size.height + 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZYQuestionnaireSurveyEditHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYQuestionnaireSurveyEditHeaderView" owner:nil options:nil].lastObject;
    headerView.titleLabel.text = self.model.content;
    headerView.subLabel.text = [NSString stringWithFormat:@"*共%ld人回答", self.model.total];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

@end
