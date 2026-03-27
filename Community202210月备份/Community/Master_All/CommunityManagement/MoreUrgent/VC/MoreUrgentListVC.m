//
//  MoreUrgentListVC.m
//  Community
//
//  Created by 余莹 on 2020/11/19.
//

#import "MoreUrgentListVC.h"
#import "UrgentInfoOrTopInfoDetailVC.h"
#import "MoreUrgentTableViewCell.h"
#define MoreMenuTableViewCell_Identifier @"MoreMenuTableViewCell"
@interface MoreUrgentListVC ()
@property (nonatomic,assign) NSInteger pageNum;
@end

@implementation MoreUrgentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"消息";//紧急消息 通知 list
    [self addRefresh];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(updata)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
    
}
#pragma mark == init
- (void)initData{//主页紧急消息
    self.pageNum = 1;
    Y_SVP_SHOW_MES_IsLoading_15Delay
    if (self.isTopInfoVcDetailListVc==NO) {
        [self initThisCommunityListData];
    }else{//总小区列表 跳转加载
        [self initTopVcDetailCommunityListData];//根据社区id查
    }
}
- (void)initThisCommunityListData{
    [MainUrgentMessageListViewModel getCenterUrgentMessageListDataWithListBlock:^(NSArray * arr,BOOL success) {
        [self initGetResultWithArr:arr andRestlt:success];
    }];
}
- (void)initTopVcDetailCommunityListData{
    [MainUrgentMessageListViewModel getTopInfoDetailUrgentListInitDataWithCommunityId:self.communityId listBlock:^(NSArray * arr, BOOL success) {
        [self initGetResultWithArr:arr andRestlt:success];
    }];
}
- (void)initGetResultWithArr:(NSArray *)arr andRestlt:(BOOL)success{
    dispatch_async(dispatch_get_main_queue(), ^{
        Y_SVP_DISMISS
        [self.tableView.mj_header endRefreshing];
    });
    if (success) {
        self.pageNum+=1;
        self.dataSourceArr = [NSMutableArray arrayWithArray:[TableViewTopAndCenterBannerCellModel mj_objectArrayWithKeyValuesArray:arr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arr.count<Y_PAGE_SIZE) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            [self.tableView reloadData];
        });
    }else{
    }
}
#pragma mark == updata
- (void)updata{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    if (self.isTopInfoVcDetailListVc==NO) {
        [self updataThisCommunityListData];
    }else{//总小区列表 跳转加载
        [self updataTopVcDetailCommunityListData];//根据社区id查
    }
}
- (void)updataThisCommunityListData{
    [MainUrgentMessageListViewModel getCenterUrgentMoreMessageListUpDateWithPageNum:self.pageNum listBlock:^(NSArray * arr,BOOL success) {
        [self updataGetResultWithArr:arr andRestlt:success];
    }];
}
- (void)updataTopVcDetailCommunityListData{
    [MainUrgentMessageListViewModel getTopInfoDetailUrgentListUpDateWithCommunityId:self.communityId WithPageNum:self.pageNum listBlock:^(NSArray * arr,BOOL success) {
        [self updataGetResultWithArr:arr andRestlt:success];
    }];
}
- (void)updataGetResultWithArr:(NSArray *)arr andRestlt:(BOOL)success{
    dispatch_async(dispatch_get_main_queue(), ^{
        Y_SVP_DISMISS
        [self.tableView.mj_footer endRefreshing];
    });
    if (success) {
        self.pageNum+=1;
        [self.dataSourceArr addObjectsFromArray:[NSMutableArray arrayWithArray:[TableViewTopAndCenterBannerCellModel mj_objectArrayWithKeyValuesArray:arr]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arr.count<Y_PAGE_SIZE) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            [self.tableView reloadData];
        });
    }else{
    }
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreUrgentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreMenuTableViewCell_Identifier];
    if (!cell) {
        cell = [[MoreUrgentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoreMenuTableViewCell_Identifier];
    }
    cell.model = self.dataSourceArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//详情
    UrgentInfoOrTopInfoDetailVC *detailVc = [[UrgentInfoOrTopInfoDetailVC alloc]init];
    TableViewTopAndCenterBannerCellModel *model =  self.dataSourceArr[indexPath.row];
    if (self.isTopInfoVcDetailListVc==NO) {
        detailVc.communityId =  [ShareUserInfo sharedUserInfo].commuityInfo.ID;
    }else{//总小区列表 跳转加载
        detailVc.communityId  = self.communityId;
    }
    detailVc.infoId = model.id;
    [self.navigationController pushViewController:detailVc animated:YES];
}


- (BOOL)isTopInfoVcDetailListVc{
    if (!_isTopInfoVcDetailListVc) {
        _isTopInfoVcDetailListVc = NO;
    }
    return _isTopInfoVcDetailListVc;
}
@end
