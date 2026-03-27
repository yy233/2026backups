//
//  WXPayManager.m
//  Community
//
//  Created by 余莹 on 2021/3/11.
//

#import "WeChatPayManager.h"


@interface WeChatPayManager () <WXApiDelegate>

@end

@implementation WeChatPayManager

singleton_implementation(shareManager)

- (void)registerApp {
    [WXApi registerApp:WX_APP_ID universalLink:WX_UNIVERSAL_LINK];//wechat_login 已调
}

- (BOOL)handleOpenURL:(NSURL *)url {
    NSLog(@"handleOpenURL %@",url);
    //    handleOpenURL yaoyaotest.cebbank.com://eHomeH5WxPayBack
    if ([url.absoluteString containsString:@"eHomeH5WxPayBack"]) {
        Y_NSNotificationCenter_PostNotice_NilObject_Name(NoticeName_WxPayBackH5Type);

    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)hangleWechatPayWithPayReq:(PayReq *)req {
    if (![WXApi isWXAppInstalled]) {
        Y_SVP_SHOW_ERR_MES(@"请安装微信后，再选择本支付类型。");
        return;
    }
    
    [WXApi sendReq:req completion:^(BOOL success) {
        if (success) {
            NSLog(@"微信支付_流程顺利");//正常取消也会走success
        } else {
             NSLog(@"微信支付_流程异常");
            Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, @{Pay_Fail__Key:@"微信支付异常"})
        }
    }];
}
 
#pragma mark - 微信支付回调

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        /*
         enum  WXErrCode {
         WXSuccess           = 0,    < 成功
         WXErrCodeCommon     = -1,  < 普通错误类型
         WXErrCodeUserCancel = -2,   < 用户点击取消并返回
         WXErrCodeSentFail   = -3,   < 发送失败
         WXErrCodeAuthDeny   = -4,   < 授权失败
         WXErrCodeUnsupport  = -5,   < 微信不支持
         };
         */
        /**
         #define PaySuccessedEndInfo_Notice_Name                            @"PaySuccessEndInfo_Notice_Name"
         #define PayFailEndInfo_Notice_Name                                      @"PayFailEndInfo_Notice_Name"
         */
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc]init];
        PayResp *response = (PayResp*)resp;
        switch (response.errCode) {
            case WXSuccess: {
                NSLog(@"微信支付成功");
                [userInfoDic setValue:@(PayTool_ThisPay_Type_WeChat)      forKey:Pay_Success_PayType_Key];            //  1微信支付，2支付宝支付，3账户余额，4其他银行卡
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PaySuccessedEndInfo_Notice_Name, userInfoDic);
            break;
            }
            case WXErrCodeCommon: {
                NSLog(@"微信回调支付异常");
                [userInfoDic setValue:@"微信支付异常" forKey:Pay_Fail__Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, userInfoDic)
                break;
            }
            case WXErrCodeUserCancel: {
                NSLog(@"微信回调用户取消支付");
                [userInfoDic setValue:@"微信用户取消支付" forKey:Pay_Fail__Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, userInfoDic)
                break;
            }
            case WXErrCodeSentFail: {
                NSLog(@"微信回调发送支付信息失败");
                [userInfoDic setValue:@"微信发送支付信息失败" forKey:Pay_Fail__Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, userInfoDic)
                break;
            }
            case WXErrCodeAuthDeny: {
                NSLog(@"微信回调授权失败");
                [userInfoDic setValue:@"微信授权失败" forKey:Pay_Fail__Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, userInfoDic)
                break;
            }
            case WXErrCodeUnsupport: {
                NSLog(@"微信回调微信版本暂不支持");
                [userInfoDic setValue:@"微信版本暂不支持" forKey:Pay_Fail__Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, userInfoDic)
                break;
            }
            default: {
                [userInfoDic setValue:@"微信支付错误" forKey:Pay_Fail__Key];
                Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PayFailEndInfo_Notice_Name, userInfoDic)
                break;
            }
        }
    }
}
@end
