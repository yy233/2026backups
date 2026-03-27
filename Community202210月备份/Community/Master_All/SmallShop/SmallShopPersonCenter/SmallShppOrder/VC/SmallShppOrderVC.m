//
//  SmallShppOrderVC.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "SmallShppOrderVC.h"
#import "SmallShppOrderTableViewCell.h"
#import "FBKVOController.h"
#import "SmallShopOrderDetailVC.h"


@interface SmallShppOrderVC ()
//kvo
{
    FBKVOController *fbKVO;
}
@property (nonatomic,strong) SmallShppOrderViewModel *viewModel;
@end

@implementation SmallShppOrderVC

#pragma mark ==
- (SmallShppOrderViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[SmallShppOrderViewModel alloc]init];
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
    if ([fbKvoKeyPath isEqualToString:kViewModel_thisIsSuccessBool]){//bool->msg
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    [self initView];
    [self addRefresh];
    [self addKvo];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavigationBarWhiteStyle];
}
- (void)initView{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.viewModel.dataOfArr.count;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SmallShppOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallShppOrderTableViewCell_I ];
    if(!cell){
        cell = [[SmallShppOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SmallShppOrderTableViewCell_I];
    }
    [cell fillDataWithOrderModel:self.viewModel.dataOfArr[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"");
    SmallShopOrderDetailVC *vc = [[SmallShopOrderDetailVC alloc]init];
    SmallShppOrderModel *model =  self.viewModel.dataOfArr[indexPath.row];
    vc.thisOrderId = model.orderId; 
    vc.listModel = model;
     vc.nowDetailVcShowType = model.type;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ==
 
 
@end
