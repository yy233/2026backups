//
//  LdleGoodsNotOnLineVC.m
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import "LdleGoodsNotOnLineVC.h"
#import "LdleGoodsTableViewCell.h"
#import "LdleGoodsListViewModel.h"
#import "LdleGoodsModel.h"

#import "FBKVOController.h"
#import "LdleGoodsData.h"

 
@interface LdleGoodsNotOnLineVC ()
{
    FBKVOController *fbKVO;
}

@property (nonatomic,strong) LdleGoodsListViewModel *viewModel;

@end

@implementation LdleGoodsNotOnLineVC


- (LdleGoodsListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[LdleGoodsListViewModel alloc]init];
        _viewModel.typeState = LdleGoods_Type_Down;
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
            self.dataSourceArr = [LdleGoodsModel mj_objectArrayWithKeyValuesArray:weakSelf.viewModel.dataOfArr];
        
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
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initListData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}

#pragma mark ==
- (void)initListData{
    [self.viewModel getDataListOnePage];
}
- (void)moreData{
    [self.viewModel getDataListNextPage];
}


#pragma mark ==

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下架商品";
}

//重写
- (void)addNavRightBtn{
    //滞空
    [self.navigationItem setRightBarButtonItems:@[]];
}
//重写 无footer
- (void)initView{
    [self changeNavBackColorWithDIsCountBlueAndWW];
    [self addNavRightBtn];
    
    //
    [self.view addSubview:self.tableView];
    WEAKSELF
    [weakSelf.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.tableView.superview);
    }];
    //
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LdleGoodsModel *mdoel = self.dataSourceArr[indexPath.section];
    if (mdoel.shield == 1) {//违规被下架cell //是否被屏蔽或举报
        return  [self tableView:tableView weiGuiCellForRowAtIndexPath:indexPath];
        
    }else{//普通下架cell
        return [self tableView:tableView nomalCellForRowAtIndexPath:indexPath];

    }
}
//违规
- (UITableViewCell *)tableView:(UITableView *)tableView weiGuiCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        LdleGoodsOfShowRedWeiGuiViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LdleGoodsOfShowRedWeiGuiViewTableViewCell_I];
        if (!cell) {
            cell = [[LdleGoodsOfShowRedWeiGuiViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LdleGoodsOfShowRedWeiGuiViewTableViewCell_I];
        }
        [cell fillLdleGoodsInfoWithModel:self.dataSourceArr[indexPath.section]];
        return cell;
    }else{
   
        LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell_I];
        if (!cell) {
            cell = [[LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell_I];
        }
        WEAKSELF
        cell.touchCellSubBtnBlock = ^(BOOL isRightBtn) {
            if (isRightBtn) {
                [weakSelf deletWithIndex:indexPath.section];
            }else{
                [weakSelf againUpWithIndex:indexPath.section];
            }
        };
        cell.oneBtn.hidden = YES;//被强制下架 不显示该按钮
        return cell;
    }
}
//普通
- (UITableViewCell *)tableView:(UITableView *)tableView nomalCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        LdleGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LdleGoodsTableViewCell_I];
        if (!cell) {
            cell = [[LdleGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LdleGoodsTableViewCell_I];
        }
        [cell fillLdleGoodsInfoWithModel:self.dataSourceArr[indexPath.section]];
        return cell;
    }else{
        LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell_I];
        if (!cell) {
            cell = [[LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell_I];
        }
        WEAKSELF
        cell.touchCellSubBtnBlock = ^(BOOL isRightBtn) {
            if (isRightBtn) {
                [weakSelf deletWithIndex:indexPath.section];
            }else{
                [weakSelf againUpWithIndex:indexPath.section];
            }
        };
        cell.oneBtn.hidden = NO;//没有被强制下架 有重新上架btn
        return cell;
    }
}


#pragma mark ===
- (void)againUpWithIndex:(NSInteger)index{
    NSLog(@"重新上架 %ld",index);
    LdleGoodsModel *model = self.dataSourceArr[index];
    WEAKSELF
    [LdleGoodsData changeTypeThisLdleGoodsWithIdStr:model.idStr withisWillUpThisGoodsBool:YES withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"重新上架已成功！");
            });
            [weakSelf initListData];
        }
    }];
}
- (void)deletWithIndex:(NSInteger)index{
    NSLog(@"删除 %ld",index);
    LdleGoodsModel *model = self.dataSourceArr[index];
    WEAKSELF
    [LdleGoodsData deletThisLdleGoodsWithIdStr:model.idStr withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"删除成功！");
            });
            [weakSelf initListData];
        }
    }];
}
@end
