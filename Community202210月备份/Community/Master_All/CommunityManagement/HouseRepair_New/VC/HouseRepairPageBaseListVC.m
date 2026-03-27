//
//  HouseRepairPageBaseListVC.m
//  Community
//
//  Created by 余莹 on 2022/3/4.
//

#import "HouseRepairPageBaseListVC.h"
#import "FBKVOController.h"
#import "MyRepairMainListViewModel.h"
#import "HouseRepairPageBaseListTableViewCell.h"
//
#import "ZYReportAboutRepairApplyVc.h"// 报事报修申请服务
#import "HouseRepairOldInputLookDetailVC.h"//详情

@interface HouseRepairPageBaseListVC ()
//kvo
{
    FBKVOController *fbKVO;
}
@property (nonatomic,strong) MyRepairMainListViewModel *viewModel;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation HouseRepairPageBaseListVC

- (MyRepairMainListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[MyRepairMainListViewModel alloc]init];
    }
    return _viewModel;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[HouseRepairListVcFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn setTitle:@"一键报修" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavBackColorWithDDndWIsGW];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
    [self addRefresh];
    [self addKvo];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    [self changeNavBackColorWithDDndWIsGW];
//    - (void)changeNavBackColorWithDIsCountBlueAndWW;//深色 内容蓝色 ，浅色 白色
//    - (void)changeNavBackColorWithDIsCountBlueAndGW;//深色 内容蓝色 ，浅色 灰白色
//    - (void)changeNavBackColorWithDDAndWW;//深色 重蓝色 ，浅色 白色
//    - (void)changeNavBackColorWithDDndWIsGW;//深色 重蓝色 ，浅色 非白偏灰色 （就是原本baseNav）
//    @end
}
 
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upNextPageData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}
 
#pragma mark ===
- (void)initData{
    [self.viewModel getDataListOnePageWithType:self.nowListType];
}

- (void)upNextPageData{
    [self.viewModel getDataListNextPage];
}
#pragma mark ===
- (void)addKvo{
    fbKVO = [FBKVOController controllerWithObserver:self];
    
    
    //店铺列表
    WEAKSELF
    NSArray *listKvoKeyArr = @[kViewModel_dataOfArr,
                                    kViewModel_thisIsSuccessBool];//keyPaths keyPath
    [fbKVO observe:self.viewModel  keyPaths:listKvoKeyArr  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *fbKvoKeyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
        DLog(@"fbKvoKeyPath = %@ ; objectChangeInfoData==%@ observerVM==%@   changeO= =%@ ",fbKvoKeyPath,change,object,observer);
        [weakSelf getListKVoPathStr:fbKvoKeyPath];
    }];
}
- (void)getListKVoPathStr:(NSString *)fbKvoKeyPath{
    WEAKSELF
    if ([fbKvoKeyPath isEqualToString:kViewModel_dataOfArr]) {
        //数据更改
        self.dataSourceArr  = [NSMutableArray arrayWithArray:self.viewModel.dataOfArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            if (weakSelf.viewModel.dataOfArr.count >= Y_PAGE_SIZE_10 ) {
                weakSelf.tableView.mj_footer.hidden = NO;
            }else{
                weakSelf.tableView.mj_footer.hidden = YES;
            }
        });
    }else if ([fbKvoKeyPath isEqualToString:kViewModel_thisIsSuccessBool]){//得到当次请求状态
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
        });
        if (weakSelf.viewModel.thisIsSuccessBool) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(weakSelf.viewModel.showMsgStr);
            });
       
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_MES(weakSelf.viewModel.showMsgStr);
            });
          
        }
    }else{//kViewModel_showMsgStr
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyRepairPageListUseModel *model = [[MyRepairPageListUseModel alloc]init];
    model = self.dataSourceArr[indexPath.row];
    //
    HouseRepairPageBaseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairPageBaseListTableViewCell_I];
    if (!cell) {
        cell = [[HouseRepairPageBaseListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairPageBaseListTableViewCell_I];
    }
    [cell fillDataWithModel:model];
    return cell;
     
}
 
#pragma mark ==

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HouseRepairOldInputLookDetailVC *showVc = [[HouseRepairOldInputLookDetailVC alloc]init];
    MyRepairPageListUseModel *mdoel = self.dataSourceArr[indexPath.row];
    showVc.model = mdoel;
    WEAKSELF
    showVc.detailVcCancelOneUpInfo = ^{
        [weakSelf.tableView.mj_header beginRefreshing];;
    };
    [self pushVc:showVc];
}

#pragma mark ==

- (void)footerBtnAction{
    
    ZYReportAboutRepairApplyVc *vc = [[ZYReportAboutRepairApplyVc alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];

}
@end
