//
//  ActivityListVC.m
//  Community
//
//  Created by 余莹 on 2022/6/6.
//

#import "ActivityListVC.h"
#import "ActivityDetailVC.h"
#import "ActivityListVcTableViewCell.h"
#import "ActivityListUseModel.h"
#import "ActivityListViewModelData.h"
#import "FBKVOController.h"
@interface ActivityListVC ()
{
    FBKVOController *fbKVO;
}
@property (nonatomic,strong) ActivityListViewModelData *viewModel;
@end

@implementation ActivityListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动报名";
    [self initView];
    [self addRefresh];
    [self addKvo];
}
- (void)initView{
    [self changeNavBackColorWithDIsCountBlueAndWW];
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 15)];
}

- (ActivityListViewModelData *)viewModel{
    if (!_viewModel) {
        _viewModel = [[ActivityListViewModelData alloc]init];
    }
    return _viewModel;
}
#pragma mark ==
- (void)addKvo{
     
    fbKVO = [FBKVOController controllerWithObserver:self];
    //列表
    WEAKSELF
    NSArray *listKvoKeyArr = @[kViewModel_dataOfArr,
                                    kViewModel_thisIsSuccessBool];//keyPaths keyPath
    [fbKVO observe:self.viewModel  keyPaths:listKvoKeyArr  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *fbKvoKeyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
        DLog(@"fbKvoKeyPath = %@ ; objectChangeInfoData==%@ observerVM==%@   changeO= =%@ ",fbKvoKeyPath,change,object,observer);
        [weakSelf getKVoPathStr:fbKvoKeyPath];
    }];
   
}
- (void)getKVoPathStr:(NSString *)fbKvoKeyPath{
    WEAKSELF
    if ([fbKvoKeyPath isEqualToString:kViewModel_thisIsSuccessBool]){//msg
        //success or fail
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
         });
        
        if (weakSelf.viewModel.thisIsSuccessBool) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(weakSelf.viewModel.showMsgStr);//成功有提示
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_MES(weakSelf.viewModel.showMsgStr);//请求失败有提示
            });
        }
    }else  if ([fbKvoKeyPath isEqualToString:kViewModel_dataOfArr]) {//data
        //SUCCESS
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataSourceArr = [ActivityListUseModel mj_objectArrayWithKeyValuesArray:weakSelf.viewModel.dataOfArr];
        
             [weakSelf.tableView reloadData];
            if (weakSelf.viewModel.dataOfArr.count >= Y_PAGE_SIZE_10) {
                weakSelf.tableView.mj_footer.hidden = NO;
            }else{
                weakSelf.tableView.mj_footer.hidden = YES;
            }
         });
    }else{
    }
}


#pragma mark ==
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}

#pragma mark ==
- (void)initData{
    [self.viewModel getDataListOnePage];
}
- (void)moreData{
    [self.viewModel getDataListNextPage];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (Screen_W-32)*(0.853);
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityListVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityListVcTableViewCell_I];
    
    if (!cell) {
        cell = [[ActivityListVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ActivityListVcTableViewCell_I];
    }
    [cell fillDataModel:self.dataSourceArr[indexPath.section]];
    return cell;
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    ActivityDetailVC *vc = [[ActivityDetailVC alloc]init];
    vc.listModel =  self.dataSourceArr[indexPath.section];
    [self pushVc:vc];
}
 
@end
