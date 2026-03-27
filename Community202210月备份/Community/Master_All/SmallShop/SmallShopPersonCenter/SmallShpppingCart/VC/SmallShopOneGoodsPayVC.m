//
//  SmallShopOneGoodsPayVC.m
//  Community
//
//  Created by 余莹 on 2022/3/3.
//购买详情 区别于结算详情，它是单一个商品的结算，物品只一样，数量可加减。

#import "SmallShopOneGoodsPayVC.h"
#import "CartOneGoodsTableViewCell.h"
//
#import "ZYSmallShopGoodsDetailModel.h"
#import "ZYSmallShopServiceDetailModel.h"
//
@interface SmallShopOneGoodsPayVC ()
@property (nonatomic,assign) NSInteger saveThisId;
@property (nonatomic, copy) NSString *spellId;
@property (nonatomic,assign) NSInteger saveThisNumber;
//@property (nonatomic,strong) NSString *
@property (nonatomic,strong) SmallShopCartListModel *useShowModel;
@end

@implementation SmallShopOneGoodsPayVC
- (SmallShopCartListModel *)useShowModel{
    if (!_useShowModel) {
        _useShowModel = [[SmallShopCartListModel alloc]init];
    }
    return _useShowModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买详情";

 }
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarWhiteStyle];
}
- (NSMutableDictionary *)detailVcUseModelDic{
    if (!_detailVcUseModelDic) {
        _detailVcUseModelDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _detailVcUseModelDic;
}
- (void)subGoodsArrData{
    self.saveThisNumber = 1;//初始数量1
    //单一个商品的结算
    switch (self.nowGoodsSeviceBoxType) {
        case SmallShopOneGoodsPayVC_Type_Goods://ZYSmallShopGoodsDetailModel
        {
            ZYSmallShopGoodsDetailModel *goodsModel = [ZYSmallShopGoodsDetailModel yy_modelWithJSON:self.detailVcUseModelDic];
            self.useShowModel.ID = [goodsModel.ID integerValue];
            self.saveThisId = self.useShowModel.ID;
            self.useShowModel.commodityName = goodsModel.commodityName;
            self.useShowModel.commodityHeadImg = goodsModel.commodityHeadImg;
            self.useShowModel.commodityNumber = goodsModel.payDto.actualNumber;//count
            self.useShowModel.payDto = [[SmallShopCartSubPayDtoModel alloc]init];
            self.useShowModel.payDto.commodityOriginalPrice = goodsModel.payDto.commodityOriginalPrice;
            self.useShowModel.payDto.actualPrice = goodsModel.payDto.actualPrice;
            self.useShowModel.payDto.actualNumber = 1;
            self.goodsArr = @[  self.useShowModel].mutableCopy;
            self.useShowModel.payDto.activityType = goodsModel.payDto.activityType;
            self.useShowModel.payDto.activityFull= goodsModel.payDto.activityFull;
            self.useShowModel.payDto.activityGive = goodsModel.payDto.activityGive;
            self.useShowModel.payDto.commodityId = goodsModel.payDto.commodityId;//增减数量时的价格计算
            [self fillOneGoodsDetailThisActualInfoWithPayDto:self.useShowModel.payDto];//优惠文本
            self.popView.priceLabel.text = goodsModel.payDto.commoditySellPrice;
        }
            break;
        case SmallShopOneGoodsPayVC_Type_Service://ZYSmallShopServiceDetailModel
        {
            ZYSmallShopServiceDetailModel *goodsModel = [ZYSmallShopServiceDetailModel yy_modelWithJSON:self.detailVcUseModelDic];
            self.useShowModel.ID = [goodsModel.ID integerValue];
            self.saveThisId = self.useShowModel.ID;
            self.useShowModel.commodityName = goodsModel.serveName;
            self.useShowModel.commodityHeadImg = goodsModel.serveHeadImg;
            self.useShowModel.commodityNumber = 1;//count
            self.useShowModel.payDto = [[SmallShopCartSubPayDtoModel alloc]init];
            self.useShowModel.payDto.commodityOriginalPrice = goodsModel.serveOriginalPrice;
            self.useShowModel.payDto.actualPrice = goodsModel.serveSellPrice;
            self.useShowModel.payDto.actualNumber = 1;
            self.goodsArr = @[ self.useShowModel ].mutableCopy;
            self.popView.priceLabel.text = goodsModel.serveSellPrice;
        }
            break;
        case SmallShopOneGoodsPayVC_Type_Box:
        {
            //货柜暂时不用这个界面
        }
            break;
            
        case SmallShopOneGoodsPayVC_Type_SpellGroupActivities://ZYSmallShopGoodsDetailModel 拼团｜只有商品类型
        {
            ZYSmallShopGoodsDetailModel *goodsModel = [ZYSmallShopGoodsDetailModel yy_modelWithJSON:self.detailVcUseModelDic];
            self.useShowModel.ID = [goodsModel.ID integerValue];
            self.saveThisId = self.useShowModel.ID;
            self.spellId = goodsModel.spellId;
            self.useShowModel.commodityName = goodsModel.commodityName;
            self.useShowModel.commodityHeadImg = goodsModel.commodityHeadImg;
            self.useShowModel.commodityNumber = goodsModel.payDto.actualNumber;//count
            self.useShowModel.payDto = [[SmallShopCartSubPayDtoModel alloc]init];
            self.useShowModel.payDto.commodityOriginalPrice = goodsModel.payDto.commodityOriginalPrice;
            self.useShowModel.payDto.actualPrice = goodsModel.payDto.actualPrice;
            self.useShowModel.payDto.actualNumber = 1;
            self.goodsArr = @[  self.useShowModel].mutableCopy;
            self.useShowModel.payDto.activityType = goodsModel.payDto.activityType;
            self.useShowModel.payDto.activityFull= goodsModel.payDto.activityFull;
            self.useShowModel.payDto.activityGive = goodsModel.payDto.activityGive;
            [self fillOneGoodsDetailThisActualInfoWithPayDto:self.useShowModel.payDto];//优惠文本
            [self footerViewIsRedOrangeBackColor];//拼团颜色更改
            self.model = goodsModel;
            self.popView.priceLabel.text = self.model.payDto.commoditySellPrice;
            self.isSpellGroup = YES;
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}
- (void)subAllMoneyData{
    switch (self.nowGoodsSeviceBoxType) {
        case SmallShopOneGoodsPayVC_Type_Goods://ZYSmallShopGoodsDetailModel
        {
            ZYSmallShopGoodsDetailModel *goodsModel = [ZYSmallShopGoodsDetailModel yy_modelWithJSON:self.detailVcUseModelDic];
            self.nowMoneyStr = goodsModel.payDto.actualPrice;
        }
            break;
        case SmallShopOneGoodsPayVC_Type_Service://ZYSmallShopServiceDetailModel
        {
            ZYSmallShopServiceDetailModel *goodsModel = [ZYSmallShopServiceDetailModel yy_modelWithJSON:self.detailVcUseModelDic];
            self.nowMoneyStr = goodsModel.serveSellPrice;
        }
            break;
        case SmallShopOneGoodsPayVC_Type_Box:
        {
            //货柜暂时不用这个界面
        }
            break;
        case SmallShopOneGoodsPayVC_Type_SpellGroupActivities://ZYSmallShopGoodsDetailModel
        {
            ZYSmallShopGoodsDetailModel *goodsModel = [ZYSmallShopGoodsDetailModel yy_modelWithJSON:self.detailVcUseModelDic];
            self.nowMoneyStr = goodsModel.payDto.actualPrice;
        }
            break;
        default:
            break;
    }
    [self fillAllMoneyNumWithOnlyMoneyStr:self.nowMoneyStr];
}
- (UITableViewCell *)tableView:(UITableView *)tableView oneGoodsCellForRowAtIndexPath:(NSIndexPath *)indexPath {//商品类型可以加数量 其他就1个数量值
   
    if (self.nowGoodsSeviceBoxType ==  SmallShopOneGoodsPayVC_Type_Goods ) {
        
        CartOneGoodsNotLeftChooseBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CartOneGoodsNotLeftChooseBtnTableViewCell_I ];
        if (!cell) {
            cell = [[CartOneGoodsNotLeftChooseBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CartOneGoodsNotLeftChooseBtnTableViewCell_I];
        }
        
        WEAKSELF
        cell.touchAddBtnBlock = ^(NSInteger nowCount) {//+
            [weakSelf changeModelSubCountAddWithSectionNum:indexPath.section andNowCount:nowCount];
        };
        cell.touchDeletBtnBlock = ^(NSInteger nowCount) {//-
            [weakSelf changeModelSubCountDetWithSectionNum:indexPath.section andNowCount:nowCount];

        };
        //赋值
        [cell fillCartPayDetailVcSubGoodsArrFirstInfoOfDetailVCModeInfoWithModel:self.goodsArr.firstObject];
        if (self.isWaitingForPayBool || self.isOutTimeBool || self.isSuccessPayBool) {// 有订单等待支付  ||  已经超时 || 已经支付
            [cell addBtnAndDeletBtnUserInteractionEnabledSetNo];
        }
        return cell;
        
    }else{// (self.nowGoodsSeviceBoxType == SmallShopOneGoodsPayVC_Type_Service || self.nowGoodsSeviceBoxType == SmallShopOneGoodsPayVC_Type_SpellGroupActivities){//无+-UI 可省略不写
        
        CartOneServiceNotLeftChooseBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CartOneServiceNotLeftChooseBtnTableViewCell_I ];
        if (!cell) {
            cell = [[CartOneServiceNotLeftChooseBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CartOneServiceNotLeftChooseBtnTableViewCell_I];
        }
        WEAKSELF
        cell.touchAddBtnBlock = ^(NSInteger nowCount) {//+
            [weakSelf changeModelSubCountAddWithSectionNum:indexPath.section andNowCount:nowCount];
        };
        cell.touchDeletBtnBlock = ^(NSInteger nowCount) {//-
            [weakSelf changeModelSubCountDetWithSectionNum:indexPath.section andNowCount:nowCount];
        };
        //赋值
        [cell fillCartPayDetailVcSubGoodsArrFirstInfoOfDetailVCModeInfoWithModel:self.goodsArr.firstObject];
        if (self.isWaitingForPayBool || self.isOutTimeBool || self.isSuccessPayBool) {// 有订单等待支付  ||  已经超时 || 已经支付
            [cell addBtnAndDeletBtnUserInteractionEnabledSetNo];
        }
        return cell;
    }
  
}
 
#pragma mark == 数量更改 (本界某不需要sectionNum 直接firstObj | self.showModel)

- (void)changeModelSubCountAddWithSectionNum:(NSInteger)sectionNum andNowCount:(NSInteger)nowCount{
    WEAKSELF
    [self changeModelSubCountWithSectionNum:sectionNum andNowCount:nowCount withSuccessBlock:^(BOOL isSuccessChange) {
        if (!isSuccessChange) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)changeModelSubCountDetWithSectionNum:(NSInteger)sectionNum andNowCount:(NSInteger)nowCount{
    if (self.useShowModel.payDto.activityType == 3) {//满送类型 处理数量要使之可减少
        DLog(@"满送类型 处理数量要使之可减少 待处理");
        if ((nowCount % ([self.useShowModel.payDto.activityFull integerValue]) == 0) ||(nowCount % ([self.useShowModel.payDto.activityFull integerValue]) ==  [self.useShowModel.payDto.activityGive integerValue])) {// 请求结果 会出现 送的数量 叠加上去 ，导致无法减少 做多减
            nowCount -= 1;//[self.useShowModel.payDto.activityGive integerValue];
        }
    }
    WEAKSELF
    [self changeModelSubCountWithSectionNum:sectionNum andNowCount:nowCount withSuccessBlock:^(BOOL isSuccessChange) {
        if (!isSuccessChange) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

- (void)changeModelSubCountWithSectionNum:(NSInteger)sectionNum andNowCount:(NSInteger)nowCount withSuccessBlock:( void((^)(BOOL isSuccessChange)) )block{
    block(YES);//无需调用购物车数量更改接口 可直接yes刷新UI｜后需要拿到新的 金额
    WEAKSELF
    //加减成功 listcount 更新数据 + 钱 更新
    self.useShowModel.commodityNumber = nowCount;
    self.useShowModel.payDto.actualNumber = nowCount;
    [SmallShopCartData myCartChangeCountOfGetMoneyInfoWithOneGoodsID:self.useShowModel.payDto.commodityId  withNowCount:nowCount withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {//钱 更新成功
            SmallShopCartSubPayDtoModel *payDto = [SmallShopCartSubPayDtoModel mj_objectWithKeyValues:dic];
            //价格更新
            self.useShowModel.payDto = payDto;
            //数量更新（折扣/满减/满送/等——so数量和金额都要更新）
            self.useShowModel.commodityNumber = payDto.actualNumber;
            self.useShowModel.payDto.actualNumber = payDto.actualNumber;
            [weakSelf.goodsArr replaceObjectAtIndex:0 withObject:self.useShowModel];//替换成新的
            [weakSelf addUpAllChooseGoodsOfAllMoney];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }else{//更新失败
        }
        
    }];
    
    
}

#pragma mark == 算钱
- (void)addUpAllChooseGoodsOfAllMoney{
    //选择的拆出来算总金额
    
    CGFloat nowAllMoney = 0;
    for (int i = 0; i < self.goodsArr.count; i++) {
        SmallShopCartListModel *goodsModel =   self.goodsArr[i];
        nowAllMoney +=  [goodsModel.payDto.actualPrice floatValue];//某货物 当前数量的活动后总价格
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nowAllMoney == 0) {
            [self fillAllMoneyNumWithOnlyMoneyStr:@"0.0"];
        }else{
            [self fillAllMoneyNumWithOnlyMoneyStr: [NSString stringWithFormat:@"%0.2f",nowAllMoney]];
            [self fillOneGoodsDetailThisActualInfoWithPayDto:self.useShowModel.payDto];
        }
    });
}



#pragma mark =========================== 重写 生成订单
//购物车订单生成
- (void)creatOrder{
    DLog(@"结算前创建订单中 %@",self.footerView.moneyL.text);
    if (self.nowAddressStr.length==0 || self.nowPhoneStr.length==0 ) {
        Y_SVP_SHOW_ERR_MES(@"地址信息有误！");
        return;
    }
 
    WEAKSELF
    if (self.nowGoodsSeviceBoxType == SmallShopOneGoodsPayVC_Type_SpellGroupActivities) {//拼团是商品拼团
        NSDictionary *params = @{@"commodityId" : @(self.saveThisId), @"spellId" : self.spellId, @"detail" : self.nowAddressStr, @"phone" : self.nowPhoneStr};
        [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:ZY_BASEURL(kSmallShopSpellGroupOrderUrl) withBody:params finished:^(id responsObject, NSError *error) {
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSString *orderId = responsObject[@"data"];
                    NSLog(@"%@", orderId);
                    //去支付
                    weakSelf.isWaitingForPayBool = YES;
                    weakSelf.saveOrderStrWaitingForPay = [TextShowWithModelStr textShowWithModelStr:orderId];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                        [weakSelf.footerView.payBtn newAnBtnWithTextStr:@"去付款"];
                        [weakSelf performSelector:@selector(cellNoticePost) withObject:nil afterDelay:0.5];
                    });
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        }];
    }else{
        NSMutableDictionary *creatOrderDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [creatOrderDic  setValue:self.nowAddressStr forKey:@"detail"];
        [creatOrderDic  setValue:self.nowPhoneStr forKey:@"phone"];
        [creatOrderDic setValue:@(self.saveThisNumber) forKey:@"numOrType"];//商品或服务是数量  柜子type
        [creatOrderDic setValue:@(self.saveThisId) forKey:@"id"];
        [creatOrderDic setValue:@(self.nowGoodsSeviceBoxType ) forKey:@"type"];//商品1  服务2  柜子3
        [SmallShopCartData  oneGoodSeiviceBoxCreatOrderWithInfoDic:creatOrderDic  withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
            if (success) {
                //去支付
                weakSelf.isWaitingForPayBool = YES;
                weakSelf.saveOrderStrWaitingForPay = [TextShowWithModelStr textShowWithModelStr:[dic objectForKey:@"order"]];
                NSLog(@"商品或者服务的订单生成 == %@ | %@",dic ,weakSelf.saveOrderStrWaitingForPay);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    [weakSelf.footerView.payBtn newAnBtnWithTextStr:@"去付款"];
                    [weakSelf performSelector:@selector(cellNoticePost) withObject:nil afterDelay:0.5];
                });
            }
        }];
    }
}

@end
