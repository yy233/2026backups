//
//  ZYAccessRecordVc.m
//  Community
//
//  Created by ZY on 2022/4/25.
//

#import "ZYAccessRecordVc.h"
#import "ZYAccessRecordSettingVc.h"
#import "ZYAccessRecordTopHeaderView.h"
#import "ZYAccessRecordHeaderView.h"
#import "ZYAccessRecordCell.h"
#import "ZYAccessRecordMemberPopView.h"
#import "ZYAccessRecordVisitPermitModel.h"

static NSString * const ZYAccessRecordCellID = @"ZYAccessRecordCell";
#define kZYAccessRecordTopHeaderViewHeight 160
#define kZYAccessRecordHeaderViewHeight 48
#define kZYAccessRecordCellHeight 90

@interface ZYAccessRecordVc () <UITableViewDataSource, UITableViewDelegate, ZYAccessRecordTopHeaderViewDelegate, ZYAccessRecordMemberPopViewDelegate>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) ZYAccessRecordTopHeaderView *topHeaderView;

@property (nonatomic, strong) NSMutableArray *memberArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ZYAccessRecordMemberPopView *popView;

@property (nonatomic, assign) NSInteger currentPage;

// 是否切换成员
@property (nonatomic, assign) BOOL isSwitchMember;

// 当前选中的成员
@property (nonatomic, strong) ZYAccessRecordVisitPermitModel *currentMemberModel;

@end

@implementation ZYAccessRecordVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"出入记录";
    [self setUI];
    [self customTableView];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf initVisitRecordListData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf initVisitRecordListData];
        // 禁用header
        weakSelf.tableView.mj_header.hidden = YES;
    }];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_Dark) {
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initVisitPermitListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor];
}

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [navRightBtn setTitle:@"访问设置" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[ZYThemeManager shareManager].navigationItemThemeColor forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}

// 访问设置
- (void)navRightBtnAction {
    NSLog(@"访问设置");
    ZYAccessRecordSettingVc *vc = [[ZYAccessRecordSettingVc alloc] init];
    vc.originalArray = [self.memberArray copy];
    [self pushVc:vc];
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

- (ZYAccessRecordTopHeaderView *)topHeaderView {
    if (!_topHeaderView) {
        _topHeaderView = [[NSBundle mainBundle] loadNibNamed:@"ZYAccessRecordTopHeaderView" owner:nil options:nil].lastObject;
        _topHeaderView.delegate = self;
    }
    
    return _topHeaderView;
}

- (ZYAccessRecordMemberPopView *)popView {
    if (!_popView) {
        _popView = [[NSBundle mainBundle] loadNibNamed:@"ZYAccessRecordMemberPopView" owner:nil options:nil].lastObject;
        _popView.delegate = self;
    }
    
    return _popView;
}

- (NSMutableArray *)memberArray {
    if (!_memberArray) {
        _memberArray = [NSMutableArray array];
    }
    
    return _memberArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
// 加载可访问的成员列表数据
- (void)initVisitPermitListData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kVisitPermitListUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.dataArray.count) {
                self.tableView.mj_footer.hidden = YES;
            }
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    if (self.memberArray.count > 0) {
                        [self.memberArray removeAllObjects];
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYAccessRecordVisitPermitModel class] json:responsObject[@"data"]];
                    [self.memberArray addObjectsFromArray:array];
                    if (self.memberArray.count > 0) {
                        self.tableView.hidden = NO;
                    }
                    if (self.isSwitchMember) {
                        Y_SVP_DISMISS
                        NSMutableArray *mArr = [NSMutableArray array];
                        for (ZYAccessRecordVisitPermitModel *model in self.memberArray) {
                            [mArr addObject:model.name];
                        }
                        self.popView.dataArray = [mArr copy];
                        [self.popView showAccessRecordMemberPopView];
                    }else {
                        self.currentMemberModel = [self.memberArray firstObject];
                        self.topHeaderView.model = self.currentMemberModel;
                        self.currentPage = 1;
                        [self initVisitRecordListData];
                        // 业主和家属
                        if (self.currentMemberModel.relation == 1 || self.currentMemberModel.relation == 2) {
                            [self rightBarButtonItemCustom];
                        }
                    }
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

// 加载出入记录列表数据
- (void)initVisitRecordListData {
    if (isNil(self.currentMemberModel)) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    NSDictionary *params = @{@"page" : @(self.currentPage), @"size" : @"100", @"query" : @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID), @"mobile" : self.currentMemberModel.mobile}};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kVisitRecordListUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
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
                ZYAccessRecordModel *model = [ZYAccessRecordModel yy_modelWithJSON:responsObject[@"data"]];
                NSArray *array = model.records;
                NSInteger currentTotal = 0;
                for (ZYAccessRecordDataModel *tempDataModel in array) {
                    for (int i = 0; i < tempDataModel.entityList.count; i++) {
                        currentTotal++;
                    }
                }
                [self.dataArray addObjectsFromArray:array];
                // 判断数据是否加载完了
                if (currentTotal >= model.total) {
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
    [self.tableView registerNib:[UINib nibWithNibName:ZYAccessRecordCellID bundle:nil] forCellReuseIdentifier:ZYAccessRecordCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1 + self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != 0) {
        ZYAccessRecordDataModel *model = self.dataArray[section - 1];
        
        return model.entityList.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        ZYAccessRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYAccessRecordCellID forIndexPath:indexPath];
        ZYAccessRecordDataModel *dataModel = self.dataArray[indexPath.section - 1];
        ZYAccessRecordDataListModel *model = dataModel.entityList[indexPath.row];
        cell.model = model;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYAccessRecordCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return self.topHeaderView;
    }else {
        ZYAccessRecordHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYAccessRecordHeaderView" owner:nil options:nil].lastObject;
        ZYAccessRecordDataModel *model = self.dataArray[section - 1];
        headerView.titleLabel.text = model.time;
        
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return kZYAccessRecordTopHeaderViewHeight;
    }else {
        
        return kZYAccessRecordHeaderViewHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataArray.count) {
        
        return 15;
    }
    
    return 0;
}

#pragma mark - ZYAccessRecordTopHeaderViewDelegate
// 切换成员
- (void)switchButtonEvent {
    NSLog(@"切换成员");
    self.isSwitchMember = YES;
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initVisitPermitListData];
}

#pragma mark - ZYAccessRecordMemberPopViewDelegate
- (void)contentViewEventWithIndex:(NSInteger)index {
    NSLog(@"选择成员%ld", index);
    [self.popView hiddenAccessRecordMemberPopView];
    self.currentMemberModel = self.memberArray[index];
    self.topHeaderView.model = self.currentMemberModel;
    if ([self.currentMemberModel.mobile isEqual:[ShareUserInfo sharedUserInfo].userInfo.mobile]) {
        // 业主和家属
        if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel == 1 || [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel == 2) {
            [self rightBarButtonItemCustom];
        }
    }else {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    self.currentPage = 1;
    [self initVisitRecordListData];
}

@end
