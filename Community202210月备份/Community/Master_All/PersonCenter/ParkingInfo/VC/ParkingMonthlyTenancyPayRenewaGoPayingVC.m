//
//  ParkingMonthlyTenancyPayRenewaGoPayingVC.m
//  Community
//
//  Created by 余莹 on 2021/8/7.
//

#import "ParkingMonthlyTenancyPayRenewaGoPayingVC.h"
#import "PayTool.h"
//
#import "ParkingVC.h"
#import "ParkingTemporaryVC.h"//临时缴费
#import "ParkingMonthlyTenancyVC.h"//月租缴费

@interface ParkingMonthlyTenancyPayRenewaGoPayingVC ()
@property (nonatomic,strong) UIImageView *centerImgView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,assign) ALL_PayOrder_Type payType;
@end

@implementation ParkingMonthlyTenancyPayRenewaGoPayingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isTempCar) {
        self.payType = payOrder_Type_ParkCar_Temp;
    }else{
        self.payType = payOrder_Type_ParkCar;
    }
    [self initView];
    [self beginPay];
    [self addNoticeOfPay];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self changeNavBackColorWithDIsCountBlueAndWW];
}
 
#pragma mark == 选择付款类型
- (void)beginPay{
    WEAKSELF
    [GotoRealNameAuthenticationCardVcTool needGotoRealNameAuthenticationCardVcWithNowVcType:GotoRealNameAuthenticationCardVc_NowVcType_Nomal withBlock:^(BOOL needGotoRealNameVcBool, ZYElectroniNewRealNameAuthenticationCardVcLate * _Nonnull realNameVc) {
        if (needGotoRealNameVcBool) {
            [weakSelf pushVc:realNameVc];
        }else{
            DLog(@"beginPay %@",self.dataOrderIdStr)
            AlertManager *alert = [[AlertManager shareManager] creatAlertWithTitle:@"支付方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet cancelTitle:@"取消" otherTitleArr: [PayBaseInfo share].payTypeStrArr];
            [alert showWithViewController:self IndexBlock:^(NSInteger index) {
                if (index == AlertManagerCancelIndex) {
                    [weakSelf popVC];
                    NSLog(@"取消按钮 做返回");
                }else{
                    NSLog(@"%ld",index);
                 NSInteger touchRowWithPayTypeIndex = index + kPayBaseInfo_TypeIndex_BaseIndex;
                    switch (touchRowWithPayTypeIndex) {
                        case PayBaseInfo_TypeIndex_ZFB://"Alipay"@"支付宝"
                        {
                            [weakSelf goZFBPay];
                        }
                            break;
                        case PayBaseInfo_TypeIndex_WeChat://@"WeChat"@"微信"
                        {
                            [weakSelf goWeChatPay];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }

            }];
        }
    }];
    
   
    //选择支付方式
    /**
     AlertManager *alert = [[AlertManager shareManager] creatAlertWithTitle:@"支付方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet cancelTitle:@"取消" otherTitleArr:[AlertManager shareManager].payTitleArr];
     [alert showWithViewController:self IndexBlock:^(NSInteger index) {
         if (index == AlertManagerCancelIndex) {
             [self popVC];
             NSLog(@"取消按钮 做返回");
         }else{
             NSLog(@"%ld",index);
             switch (index) {
                 case 0://"Alipay"@"支付宝"
                 {
                     [self goZFBPay];
                 }
                     break;
                 case 1://@"WeChat"@"微信"
                 {
                     [self goWeChatPay];
                 }
                     break;
                     
                 default:
                     break;
             }
         }

     }];
     
     */
  
}
#pragma mark ===
- (void)goWeChatPay{
  [WeChatPayData weChatPayOfCarParkingUseIdStr: self.dataOrderIdStr];//  20220406改版
    
    /**
      20220406改版

    [WillPayGetOrderViewModel willWeChatPayMoneyNum:self.moneyNum  withPayOrderType:self.payType withDescriptionStr:@"停车费" withOrderIdArr:@[self.dataOrderIdStr].mutableCopy  withGetOrderInfo:^(WillPayOrderInfoModel * model, BOOL success) {
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
            dispatch_async( dispatch_get_main_queue(), ^{
                [[WeChatPayManager shareManager] hangleWechatPayWithPayReq:req];  //gowx
            });
        }
    }];
     */
  
}
#pragma mark ===
- (void)goZFBPay{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [WillPayGetOrderViewModel willZFBPayMoneyNum:self.moneyNum withPayOrderType:self.payType  withOrderIdArr:@[self.dataOrderIdStr].mutableCopy   withGetOrderInfo:^(WillPayOrderInfoModel * model, BOOL success) {
        if (success) {
            NSString *zfbOrderStr = [TextShowWithModelStr textShowWithModelStr:model.orderStr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ZfbPayManager shareManager] hangleZFPayOrderStr:zfbOrderStr];
            });
        }
    }];
}
#pragma mark ======= notice—————————— pay  init
- (void)addNoticeOfPay{
    Y_NSNotificationCenter_Creat_NameAction(PaySuccessedEndInfo_Notice_Name, paySuccessNotice:);
    Y_NSNotificationCenter_Creat_NameAction(PayFailEndInfo_Notice_Name, payFailNotice:);
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(PaySuccessedEndInfo_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(PayFailEndInfo_Notice_Name);
}
#pragma mark ======= notice—————————— pay  get
- (void)payFailNotice:(NSNotification *)notice{
    NSString *failMsg =  [notice.userInfo objectForKey:[notice.userInfo allKeys].firstObject];
    Y_SVP_SHOW_INFO_MES(failMsg);
    //普通失败类型 会上一页可继续支付
    [self popVC];
}
 
- (void)paySuccessNotice:(NSNotification *)notice{
    NSInteger successInfoWithPayTypeNum =  [[notice.userInfo objectForKey:Pay_Success_PayType_Key] integerValue];
    switch (successInfoWithPayTypeNum) {//parmsDicUseWillSendAdd在第一步处理
        case 1:// 1微信支付
        {
            Y_SVP_SHOW_SUCCESS_MES(@"已成功缴纳");//列表更新
        }
            break;
        case 2://2支付宝支付
        {
            Y_SVP_SHOW_SUCCESS_MES(@"已成功缴纳");//列表更新
        }
            break;
        default:
            break;
    }
    //成功类型 回列表
    [self popListVc];

}
- (void)popListVc{

    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ParkingTemporaryVC class]]) {//临时缴费列表
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }else if ([vc isKindOfClass:[ParkingMonthlyTenancyVC class]]){//月租缴费列表
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    
    
}
#pragma mark == UI
- (void)initView{
    [self.view addSubview:self.titleL];
    [self.view addSubview:self.centerImgView];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerY.centerX.equalTo(_titleL.superview);
        make.height.offset(20);
    }];
    [_centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(75);
        make.centerX.equalTo(_centerImgView.superview);
        make.bottom.equalTo(_titleL.mas_top).offset(-20);
    }];
}
 
- (UIImageView *)centerImgView{
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc]init];
        _centerImgView.image = [UIImage imageNamed:@"tiaozhuan"];
        _centerImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerImgView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"跳转支付";
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont systemFontOfSize:17];
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
@end
