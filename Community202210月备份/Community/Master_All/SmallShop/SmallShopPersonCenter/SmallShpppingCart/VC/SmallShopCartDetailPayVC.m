//
//  SmallShopCartDetailPayVC.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "SmallShopCartDetailPayVC.h"
#import "SmallShopCartDetailPayVcTopAddressTableViewCell.h"
#import "SmallShopCartPayTypeTableViewCell.h"
#import "CartOneGoodsTableViewCell.h"
#import "BaseAddressAndPhoneInfoListVC.h"
//
#import "SmallShopAddressInfoHeader.h"
#import "ZYSmallShopPayData.h"
#import "ZYSmallShopGoodsSpellGroupDetailVc.h"
 
#define CellRow_Height_WaitCountDownTime  (50)
#define CellRow_Height_Goods  (106)

@interface SmallShopCartDetailPayVC () <UITableViewDelegate,UITableViewDataSource,ZYSmallShopContainerRentPayAddressCellDelegate>
@property (nonatomic, strong) NSMutableArray *payWayArray;

@end

@implementation SmallShopCartDetailPayVC

- (ZYSmallShopPayWayPopView *)popView {
    if (!_popView) {
        _popView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopPayWayPopView" owner:nil options:nil].lastObject;
        _popView.delegete = self;
    }

    return _popView;
}
- (NSMutableArray *)payWayArray {
    if (!_payWayArray) {
        _payWayArray = [NSMutableArray array];
    }
    
    return _payWayArray;
}

- (void)subPayWayData{//当前类型不做在cell 内
    if (self.payWayArray.count > 0) {
        [self.payWayArray removeAllObjects];
    }
    NSArray *imagesArray = @[@"cc_wechat_icon", @"cc_zhifubao_icon"];
    NSArray *payTitlesArray = @[@"微信支付", @"支付宝支付"];
    NSArray *typesArray = @[@(ZYSmallShop_Pay_Way_Type_WeChat), @(ZYSmallShop_Pay_Way_Type_Alipay)];
    for (int i = 0; i < imagesArray.count; i++) {
        ZYSmallShopPayWayModel *model = [[ZYSmallShopPayWayModel alloc] init];
        model.image = imagesArray[i];
        model.title = payTitlesArray[i];
        NSNumber *type = typesArray[i];
        model.type = [type integerValue];
        if (i == 0) {
            model.isSelected = YES;
            self.nowPayType = ZYSmallShop_Pay_Way_Type_WeChat;//初始状态为 微信支付类型
        }else {
            model.isSelected = NO;
        }
        [self.payWayArray addObject:model];
    }
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算详情";
    self.isWaitingForPayBool = NO;
    self.isOutTimeBool = NO;
    self.isSuccessPayBool = NO;
    self.saveOrderStrWaitingForPay = @"";
    self.nowPayType = ZYSmallShop_Pay_Way_Type_WeChat;
    self.popView.type = self.nowPayType;
    [self.popView reloadInputViews];
    [self initView];
    [self initData];
    // 注册支付通知
    [self addNoticeOfPay];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self subAddressAndPhoneInfoData];//默认地址信息 更改后需要刷新
}

- (void)initView{
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.separatorColor = [UIColor  clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSmallShopContainerRentPayAddressCell" bundle:nil] forCellReuseIdentifier:SmallShopCartDetailPayVcTopAddressTableViewCell_I];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSmallShopPayWayBaseCell" bundle:nil] forCellReuseIdentifier:@"ZYSmallShopPayWayBaseCell"];
    //
    [self.footerView.payBtn newAnBtnWithTextStr:@"提交订单"];
    [self fillAllMoneyNumWithOnlyMoneyStr:@"0"];
    [self hiddenAllChooseOnlyBtn];//有全选view 但是没有全选选择按钮

}

#pragma mark - 支付相关方法
- (void)addNoticeOfPay{
    Y_NSNotificationCenter_Creat_NameAction(PaySuccessedEndInfo_Notice_Name, paySuccessNotice:);
    Y_NSNotificationCenter_Creat_NameAction(PayFailEndInfo_Notice_Name, payFailNotice:);
}

- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(PaySuccessedEndInfo_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(PayFailEndInfo_Notice_Name);
}

- (void)payFailNotice:(NSNotification *)notice{
    NSString *failMsg =  [notice.userInfo objectForKey:[notice.userInfo allKeys].firstObject];
    Y_SVP_SHOW_INFO_MES(failMsg);
}

- (void)paySuccessNotice:(NSNotification *)notice{
    NSInteger successInfoWithPayTypeNum =  [[notice.userInfo objectForKey:Pay_Success_PayType_Key] integerValue];
    switch (successInfoWithPayTypeNum) {//parmsDicUseWillSendAdd在第一步处理
        case 1:// 1微信支付
        {
            
        }
            break;
        case 2://2支付宝支付
        {
            
        }
            break;
        default:
            break;
    }
    if (self.isSpellGroup) {
        // 发送通知
        Y_NSNotificationCenter_PostNotice_NilObject_Name(@"SMALL_SHOP_PAY_SUCCESS_BACK");
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[ZYSmallShopGoodsSpellGroupDetailVc class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        return;
    }
    ZYSmallShopContainerRentPaySuccessVc *vc = [[ZYSmallShopContainerRentPaySuccessVc alloc] init];
//    ZYSmallShopContainerRentDetailModel *model = [[ZYSmallShopContainerRentDetailModel alloc] init];
//    model.storeAddress = self.model.informationDto.storeAddress;
//    model.storePhone = self.model.informationDto.storePhone;
//    model.latitude = self.model.informationDto.latitude;
//    model.longitude = self.model.informationDto.longitude;
//    vc.model = model;
//    vc.price = self.model.payDto.commoditySellPrice;
 //购物车商品服务公共支付成功跳转数据
    ZYSmallShopContainerRentDetailModel *willShowSuccessInfoModel = [[ZYSmallShopContainerRentDetailModel alloc]init];
    willShowSuccessInfoModel.storeAddress = [TextShowWithModelStr textShowWithModelStr:[SmallShopNowShopShare share].saveNowShopAddress];
    willShowSuccessInfoModel.storePhone = [TextShowWithModelStr textShowWithModelStr:[SmallShopNowShopShare share].saveNowShopPhone];
    willShowSuccessInfoModel.latitude = [SmallShopNowShopShare share].saveNowShopLat;
    willShowSuccessInfoModel.longitude = [SmallShopNowShopShare share].saveNowShopLongi; 
    vc.model = willShowSuccessInfoModel;
    if ([self.nowMoneyStr containsString:@"¥"]) { //购物车有本符号,单个商品服务的数据填充
        vc.price =  [self.nowMoneyStr substringFromIndex:1];//¥符号去掉
    }
 
    [self pushVc:vc];
}

#pragma mark === data
- (void)initData{
    [self subPayWayData];
    [self subGoodsArrData];
    [self subAllMoneyData];
    [self.tableView reloadData];
}
//默认地址信息
- (void)subAddressAndPhoneInfoData{
    WEAKSELF
    [SmallShopAddressData smallShopNomalFirstAddressAndPhoneWithBlock:^(SmallShopAddressInfoModel * _Nonnull addressInfoModel, BOOL isHaveBool) {
        weakSelf.nowAddressStr = [TextShowWithModelStr textShowWithModelStr:addressInfoModel.detail];// [SmallShopAddressShare share].nomallAddressInfoModel.detail;
        weakSelf.nowPhoneStr  =  [TextShowWithModelStr textShowWithModelStr:addressInfoModel.phone];//[SmallShopAddressShare share].nomallAddressInfoModel.phone;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}
//购物车全部被选中的已经直接赋值过来
- (void)subGoodsArrData{
//    self.goodsAr
}
//当前钱详情
- (void)subAllMoneyData{
    [self fillAllMoneyNumWithOnlyMoneyStr:self.nowMoneyStr];
    [self fillCartListActivalInfoWithShowStr:self.nowPayDtoStr];//优惠文本
}

#pragma mark === footer
- (void)touchPayBtnAction{

    WEAKSELF
    [GotoRealNameAuthenticationCardVcTool needGotoRealNameAuthenticationCardVcWithNowVcType:GotoRealNameAuthenticationCardVc_NowVcType_Nomal withBlock:^(BOOL needGotoRealNameVcBool, ZYElectroniNewRealNameAuthenticationCardVcLate * _Nonnull realNameVc) {
        if (needGotoRealNameVcBool) {
            [weakSelf pushVc:realNameVc];
        }else{
            
            if (weakSelf.isOutTimeBool) {//已经超时
                Y_SVP_SHOW_INFO_MES(@"订单等待超时，已关闭支付流程。")
                return;
            }
            //先创建订单 再走支付
            if (weakSelf.isWaitingForPayBool) {
                [weakSelf showPayTypePop];   //pop付钱
            }else{
                [weakSelf creatOrder];//购物车订单生成
            }
        }
    }];
    
   
}



#pragma mark === delegate
//地址cell_subBtnAction
- (void)editButtonEvent{
    DLog(@"");
    if (self.isWaitingForPayBool || self.isOutTimeBool || self.isSuccessPayBool) {// 有订单等待支付  ||  已经超时 || 已经支付
        //不可点击跳转
        Y_SVP_SHOW_INFO_MES(@"订单已经生成，不可更改地址");
        return;
    }
    BaseAddressAndPhoneInfoListVC *vc = [[BaseAddressAndPhoneInfoListVC alloc]init];
    [self pushVc:vc];

}


#pragma mark ===  cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isWaitingForPayBool) {
        return self.goodsArr.count+2;
    }else{
        return self.goodsArr.count+1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isWaitingForPayBool) {
        switch (indexPath.section) {
            case 0:
                return CellRow_Height_WaitCountDownTime;
                break;
            case 1:
                return [tableView fd_heightForCellWithIdentifier:SmallShopCartDetailPayVcTopAddressTableViewCell_I cacheByIndexPath:indexPath configuration:^(SmallShopCartDetailPayVcTopAddressTableViewCell *cell) {
                    [cell fillNewAddressStr:self.nowAddressStr andPhoneStr:self.nowPhoneStr];
                }];
                break;
                
            default:
                return CellRow_Height_Goods;
                break;
        }
    }else{
        switch (indexPath.section) {
            case 0:
                return [tableView fd_heightForCellWithIdentifier:SmallShopCartDetailPayVcTopAddressTableViewCell_I cacheByIndexPath:indexPath configuration:^(SmallShopCartDetailPayVcTopAddressTableViewCell *cell) {
                    [cell fillNewAddressStr:self.nowAddressStr andPhoneStr:self.nowPhoneStr];
                }];
                break;
                
            default:
                return CellRow_Height_Goods;
                break;
        }
        
    }

}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isWaitingForPayBool) {
        if (indexPath.section == 0) { //time
            SmallShopWaitingPayOfTheCountdownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallShopWaitingPayOfTheCountdownTableViewCell_I];
            if (!cell) {
                cell = [[SmallShopWaitingPayOfTheCountdownTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SmallShopWaitingPayOfTheCountdownTableViewCell_I];
            }
            WEAKSELF
            cell.waitingPayOfTheCountdownEndBlock = ^{
                [weakSelf orderOutTimeAction];//超时处理
            };

            return cell;
            
        }else if (indexPath.section == 1) { //地址
            SmallShopCartDetailPayVcTopAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallShopCartDetailPayVcTopAddressTableViewCell_I forIndexPath:indexPath];
            cell.delegate = self;
            [cell fillNewAddressStr:self.nowAddressStr andPhoneStr:self.nowPhoneStr];
            return cell;
            
        }else{//货物
            return [self tableView:tableView oneGoodsCellForRowAtIndexPath:indexPath];
            
        }
        
    }else{
        if (indexPath.section == 0) { //地址
            SmallShopCartDetailPayVcTopAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallShopCartDetailPayVcTopAddressTableViewCell_I forIndexPath:indexPath];
            cell.delegate = self;
            [cell fillNewAddressStr:self.nowAddressStr andPhoneStr:self.nowPhoneStr];
            return cell;
        }else{//货物
            return [self tableView:tableView oneGoodsCellForRowAtIndexPath:indexPath];
        }
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView oneGoodsCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartOneGoodsNotAddDetBtnNotLeftChooseBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CartOneGoodsNotAddDetBtnNotLeftChooseBtnTableViewCell_I ];
    if (!cell) {
        cell = [[CartOneGoodsNotAddDetBtnNotLeftChooseBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CartOneGoodsNotAddDetBtnNotLeftChooseBtnTableViewCell_I];
    }
    if (self.isWaitingForPayBool) {
        [cell fillCartListOneGoodsInfoWithModel: self.goodsArr[indexPath.section-2] ];//s0=time s1= addressCell
    }else{
        [cell fillCartListOneGoodsInfoWithModel: self.goodsArr[indexPath.section-1] ];//s0=addressCell
    }
    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
#pragma mark =========================== 离开本页时的判断
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isWaitingForPayBool &&  !self.isOutTimeBool && !self.isSuccessPayBool) {//在等待 && 未支付 && 未超时 则作超时删本订单
        [self orderOutTimeAction];//超时处理
    }
}

#pragma mark =========================== 订单超时处理
- (void)orderOutTimeAction{
    DLog(@"超时或删除当前订单");
    WEAKSELF
    [SmallShopCartData deletOrderWithOrderStr:self.saveOrderStrWaitingForPay withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            weakSelf.isOutTimeBool = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"已经成功取消当前订单。");
                [weakSelf popVC];
            });
          
        }
    }];
}

#pragma mark =========================== 生成订单

- (void)creatOrder{
    DLog(@"结算前创建订单中 %@",self.footerView.moneyL.text);
    if (self.nowAddressStr.length==0 || self.nowPhoneStr.length==0 ) {
        Y_SVP_SHOW_ERR_MES(@"地址信息有误！");
        return;
    }
    
    WEAKSELF
    NSMutableArray *goodsWillCreatOrderUseArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.goodsArr.count; i++) {
        SmallShopCartListModel *model = self.goodsArr[i];
        NSDictionary *subDic  = @{
            @"commodityId":model.payDto.commodityId,
            @"commodityNumber":@(model.payDto.actualNumber)
        };
        [goodsWillCreatOrderUseArr addObject:subDic];
    }
    
    NSMutableDictionary *creatOrderDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [creatOrderDic  setValue:self.nowAddressStr forKey:@"detail"];
    [creatOrderDic  setValue:self.nowPhoneStr forKey:@"phone"];
    //[creatOrderDic setValue:[SmallShopNowShopShare share].saveNowShopId forKey:@"storeId"];
    [creatOrderDic setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [creatOrderDic setValue:goodsWillCreatOrderUseArr forKey:@"payMoneyParams"];
    
    
    [SmallShopCartData cartCreatOrderWithCartDetailInfoDic:creatOrderDic   withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            weakSelf.isWaitingForPayBool = YES;
            weakSelf.saveOrderStrWaitingForPay = [TextShowWithModelStr textShowWithModelStr:[dic objectForKey:@"order"]];
            NSLog(@"购物车订单生成 == %@ | %@",dic ,weakSelf.saveOrderStrWaitingForPay);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_NSNotificationCenter_PostNotice_NilObject_Name(Notice_SmallShopCarCreatOrderChangeOtherThings);//订单生成就要改变购物车情况
                [weakSelf.tableView reloadData];
                [weakSelf.footerView.payBtn newAnBtnWithTextStr:@"去付款"];
                [weakSelf performSelector:@selector(cellNoticePost) withObject:nil afterDelay:0.5];
            });
        }
    }];
}
#pragma mark ============================== 倒计时间 noticePost
- (void)cellNoticePost{//cell出现后再通知
    Y_NSNotificationCenter_PostNotice_NilObject_Name(kNotice_HaveOrderAndWaitForPay);

}
#pragma mark ============================== 支付类型Popview Show
- (void)showPayTypePop{
    NSLog(@"支付类型Popview Show");
    if ([self.nowMoneyStr containsString:@"¥"]) { //购物车有本符号,单个商品服务的数据填充
        self.popView.priceLabel.text =  [self.nowMoneyStr substringFromIndex:1];//¥符号去掉

    }else{
        self.popView.priceLabel.text =  self.nowMoneyStr;//纯数字的情况
    }
 
     [self.popView showSmallShopPayWayPopView];
}
#pragma mark ============================== 支付

#pragma mark - ZYSmallShopPayWayPopViewDelegate
- (void)okButtonEvent {
    NSLog(@"确认付款");
    WEAKSELF
    //net
    weakSelf.isSuccessPayBool = YES;//已经支付
    [weakSelf.popView hiddenSmallShopPayWayPopView];
    
    if (self.popView.type == ZYSmallShop_Pay_Way_Type_WeChat) {
        [ZYSmallShopPayData weChatPayWithOrderNum:self.saveOrderStrWaitingForPay];
    }else if (self.popView.type == ZYSmallShop_Pay_Way_Type_Alipay) {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"暂未实现" toView:self.view];
    }
}

- (void)weixinViewEvent {
    NSLog(@"微信");
    self.popView.type = ZYSmallShop_Pay_Way_Type_WeChat;
    [self.popView reloadInputViews];
}

- (void)zhifubaoVieEvent {
    NSLog(@"支付宝");
    self.popView.type = ZYSmallShop_Pay_Way_Type_Alipay;
    [self.popView reloadInputViews];
}

#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isWaitingForPayBool) {
        if (indexPath.section==0 || indexPath.section==1 ) {
            return;
        }
    }else{
        if (indexPath.section==0) {
            return;
        }
    }
   
    
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
            //
            [layer addSublayer:lineLayer];
            if ((indexPath.section == [tableView numberOfSections]-1 ) && (indexPath.row == 0)) {
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
