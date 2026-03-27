//
//  MoneyOfThridBangDingModel.m
//  Community
//
//  Created by 余莹 on 2021/10/18.
//

#import "WeiXinAuthorizationManager.h"
#import "AppDelegate.h"
#import "MoneyOfThridBangDingWeiXinEditVc.h"
#import "ZYSmallShopGoodsSpellGroupSharedModel.h"

@interface   WeiXinAuthorizationManager() <WXApiDelegate,WXApiLogDelegate>
@property (nonatomic,copy) MoneyBindDingGetCodeStrBlock wxCodeStrBlock;

@end

@implementation WeiXinAuthorizationManager
singleton_implementation(share)

- (void)weiXinMoneyBangDingActionWithWeixinCodeStrBlock:(MoneyBindDingGetCodeStrBlock)codeStrBlock{
    self.wxCodeStrBlock = codeStrBlock;
    [self sendAuthRequest]; 
}
- (void)registerApp {
    [WXApi registerApp:WX_APP_ID universalLink:WX_UNIVERSAL_LINK];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)sendAuthRequest {
    if (![WXApi isWXAppInstalled]) {
        Y_SVP_SHOW_ERR_MES(@"您没有安装微信客户端，请安装后再试")
        return;
    }
//    if (WX_REFRESH_TOKEN_UserDefaults_Get) {
//        //存在token 不用获取授权 直接获取用户信息
//        [self useTokenGetUserInfo];
//        return;
//    }
    
    [WXApi registerApp:WX_APP_ID universalLink:WX_UNIVERSAL_LINK];
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.state = @"wx_ThridBind"; // 用于保持请求和回调的状态，授权请求或原样带回 可设置为简单的随机数加 session 进行校验
    req.scope = @"snsapi_userinfo"; // 授权作用域：获取用户个人信息
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootViewController = appdelegate.window.rootViewController;
    [WXApi sendAuthReq:req viewController:rootViewController delegate:self completion:^(BOOL success) {
        if (success) {
            //已经跳转到微信
        }else{
            Y_SVP_SHOW_ERR_MES(@"微信登录绑定失败");
        }
    }];
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq*)req {
    DLog(@" WXApiDelegate onReq %@",req);
    //获取开放标签传递的extinfo数据逻辑
    if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        LaunchFromWXReq *req1 = (LaunchFromWXReq *)req;
        ZYSmallShopGoodsSpellGroupSharedModel *model = [ZYSmallShopGoodsSpellGroupSharedModel yy_modelWithJSON:req1.message.messageExt];
        [self shareInfoDealWithModel:model];
    }
}

- (void)shareInfoDealWithModel:(ZYSmallShopGoodsSpellGroupSharedModel *)model {
    NSLog(@"%@", model.data.communityId);
    if (model.data.communityId.length > 0 && model.data.spellId.length > 0) {
        NSDictionary *dict = @{@"communityId" : model.data.communityId, @"spellId" : model.data.spellId};
        [ShareUserInfo sharedUserInfo].shareDict = dict;
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *rootVc = appdelegate.window.rootViewController;
        if ([rootVc isKindOfClass:[TabBarController class]]) {
            TabBarController *tabVc = (TabBarController *)rootVc;
            NSMutableArray *naviArray = [NSMutableArray array];
            for (UINavigationController *naviVc in tabVc.viewControllers) {
                UINavigationController *tempNaviVc = [[UINavigationController alloc] init];
                for (int i = 0; i < naviVc.viewControllers.count; i++) {
                    if (i == 0) {
                        tempNaviVc.viewControllers = @[naviVc.viewControllers[i]];
                        [naviArray addObject:tempNaviVc];
                    }
                }
            }
            tabVc.viewControllers = naviArray;
            appdelegate.window.rootViewController = tabVc;
            tabVc.selectedIndex = 1;
            tabVc.selectedIndex = 0;
        }
    }
}

/**
 成功拿到授权的回调   wxCodeStr
 */
- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *sendAuth = (SendAuthResp *)resp;
        NSString *st = sendAuth.state;
        NSLog(@"sendAuth %@" ,sendAuth);
        if ([st isEqualToString:@"wx_ThridBind"] ) {
            /**
             ERR_OK = 0(用户同意) ERR_AUTH_DENIED = -4（用户拒绝授权） ERR_USER_CANCEL = -2（用户取消）
             */
            if (sendAuth.errCode == 0) {
                NSString *wxCodeStr = sendAuth.code;
                NSLog(@"wxCodeStr = %@", wxCodeStr);
                NSLog(@"成功拿到授权的回调%@",wxCodeStr);
                [self useCodeToPop:wxCodeStr];
            } else {
                [self useCodeToPop:@""];
              
            }
        }
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // 分享
        SendMessageToWXResp *sendMessageRes = (SendMessageToWXResp *)resp;
        if (sendMessageRes.errCode == 0 ) {
        } else if (sendMessageRes.errCode == WXErrCodeUserCancel) {
            Y_SVP_SHOW_ERR_MES(@"您取消了分享");
        } else {
            Y_SVP_SHOW_ERR_MES(@"分享失败");
        }
    }
}
#pragma mark ====================================== 后台接口
- (void)useCodeToPop:(NSString *)codeStr{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isNil(self.wxCodeStrBlock)) {
            self.wxCodeStrBlock(@"");
            Y_SVP_SHOW_ERR_MES(@"获取授权失败")
        }else{
            self.wxCodeStrBlock(codeStr);
        }
    });
   
}
- (void)onLog:(nonnull NSString *)log logLevel:(WXLogLevel)level {
    NSLog(@"%@", log);
}

@end
