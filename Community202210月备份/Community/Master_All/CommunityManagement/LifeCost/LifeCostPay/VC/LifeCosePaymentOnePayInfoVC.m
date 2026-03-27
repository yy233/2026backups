//
//  LifeCosePaymentOnePayInfoVC.m
//  Community
//
//  Created by 余莹 on 2021/1/9.
//旧版

#import "LifeCosePaymentOnePayInfoVC.h"
#import "LifeCostPaymentDetailsListVC.h"
#import "LifeCosePaymentOnePayChageMoneyEndVC.h"

#import "LifeCostMyCostDetailModel.h"

#import "LifeCosePaymentOnePayInfoTopMoneyCell.h"
#import "LifeCosePaymentOnePayInfoTextCell.h"
#import "LifeCosePaymentOnePayInfoTextAndBtnCell.h"
#import "LifeCosePaymentOnePayInfoChargeMoneyCell.h"
//
#define LifeCosePaymentOnePayInfoTopMoneyCell_Identifier              @"LifeCosePaymentOnePayInfoTopMoneyCell"
#define LifeCosePaymentOnePayInfoTextCell_Identifier                  @"LifeCosePaymentOnePayInfoTextCell"
#define LifeCosePaymentOnePayInfoTextAndBtnCell_Identifier            @"LifeCosePaymentOnePayInfoTextAndBtnCell"
#define LifeCosePaymentOnePayInfoChargeMoneyCell_Identifier           @"LifeCosePaymentOnePayInfoChargeMoneyCell"

//
#import "PopViewChooseLifeCostChoosePayType.h"
#import "VersionShowOrHiddenTool.h"
//
#define H_topCell   100
#define H_textCell  30
#define H_textAndBtnCell 40
#define H_bottomRechargeMoneyCell  90
#define Last_Section_Num 3
@interface LifeCosePaymentOnePayInfoVC () <UITextFieldDelegate,BasePopTableViewChooseDelegate>
@property (nonatomic,strong) PopViewChooseLifeCostChoosePayType *PopViewPayTypeChoose;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) NSString *cellTextStr;
@property (nonatomic,strong) NSMutableArray *sectionOneTitleArr;
//
@property (nonatomic,strong) NSMutableDictionary *parmsDicUseWillSendAdd;//支付成功后add接口所用数据
//
@property (nonatomic,strong) NSMutableArray *popViewPayTypeChooseListTextArr;
@end

@implementation LifeCosePaymentOnePayInfoVC

- (void)viewDidLoad {
    self.cellTextStr = @"";
////    if ([WXApi isWXAppInstalled]) {//暂不使用这个
//    [VersionShowOrHiddenTool getVersionInfoBoolWithBool:^(BOOL isShowView) {
//        if (isShowView) {
//            self.popViewPayTypeChooseListTextArr = [[NSMutableArray alloc]initWithObjects:@"支付宝",@"微信", nil];
//        }else{
//            self.popViewPayTypeChooseListTextArr = [[NSMutableArray alloc]initWithObjects:@"支付宝", nil];
//        }
//
//    }];
    //0406改
    
    [VersionShowOrHiddenTool getVersionInfoBoolWithBool:^(BOOL succes, BOOL isShowBool) {
        if (succes && isShowBool ) {
            self.popViewPayTypeChooseListTextArr = [PayBaseInfo share].payTypeStrArr;
        }else{
            self.popViewPayTypeChooseListTextArr = [PayBaseInfo share].payTypeStrArr_HidenWX;
        }
    }];
 
  
    [super viewDidLoad];
    self.title = @"生活缴费";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
    [self initRightNavItem];
    [self addRefresh];
    [self addNoticeOfPay];
}

- (void)initRightNavItem{
    UIButton *goChargeListItem = [UIButton buttonWithType:UIButtonTypeCustom];
    goChargeListItem.titleLabel.font = [UIFont systemFontOfSize:12];
    [goChargeListItem setTitle:@"缴费记录" forState:UIControlStateNormal];
    [goChargeListItem setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    goChargeListItem.bounds = CGRectMake(0 , 0, 24, 24);
    [goChargeListItem addTarget:self action:@selector(chargeListItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *goListBar = [[UIBarButtonItem alloc]initWithCustomView:goChargeListItem];
    [self.navigationItem setRightBarButtonItem:goListBar animated:YES];
}
- (void)chargeListItemAction{
    NSLog(@"chargeListItemAction");
    LifeCostPaymentDetailsListVC *listVc = [[LifeCostPaymentDetailsListVC alloc]init];
    listVc.familyId = self.thisCostDetailmodel.familyId;
    [self pushVc:listVc];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}

- (void)addNoticeOfPay{
    Y_NSNotificationCenter_Creat_NameAction(PaySuccessedEndInfo_Notice_Name, paySuccessNotice:);
    Y_NSNotificationCenter_Creat_NameAction(PayFailEndInfo_Notice_Name, payFailNotice:);
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(PaySuccessedEndInfo_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(PayFailEndInfo_Notice_Name);
}
//___
- (void)initData{
    NSLog(@"initData");
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(self.listOldModel.companyId) forKey:@"companyId"];
    [parms setValue:@(self.listOldModel.familyId) forKey:@"familyId"];
     
    [[ToolOfNetWork sharedTools]YrequestPostURLStrWithAllURLNoParmsNotMainQueue:URL_life_MyCost_detail withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
            });
            if (Y_IS_Success) {
                NSDictionary *dic = [[responsObject allKeys]containsObject:@"data"] ? responsObject[@"data"] :@{};
                if ([dic allKeys].count==0) {
                    Y_SVP_SHOW_ERR_MES(@"数据结构异常");
                    return;
                }
                self.thisCostDetailmodel = [LifeCostMyCostDetailModel mj_objectWithKeyValues:[NSMutableDictionary dictionaryWithDictionary:dic]];//Y_ResponsObject_dataDic
                NSString *userName = [TextShowWithModelStr textShowWithModelStr:self.thisCostDetailmodel.familyName];
                NSString *userNo = [NSString stringWithFormat:@"%ld",(long)self.thisCostDetailmodel.familyId];
                NSString *userUnit = [TextShowWithModelStr textShowWithModelStr:self.thisCostDetailmodel.companyName];
                NSString *address = [TextShowWithModelStr textShowWithModelStr:self.thisCostDetailmodel.address];
                self.sectionOneContentArr  = [[NSMutableArray alloc]initWithObjects:userName,userNo,userUnit,address, nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark == 缴费接口
- (void)footerBtnAc{
    NSLog(@"充钱  %@",self.cellTextStr);
    if (self.cellTextStr.length==0 || self.cellTextStr == nil) {
        Y_SVP_SHOW_INFO_MES(@"未输入金额！");
        return;
    }
    //
    self.parmsDicUseWillSendAdd =  [[NSMutableDictionary alloc]init];
    //listOldMode
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    //
    [parms setValue:self.thisCostDetailmodel.address        forKey:@"address"];
    [parms setValue:self.thisCostDetailmodel.familyId       forKey:@"familyId"];//户号
    [parms setValue:self.thisCostDetailmodel.familyName     forKey:@"familyName"];
    [parms setValue:self.listOldModel.groupName             forKey:@"groupName"]; //分组名称
    [parms setValue:@(0.00)                                 forKey:@"accountBalance"];//账户余额
    [parms setValue:@(self.listOldModel.companyId)          forKey:@"companyId"];//单位id
    [parms setValue:@(self.thisCostDetailmodel.typeId)      forKey:@"typeId"]; // 缴费类型,如水电气
    NSNumber *costMoneyNum = [NSNumber numberWithDouble:[self.cellTextStr doubleValue]];
    [parms setValue:costMoneyNum                            forKey:@"paymentBalance"];//付款金额
    self.parmsDicUseWillSendAdd = parms; //提交add接口之前使用
    [self choosePayType];
}
- (void)choosePayType{
    [self.PopViewPayTypeChoose showInView:self.view thePopViewTableViewHeight:0 WithArray:self.popViewPayTypeChooseListTextArr];
}

#pragma mark == 选择付款类型
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    NSString *payTypeStr = self.popViewPayTypeChooseListTextArr[indexPath.row];
    NSLog(@" payTypeStr = %@",payTypeStr);
    WEAKSELF
    [GotoRealNameAuthenticationCardVcTool needGotoRealNameAuthenticationCardVcWithNowVcType:GotoRealNameAuthenticationCardVc_NowVcType_Nomal withBlock:^(BOOL needGotoRealNameVcBool, ZYElectroniNewRealNameAuthenticationCardVcLate * _Nonnull realNameVc) {
        if (needGotoRealNameVcBool) {
            [weakSelf pushVc:realNameVc];
        }else{
        
            if ([self.popViewPayTypeChooseListTextArr containsObject:@"微信"]) {
                
                switch ( [ [PayBaseInfo share].payTypeStrIndexArr[indexPath.row] intValue ] ) {
                    case PayBaseInfo_TypeIndex_ZFB:
                        [weakSelf goZFBPay];
                        break;
                    case PayBaseInfo_TypeIndex_WeChat:
                        [weakSelf goWeChatPay];
                        break;
                    default:
                        NSLog(@"选择付款类型");
                        break;
                }
            }else{
                switch ( [ [PayBaseInfo share].payTypeStrIndexArr_HidentWeChat[indexPath.row] intValue ] ) {
                    case PayBaseInfo_TypeIndex_ZFB:
                        [weakSelf goZFBPay];
                        break;
                    default:
                        NSLog(@"选择付款类型");
                        break;
                }
                    
            }
        }
    }];
    
   
    
//    NSString *payTypeStr = self.popViewPayTypeChooseListTextArr[indexPath.row];
//    if ([payTypeStr isEqualToString:@"支付宝"]) {
//        [self goZFBPay];
//    }else if ([payTypeStr isEqualToString:@"微信"]){
//        [self goWeChatPay];
//    }else{
//        NSLog(@"选择付款类型");
//    }
//    switch (indexPath.row) {
//        case 0://选择微信
//        {
//            [self goWeChatPay];
//        }
//            break;
//        case 1://选择支付宝
//        {
//            [self goZFBPay];
//        }
//            break;
//
//        default:
//            NSLog(@"选择付款类型");
//            break;
//    }
}


#pragma mark ===
- (void)goWeChatPay{
    
    
    //[WeChatPayData weChatPayOfOrderNumStr:self.dataOrderIdStr];//  20220406改版
      
      
      /**
        20220406改版  待改 **/
       
       
       
    Y_SVP_SHOW_MES_IsDealing_15Delay
    
    //
     [WillPayGetOrderViewModel willWeChatPayMoneyNum:[self.cellTextStr doubleValue]  withPayOrderType:PayOrder_Type_LifeCost withDescriptionStr:[TextShowWithModelStr textShowWithModelStr:self.thisCostDetailmodel.companyName] withGetOrderInfo:^(WillPayOrderInfoModel * model, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            PayReq *req   = [[PayReq alloc] init];
            req.openID = [TextShowWithModelStr textShowWithModelStr:model.appid] ;                   //商家id
            req.nonceStr  = [TextShowWithModelStr textShowWithModelStr:model.noncestr];
            req.timeStamp = [[TextShowWithModelStr textShowWithModelStr:model.timestamp] intValue];  //时间戳
            req.package   = [TextShowWithModelStr textShowWithModelStr:model.package];
            req.partnerId = [TextShowWithModelStr textShowWithModelStr:model.partnerid];
            req.prepayId  = [TextShowWithModelStr textShowWithModelStr:model.prepayid];
            req.sign      = [TextShowWithModelStr textShowWithModelStr:model.sign];
            //orderNum 用于后续的
            [self.parmsDicUseWillSendAdd setValue:[TextShowWithModelStr textShowWithModelStr:model.orderNum] forKey:@"orderNum"];
            [self.parmsDicUseWillSendAdd setValue:@(1)   forKey:@"payTpye"];           // 1微信支付，2支付宝支付，3账户余额，4其他银行卡
            [self.parmsDicUseWillSendAdd setValue:@"微信" forKey:@"payTypeName"];
            dispatch_async( dispatch_get_main_queue(), ^{
                [[WeChatPayManager shareManager] hangleWechatPayWithPayReq:req];  //gowx
            });
        }
    }];
    
}
#pragma mark ===
- (void)goZFBPay{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [WillPayGetOrderViewModel willZFBPayMoneyNum:[self.cellTextStr doubleValue] withPayOrderType:PayOrder_Type_LifeCost withGetOrderInfo:^(WillPayOrderInfoModel * model, BOOL success) {
        if (success) {
            NSString *zfbOrderStr = [TextShowWithModelStr textShowWithModelStr:model.orderStr];
        
            //orderNum 用于后续的
            [self.parmsDicUseWillSendAdd setValue:[TextShowWithModelStr textShowWithModelStr:model.orderNum] forKey:@"orderNum"];
            [self.parmsDicUseWillSendAdd setValue:@(2)   forKey:@"payTpye"];           // 1微信支付，2支付宝支付，3账户余额，4其他银行卡
            [self.parmsDicUseWillSendAdd setValue:@"支付宝" forKey:@"payTypeName"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ZfbPayManager shareManager] hangleZFPayOrderStr:zfbOrderStr];//Community //alisdkdemo zhsj_zfb_2021002119679359
            });
        }
    }];
}
 

#pragma mark ======= notice—————————— pay  get
- (void)payFailNotice:(NSNotification *)notice{
    NSString *failMsg =  [notice.userInfo objectForKey:[notice.userInfo allKeys].firstObject];
    Y_SVP_SHOW_INFO_MES(failMsg);
}

- (void)paySuccessNotice:(NSNotification *)notice{
    NSInteger successInfoWithPayTypeNum =  [[notice.userInfo objectForKey:Pay_Success_PayType_Key] integerValue];
    switch (successInfoWithPayTypeNum) {//parmsDicUseWillSendAdd在第一步处理
        case 1:// 1微信支付
        {
            [self weChatPaySuccessAfterAddParmsSend:self.parmsDicUseWillSendAdd];
        }
            break;
        case 2://2支付宝支付
        {
            [self zfbPaySuccessAfertAddParmsSned:self.parmsDicUseWillSendAdd];
        }
            break;
        case 3://3账户余额
        {

        }
            break;
        case 4://4其他银行卡
        {

        }
            break;

        default:
            break;
    }

}
#pragma mark === 微信 end
- (void)weChatPaySuccessAfterAddParmsSend:(NSMutableDictionary *)parms{
    [self paySuccessAddOrder:parms];
}
#pragma mark == 支付宝 end
- (void)zfbPaySuccessAfertAddParmsSned:(NSMutableDictionary *)parms{
    [self paySuccessAddOrder:parms];
    
}
//水电气已缴纳成功后 订单历史新增数据接口 是生活缴费水电气独立的流程接口
- (void)paySuccessAddOrder:(NSMutableDictionary *)parms{
    [WillPayGetOrderViewModel lifeCostAddOrderWithParms:parms withBaseBlock:^(NSDictionary * dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                LifeCosePaymentOnePayChageMoneyEndVC *chargeMoneyEndVc = [[LifeCosePaymentOnePayChageMoneyEndVC alloc]init];
                [self pushVc:chargeMoneyEndVc];
            });
        }
    }];
}
#pragma mark ===
- (void)openChargeBtnAction{
    NSLog(@"去开通");
}


#pragma mark ==
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if(section==1){
        return 4;
    }else if(section==2){
        return 2;
    }else{
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return [UIView new];//顶部圆占空位
    }else {
        UIView *backv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 1)];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(16+10, 0, Screen_W-32-20, 1)];
        lineV.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
        [backv addSubview:lineV];
        return backv;//模拟分割线
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 30;//顶部圆占空位
    }else {
        return 1;//模拟分割线
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section==0) {
        return H_topCell;
    }else if(indexPath.section==1) {
        return H_textCell;
    }else if(indexPath.section==2) {
        if (indexPath.row==0) {
            return H_textCell;
        }else{
            return H_textAndBtnCell;
        }
    }else if(indexPath.section==3) {
        return H_bottomRechargeMoneyCell;
    }else{
        return 1;
    }
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        LifeCosePaymentOnePayInfoTopMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCosePaymentOnePayInfoTopMoneyCell_Identifier];
        if (!cell) {
            cell = [[LifeCosePaymentOnePayInfoTopMoneyCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCosePaymentOnePayInfoTopMoneyCell_Identifier];
        }
        cell.moneyL.text = [NSString stringWithFormat:@"¥%0.2f",self.thisCostDetailmodel.accountBalance];
        return cell;
      
    }else if(indexPath.section==1){
        LifeCosePaymentOnePayInfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCosePaymentOnePayInfoTextCell_Identifier];
        if (!cell) {
            cell = [[LifeCosePaymentOnePayInfoTextCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCosePaymentOnePayInfoTextCell_Identifier];
        }
        cell.titleL.text = self.sectionOneTitleArr[indexPath.row];
        cell.detailL.text = self.sectionOneContentArr[indexPath.row];
        return cell;
    }else if(indexPath.section==2){
        if (indexPath.row==0) {
            LifeCosePaymentOnePayInfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCosePaymentOnePayInfoTextCell_Identifier];
            if (!cell) {
                cell = [[LifeCosePaymentOnePayInfoTextCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCosePaymentOnePayInfoTextCell_Identifier];
            }
            cell.titleL.text = @"余额";
            cell.detailL.text = @"0.0";
            return cell;
        }else{
            LifeCosePaymentOnePayInfoTextAndBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCosePaymentOnePayInfoTextAndBtnCell_Identifier];
            if (!cell) {
                cell = [[LifeCosePaymentOnePayInfoTextAndBtnCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCosePaymentOnePayInfoTextAndBtnCell_Identifier];
            }
            [cell.openChargeBtn addTarget:self action:@selector(openChargeBtnAction) forControlEvents:UIControlEventTouchUpInside];
            cell.titleL.text = @"自动缴费";
            return cell;
        }
        
    }else{
        LifeCosePaymentOnePayInfoChargeMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCosePaymentOnePayInfoChargeMoneyCell_Identifier];
        if (!cell) {
            cell = [[LifeCosePaymentOnePayInfoChargeMoneyCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCosePaymentOnePayInfoChargeMoneyCell_Identifier];
        }
        cell.textField.delegate = self;
        return cell;
    }
}

#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            CGFloat cornerRadius = 7.0f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
            BOOL addLine = NO;
            
            if (indexPath.section==0 && indexPath.row==0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            }else if(indexPath.section==Last_Section_Num && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            }else{
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            
            //颜色修改
            layer.fillColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
            layer.strokeColor=[ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                //            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                //            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
                
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}
#pragma mark==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 90)];
        [_footerView setBtnFram:CGRectMake(0, 20, Screen_W-32, 50)];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAc) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.footerBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    }
    return _footerView;
}

#pragma mark ==

#pragma mark ===
#pragma mark ==== textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL isHaveDian = YES;
    if ([self.cellTextStr rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([self.cellTextStr length]==0){
                if(single == '.'){
                   [self alertView:@"亲，第一个数字不能为小数点"];
                    [self.cellTextStr stringByReplacingCharactersInRange:range withString:@""];
                    return NO;

                }
                if (single == '0') {
                    [self alertView:@"亲，第一个数字不能为0"];
                    [self.cellTextStr stringByReplacingCharactersInRange:range withString:@""];
                    return NO;

                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [self alertView:@"亲，您已经输入过小数点了"];
                    [self.cellTextStr stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[self.cellTextStr rangeOfString:@"."];
                    int tt=range.location-ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        [self alertView:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self alertView:@"亲，您输入的格式不正确"];
            [self.cellTextStr stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
    return YES;
}
- (void)alertView:(NSString *)str{
    Y_SVP_SHOW_INFO_MES(str);
}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    self.cellTextStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


#pragma mark ==
- (PopViewChooseLifeCostChoosePayType *)PopViewPayTypeChoose{
    _PopViewPayTypeChoose = [[PopViewChooseLifeCostChoosePayType alloc]init];
    _PopViewPayTypeChoose.delegate = self;
    return _PopViewPayTypeChoose;
}
- (NSMutableArray *)popViewPayTypeChooseListTextArr{
    if (!_popViewPayTypeChooseListTextArr) {
        _popViewPayTypeChooseListTextArr = [[NSMutableArray alloc]init];
    }
    return _popViewPayTypeChooseListTextArr;
}
//
- (NSMutableDictionary *)parmsDicUseWillSendAdd{
    if (!_parmsDicUseWillSendAdd) {
        _parmsDicUseWillSendAdd = [[NSMutableDictionary alloc]init];
    }
    return _parmsDicUseWillSendAdd;
}
//
//    self.sectionOneTitleArr = [[NSMutableArray alloc]initWithObjects:@"缴费户名", @"缴费户号",@"缴费单位",@"地址",nil];
//    self.sectionOneContentArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"", nil];
//    self.thisCostDetailmodel = [[LifeCostMyCostDetailModel alloc]init];
- (NSMutableArray *)sectionOneTitleArr{
    if (!_sectionOneTitleArr ) {
        _sectionOneTitleArr = [[NSMutableArray alloc]initWithObjects:@"缴费户名", @"缴费户号",@"缴费单位",@"地址",nil];
    }
    return _sectionOneTitleArr;
}
- (NSMutableArray *)sectionOneContentArr{
    if (!_sectionOneContentArr ) {
        _sectionOneContentArr = [[NSMutableArray alloc]initWithObjects:@"缴费户名", @"缴费户号",@"缴费单位",@"地址",nil];
    }
    return _sectionOneContentArr;
}

- (LifeCostMyCostDetailModel *)thisCostDetailmodel{
    if (!_thisCostDetailmodel) {
        _thisCostDetailmodel =  [[LifeCostMyCostDetailModel alloc]init];
    }
    return _thisCostDetailmodel;
}
@end
