//
//  SmallShopCartListVC.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "SmallShopCartListVC.h"
#import "CartOneGoodsTableViewCell.h"
//
#import "SmallShopCartHeader.h"
//
#import "SmallShopCartDetailPayVC.h" //结算详情
#import "SmallShopOneGoodsPayVC.h"
//
#import "FBKVOController.h"



@interface SmallShopCartListVC () <UITableViewDelegate,UITableViewDataSource>
//kvo
{
    FBKVOController *fbKVO;
}
@property (nonatomic,strong) NSMutableArray *goodsChooseTypeSaveArr;
@property (nonatomic,strong) SmallShopCartListViewModel *viewModel;

@end

@implementation SmallShopCartListVC

- (NSMutableArray *)goodsChooseTypeSaveArr{
    if (!_goodsChooseTypeSaveArr) {
        _goodsChooseTypeSaveArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _goodsChooseTypeSaveArr;
}

- (SmallShopCartListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[SmallShopCartListViewModel alloc]init];
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
                if (weakSelf.viewModel.dataOfArr.count<=0) {//失败状态&&当前0count底部结算隐藏｜成功则在dataarr内处理显示隐藏
                    [self hiddenAllChooseView];
                }else{
                    [self showAllChooseBtnView];
                }
            });
        }
    }else  if ([fbKvoKeyPath isEqualToString:kViewModel_dataOfArr]) {//data
        //SUCCESS
        dispatch_async(dispatch_get_main_queue(), ^{
            self.goodsArr = [SmallShopCartListModel mj_objectArrayWithKeyValuesArray:weakSelf.viewModel.dataOfArr];
            for (int i = 0; i < self.goodsArr.count; i++) {
                [self.goodsChooseTypeSaveArr addObject:@(0)];
            }
            
             [weakSelf.tableView reloadData];
            if (weakSelf.viewModel.dataOfArr.count >= Y_PAGE_SIZE_10) {
                weakSelf.tableView.mj_footer.hidden = NO;
            }else{
                weakSelf.tableView.mj_footer.hidden = YES;
                if (weakSelf.viewModel.dataOfArr.count<=0) {
                    [self hiddenAllChooseView];
                }else{
                    [self showAllChooseBtnView];
                }
            }
         });
    }else{
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.footerView.allChooseBtn.selected = NO;//全选按钮
    [self fillAllMoneyNumWithOnlyMoneyStr:@"0"];
    [self addRefresh];
    [self addKvo];
    [self initData];
    [self addNoticeOfCreatOrderChangeThisCart];//在个人中心内 有订单生成 就需要处理刷新购物车相关数据
}
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

 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return self.goodsArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartOneGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CartOneGoodsTableViewCell_I ];
    if (!cell) {
        cell = [[CartOneGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CartOneGoodsTableViewCell_I];
    }
    WEAKSELF
    cell.touchChooseBtnBlock = ^(UIButton * _Nonnull chooseBtn) {
        [weakSelf changeSelfChooseTypeWithSectionNum:indexPath.section andChooseBtnSelectedBool:chooseBtn.selected];
    };
    cell.touchAddBtnBlock = ^(NSInteger nowCount) {//+
        [weakSelf changeModelSubCountAddWithSectionNum:indexPath.section andNowCount:nowCount];
    };
    cell.touchDeletBtnBlock = ^(NSInteger nowCount) {//-
        [weakSelf changeModelSubCountDetWithSectionNum:indexPath.section andNowCount:nowCount];

    };
    //全选/全不选 更新时用到
    [cell changeChoooseBtnSelectedType: [ self.goodsChooseTypeSaveArr[indexPath.section]  boolValue] ];
    //普通赋值
    SmallShopCartListModel *model = self.goodsArr[indexPath.section];
    [cell fillCartListOneGoodsInfoWithModel:model];
    return cell;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//cell删除相关
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
  
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteWithDataIndex:(indexPath.section)];
    }
   
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
     
}

//cell删除相关end
#pragma mark == 删除
- (void)deleteWithDataIndex:(NSInteger)dataIndex{
    WEAKSELF
    SmallShopCartListModel *model = self.goodsArr[dataIndex];
    [SmallShopCartData myCartDelInfoWithIdArrs:@[@(model.ID)].mutableCopy withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            [weakSelf.goodsArr removeObjectAtIndex:dataIndex];
            [weakSelf.goodsChooseTypeSaveArr removeObjectAtIndex:dataIndex];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
 
#pragma mark == 数量更改

- (void)changeModelSubCountAddWithSectionNum:(NSInteger)sectionNum andNowCount:(NSInteger)nowCount{
    WEAKSELF
    [self changeModelSubCountWithSectionNum:sectionNum andNowCount:nowCount withSuccessBlock:^(BOOL isSuccessChange) {
        if (!isSuccessChange) {
            //加法失败 | 还原UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)changeModelSubCountDetWithSectionNum:(NSInteger)sectionNum andNowCount:(NSInteger)nowCount{
    WEAKSELF
    [self changeModelSubCountWithSectionNum:sectionNum andNowCount:nowCount withSuccessBlock:^(BOOL isSuccessChange) {
        if (!isSuccessChange) {
            //减法失败 | 还原UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

- (void)changeModelSubCountWithSectionNum:(NSInteger)sectionNum andNowCount:(NSInteger)nowCount withSuccessBlock:( void((^)(BOOL isSuccessChange)) )block{
    WEAKSELF
    
    SmallShopCartListModel *model = self.goodsArr[sectionNum];
    [SmallShopCartData myCartchangeOneGoodsCountNumWithId:[TextShowWithModelStr textShowWithModelStr:model.payDto.commodityId] withNowCount:nowCount withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        block(success);
        if(success){//加减成功 listcount 更新数据 + 钱 更新
            model.commodityNumber = nowCount;
            [SmallShopCartData myCartChangeCountOfGetMoneyInfoWithOneGoodsID:model.payDto.commodityId withNowCount:nowCount withBlock:^(NSDictionary * _Nonnull dic, BOOL success) { 
                if (success) {//钱 更新成功
                    SmallShopCartSubPayDtoModel *payDto = [SmallShopCartSubPayDtoModel mj_objectWithKeyValues:dic];
                    //价格更新
                   model.payDto = payDto;
                    //数量更新（折扣/满减/满送/等——so数量和金额都要更新）
                    model.commodityNumber = payDto.actualNumber;
                    model.payDto.actualNumber = payDto.actualNumber;
                    [weakSelf.goodsArr replaceObjectAtIndex:sectionNum withObject:model];
                    [weakSelf addUpAllChooseGoodsOfAllMoney];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
                }else{//更新失败
                }
              
            }];
        
        }
    }];


}

#pragma mark == 选择
- (void)changeSelfChooseTypeWithSectionNum:(NSInteger)sectionNum andChooseBtnSelectedBool:(BOOL)isSelected{
    for (int i = 0; i < self.goodsChooseTypeSaveArr.count; i++) {
        if (i == sectionNum) {//替换选中状态
            [self.goodsChooseTypeSaveArr replaceObjectAtIndex:sectionNum  withObject:  [NSNumber numberWithBool:isSelected] ];
        }
    }
    [self addUpAllChooseGoodsOfAllMoney];
}
#pragma mark == 算钱
- (void)addUpAllChooseGoodsOfAllMoney{
    //选择的拆出来算总金额

     CGFloat nowAllMoney = 0;
    NSInteger haveMorePayDtoType = 0;
    SmallShopCartSubPayDtoModel *payDtoModel = [[SmallShopCartSubPayDtoModel alloc]init];
     for (int i = 0; i < self.goodsChooseTypeSaveArr.count; i++) {
         if ([self.goodsChooseTypeSaveArr[i] isEqual:@(1)]) {
             SmallShopCartListModel *goodsModel =   self.goodsArr[i];
             nowAllMoney +=  [goodsModel.payDto.actualPrice floatValue];//某货物 当前数量的活动后总价格
             if (goodsModel.payDto.activityType>0) {
                 haveMorePayDtoType += 1;
                 if (haveMorePayDtoType == 1) {
                     payDtoModel = goodsModel.payDto;
                 }
             }
         }
     }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nowAllMoney == 0) {
            [self fillAllMoneyNumWithOnlyMoneyStr:@"0.0"];
            [self fillOneGoodsDetailThisActualInfoWithPayDto:payDtoModel];//空数据 清空 折扣相关文本

        }else{
            [self fillAllMoneyNumWithOnlyMoneyStr: [NSString stringWithFormat:@"%0.2f",nowAllMoney]];
            if (haveMorePayDtoType==1) {
                [self fillOneGoodsDetailThisActualInfoWithPayDto:payDtoModel];
               //[self fillCartListActualInfoWithShowStr:@"（单个商品有优惠 已经折算）"];
            }else if (haveMorePayDtoType > 1){
                [self fillCartListActivalInfoWithShowStr:@"（叠加优惠 已经折算）"];
            }else{
                [self fillOneGoodsDetailThisActualInfoWithPayDto:payDtoModel];//有折扣换没折扣的数据 则做清空 折扣相关文本
            }
          
        }
    });
}

#pragma mark === footer

- (void)touchAllChooseBtnAction{
    DLog(@"全选/全不选");
    BOOL nowAllChooseSelectedBool = NO;
    self.footerView.allChooseBtn.selected = ! self.footerView.allChooseBtn.selected;
    nowAllChooseSelectedBool = self.footerView.allChooseBtn.selected;
    //
    for (int i = 0; i < self.goodsChooseTypeSaveArr.count; i++) {
        [self.goodsChooseTypeSaveArr replaceObjectAtIndex:i withObject: [NSNumber numberWithBool:nowAllChooseSelectedBool]];
    }
    [self.tableView reloadData];//cell_SelectedTypeUI
    [self addUpAllChooseGoodsOfAllMoney];//算钱

 
}

- (void)touchPayBtnAction{
    
    WEAKSELF
    [GotoRealNameAuthenticationCardVcTool needGotoRealNameAuthenticationCardVcWithNowVcType:GotoRealNameAuthenticationCardVc_NowVcType_Nomal withBlock:^(BOOL needGotoRealNameVcBool, ZYElectroniNewRealNameAuthenticationCardVcLate * _Nonnull realNameVc) {
        if (needGotoRealNameVcBool) {
            [weakSelf pushVc:realNameVc];
        }else{
            BOOL isHaveChooseData = NO;
            NSMutableArray *nowChooseDataArr = [[NSMutableArray alloc]initWithCapacity:0];
            for (int i = 0; i < weakSelf.goodsChooseTypeSaveArr.count; i++) {
                BOOL chooseTypeOfOneData = [weakSelf.goodsChooseTypeSaveArr[i] boolValue];
                if (chooseTypeOfOneData) {
                    isHaveChooseData = YES;
                    [nowChooseDataArr addObject:weakSelf.goodsArr[i]];
                }
            }
            if (!isHaveChooseData) {//没有选中任意data
                Y_SVP_SHOW_ERR_MES(@"请选中您想结算的物品！");//  计算后有选商品才去详情 带上被选中的数据
                return;
            }
         
            DLog(@"去结算详情页： %@",weakSelf.footerView.moneyL.text);
            SmallShopCartDetailPayVC *vc = [[SmallShopCartDetailPayVC alloc]init];
            vc.goodsArr = nowChooseDataArr;//被选中的商品项目
            vc.nowMoneyStr = weakSelf.footerView.moneyL.text;//总金额
            vc.nowPayDtoStr = weakSelf.footerView.payDtoInfoL.text;//优惠文本
            [weakSelf pushVc:vc];
        }
    }];
    
    //test
//    SmallShopOneGoodsPayVC *vc = [[SmallShopOneGoodsPayVC alloc]init];
//    [self pushVc:vc];
    
 
}


- (void)addNoticeOfCreatOrderChangeThisCart{
    Y_NSNotificationCenter_Creat_NameAction(Notice_SmallShopCarCreatOrderChangeOtherThings, initData);

}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_SmallShopCarCreatOrderChangeOtherThings)
}


#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
  
    CGFloat cornerRadius = 7.5f;
    UIColor *sectionFillColor = [UIColor whiteColor];
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
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];// CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);//过小
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-1.0, bounds.size.width-20, 1.0);
            //[layer addSublayer:lineLayer];  lineLayer.backgroundColor = [UIColor clearColor].CGColor;
            
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}


@end
