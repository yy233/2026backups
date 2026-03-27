//
//  LdleGoodsVC.m
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import "LdleGoodsVC.h"
#import "LdleGoodsNotOnLineVC.h"
#import "LdleGoodDetailVC.h"
#import "LdleGoodsTableViewCell.h"
#import "LdleGoodsListViewModel.h"
#import "LdleGoodsModel.h"

#import "FBKVOController.h"
#import "LdleGoodsData.h"

#import "ZYCommunityFairIssueVc.h"

@interface LdleGoodsVC () <UITableViewDelegate,UITableViewDataSource>

{
    FBKVOController *fbKVO;
}

@property (nonatomic,strong) LdleGoodsListViewModel *viewModel;
//
@end

@implementation LdleGoodsVC

#pragma mark ===

- (UITableView *)tableView{
   if (!_tableView) {
       _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
       _tableView.delegate = self;
       _tableView.dataSource = self;
       _tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
   }
   return _tableView;
}


- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 50)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"发布商品"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (LdleGoodsListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[LdleGoodsListViewModel alloc]init];
        _viewModel.typeState = LdleGoods_Type_Up;
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



#pragma mark ===
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的闲置";
    [ShareUserInfo sharedUserInfo].commuityInfo.ID = 1;//test
    [self initView];
    [self addRefresh];
    [self addKvo];
    [self initListData];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}
- (void)initView{
    [self addNavRightBtn];
    
    //
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_tableView.superview).offset(-kGHSafeAreaBottomHeight);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.height.offset(54.0);
        make.bottom.equalTo(_footerView.superview).offset(-kGHSafeAreaBottomHeight+4);//一个小错位防止透过footer还有_tableView
    }];
    
    //
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 54)];
    [self.footerView.footerBtn newAnBtnWithLayerCorNerNum:0.1 withLayerLineWidth:0.0 withLayerLineColor:[UIColor whiteColor]];

}

#pragma mark === navBtn
- (void)addNavRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    [rightBtn setTitle:@"下架商品" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
}
- (void)rightBtnAction{
    DLog(@"下架商品");
    LdleGoodsNotOnLineVC *vc = [[LdleGoodsNotOnLineVC alloc]init];
    [self pushVc:vc];
    
}

- (void)footerBtnAction{
    DLog(@"发布商品");
    // 闲置商品发布
    ZYCommunityFairIssueVc *vc = [[ ZYCommunityFairIssueVc alloc] init];
    vc.type = ZYCommunityFairIssue_Type_Add;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        LdleGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LdleGoodsTableViewCell_I];
        if (!cell) {
            cell = [[LdleGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LdleGoodsTableViewCell_I];
        }
        [cell fillLdleGoodsInfoWithModel:self.dataSourceArr[indexPath.section]];
        return cell;
        
    }else{
        LdleGoodsBottomTwoBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LdleGoodsBottomTwoBtnTableViewCell_I];
        if (!cell) {
            cell = [[LdleGoodsBottomTwoBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LdleGoodsBottomTwoBtnTableViewCell_I];
        }
        WEAKSELF
        cell.touchCellSubBtnBlock = ^(BOOL isRightBtn) {
            if (!isRightBtn) {
                [weakSelf editWithIndex:indexPath.section];
            }else{
                [weakSelf downLineWithIndex:indexPath.section];
            }
        };
        return cell;
    }

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //去详情
    LdleGoodsModel *model = self.dataSourceArr[indexPath.section];
    LdleGoodDetailVC *vc = [[LdleGoodDetailVC alloc]init];
    vc.idStr = model.idStr;
    [self pushVc:vc];
}
#pragma mark ===
- (void)editWithIndex:(NSInteger)index{
    NSLog(@"编辑 %ld",index);
    LdleGoodsModel *model = self.dataSourceArr[index];
    // 闲置商品
    ZYCommunityFairIssueVc *vc = [[ ZYCommunityFairIssueVc alloc] init];
    vc.type = ZYCommunityFairIssue_Type_Edit;
    vc.idStr = model.idStr;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
- (void)downLineWithIndex:(NSInteger)index{
    NSLog(@"下架 %ld",index);
    LdleGoodsModel *model = self.dataSourceArr[index];
    WEAKSELF
    [LdleGoodsData changeTypeThisLdleGoodsWithIdStr:model.idStr withisWillUpThisGoodsBool:NO withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"成功下架！");
            });
            [weakSelf initListData];
        }
    }];}

 
#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 7.5f;
    UIColor *sectionFillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;

    UIColor *separatoColor = Y_ColorWith16FromRGB(0xF0F1F6);
     if ([cell respondsToSelector:@selector(tintColor)]) {
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
        } else if (indexPath.row == 0) {//上部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//下部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
         
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = sectionFillColor.CGColor;
        layer.strokeColor= sectionFillColor.CGColor;
         
         addLine = NO;//不需要系统分割线
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10+35, bounds.size.height-1.0, bounds.size.width-20-35, 1.0);
            [layer addSublayer:lineLayer];
            if (indexPath.section == 0 && indexPath.row==0) {
                lineLayer.backgroundColor = separatoColor.CGColor;
            }else{
                lineLayer.backgroundColor = [UIColor clearColor].CGColor;
            }
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}


@end
