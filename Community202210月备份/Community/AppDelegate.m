//
//  AppDelegate.m
//  Community
//
//  Created by 余莹 on 2020/11/9.
//  20210615master

#import "AppDelegate.h"
#import "AppDelegate+JGPush.h"
#import "AppDelegate+LocalPush.h"
#import "WeiXinAuthorizationManager.h"
#import "ShopBuniessIssueOkVc.h"
#import "ZYSmallShopGoodsSpellGroupShareWebVc.h"
#import "LoginAndRegiestVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

void uncaughtExceptionHandler(NSException*exception) {
    NSLog(@"______________________CRASH: %@", exception);
    NSLog(@"______________________Stack Trace: %@",[exception callStackSymbols]);
}

void handle(NSException *exception)
{
    NSLog(@"崩溃的原因是%@",exception.reason);
    NSLog(@"崩溃的名称是%@",exception.name);
    NSLog(@"崩溃的堆栈信息是%@",exception.callStackSymbols);
    
    //这儿监听到的崩溃都是没有被AvoidCrash拦截到，所以会自动上报，上报到崩溃分析
    
    //下面这两句，让APP不至于闪退，但也会卡主，可以考虑弹出个alert什么的
//    [[NSRunLoop currentRunLoop] run];
//    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //——————极光
    [self jgPushSDKSetup];
    [self jgSetupWithOption:launchOptions];
    // 本地推送
    [self localNotificationSetup];
    //——————————
    self.window.backgroundColor = [UIColor whiteColor];
    
    #ifdef DEBUG
        //这句话的意思就是告诉系统，当发生异常时，使用这个函数作为回调。
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
       //监听崩溃 中文
        NSSetUncaughtExceptionHandler(handle);
    #endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

//    LoginVC *loginVC = [[LoginVC alloc] init];//旧版
    LoginAndRegiestVC *loginVC = [[LoginAndRegiestVC alloc] init];//20220514新版 接口待调
    self.nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = self.nav;
    [self.window makeKeyAndVisible];
    
    
    //键盘
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // iOS15新特性
    if (@available(iOS 15.0, *)) {
        // 去除tableViewHeader默认高度
        //UITableView.appearance.sectionHeaderTopPadding = 0.0;
    }
    
    //提示
    [SVProgressHUD resetDefaultHUD];
    
    //微信
    [[WechatLoginManager shareManager] registerApp];
    
    // 清除启动页缓存
    [self clearLaunchScreenCache];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"[DEBUG] url = %@", url.absoluteString);
    NSLog(@"[DEBUG] URL scheme:%@", [url scheme]);
    NSLog(@"[DEBUG] URL host: %@",  [url host]);
    NSLog(@"[DEBUG] URL query: %@ \n __________________________________", [url query]);
     NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    //________________
    // //微信wx
    if ([urlStr rangeOfString:@"wx"].location != NSNotFound) {
        //微信wx钱包模块绑定 12中旬 改成设置页的三方账号绑定处
        if ([urlStr rangeOfString:@"wx_ThridBind"].location != NSNotFound) {
            // host = oauth
            [[WeiXinAuthorizationManager share] handleOpenURL:url];
        
        }else if([urlStr rangeOfString:@"wx_oauth_authorization_state"].location != NSNotFound) {//登录
            //host = oauth 登录
            [[WechatLoginManager shareManager] handleOpenURL:url];
        }else if([url.host isEqualToString:@"pay"]){
            //支付
            [[WeChatPayManager shareManager] handleOpenURL:url];
        }else{
            
        }
    }
 
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"AppDelegate processOrderWithPaymentResult result = %@",resultDic);
//        }];
        [[ZfbPayManager shareManager]handleOpenURL:url];
        //
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"AppDelegate processAuth_V2Result result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"AppDelegate 授权结果 authCode = %@", authCode?:@"");
        }];
    }

    return YES;
}
 
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options
{
    
    NSLog(@"[DEBUG] url = %@", url.absoluteString);
    NSLog(@"[DEBUG] URL scheme:%@", [url scheme]);
    NSLog(@"[DEBUG] URL host: %@",  [url host]);
    NSLog(@"[DEBUG] URL query: %@ \n __________________________________", [url query]);
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
 
    //________________
    //h5_wx
    if ([url.host containsString:@"eHomeH5WxPayBack"]) {
        /**
         AppDelegate.m:150      [DEBUG] url = yaoyaotest.cebbank.com://eHomeH5WxPayBack
         AppDelegate.m:151      [DEBUG] URL scheme:yaoyaotest.cebbank.com
         AppDelegate.m:152      [DEBUG] URL host: eHomeH5WxPayBack
         AppDelegate.m:153      [DEBUG] URL query: (null)
         */
        //wxpay支付回来后的
        [[WeChatPayManager shareManager] handleOpenURL:url];
        return YES;
    }
    // //微信wx
    if ([urlStr rangeOfString:@"wx"].location != NSNotFound) {
        //微信wx钱包模块绑定 12中旬 改成设置页的三方账号绑定处
        if ([urlStr rangeOfString:@"wx_ThridBind"].location != NSNotFound) {
            // host = oauth
            [[WeiXinAuthorizationManager share] handleOpenURL:url];
        
        }else if([urlStr rangeOfString:@"wx_oauth_authorization_state"].location != NSNotFound) {//登录
            //host = oauth 登录
            [[WechatLoginManager shareManager] handleOpenURL:url];
        }else if([url.host isEqualToString:@"pay"]){
            //支付
            [[WeChatPayManager shareManager] handleOpenURL:url];
        }else{
            
        }
    }
    
    // 微信分享
    if ([url.host isEqualToString:@"resendContextReqByScheme"]) {
        [[WeiXinAuthorizationManager share] handleOpenURL:url];
    }
    // 微信分享回调
    if ([url.host isEqualToString:@"platformId=wechat"]) {
        NSDictionary *dict = [ZYWebUrlToDictTool parameterWithURL:url];
        if (dict.allKeys.count > 0) {
            [self handleSpellGroupWebBackWithUrl:url];
        }else {
            [[WeiXinAuthorizationManager share] handleOpenURL:url];
        }
    }
 
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"AppDelegate processOrderWithPaymentResult result0 = %@",resultDic);
//        }];
        [[ZfbPayManager shareManager]handleOpenURL:url];
        
        //
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"AppDelegate processAuth_V2Result result0 = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"AppDelegate 授权结果 authCode0 = %@", authCode?:@"");
        }];
    }
    return YES;
}
//弃用
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL*)url{
    
    return YES;
}

#pragma mark -
/*
 极光推送
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self jgPushSDKRegisterDevice:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - 清除启动页缓存
- (void)clearLaunchScreenCache {
    NSError *clearLaunchrror;
    [NSFileManager.defaultManager removeItemAtPath:[NSString stringWithFormat:@"%@/Library/SplashBoard",NSHomeDirectory()] error:&clearLaunchrror];
    if (clearLaunchrror) {
        DLog(@"Failed to delete launch screen cache: %@",clearLaunchrror);
    }
}

#pragma mark === rootVc 更改

- (void)showWindowHome:(NSString *)windowTypeStr{
    if ([ windowTypeStr isEqualToString:kWindowType_Logout]) {
    
        
        
//        LoginVC *loginVC = [[LoginVC alloc] init];
        LoginAndRegiestVC *loginVC = [[LoginAndRegiestVC alloc] init];//20220514新版
        self.nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = self.nav;
        [self.window makeKeyAndVisible];
        
        //动画
        CATransition *trastition = [CATransition animation];
        trastition.duration = 0.3;
        trastition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.window.layer addAnimation:trastition forKey:@"Animation"];
    }
    
}

#pragma mark - 处理拼团Web点击返回App
- (void)handleSpellGroupWebBackWithUrl:(NSURL *)url {
    NSDictionary *dict = [ZYWebUrlToDictTool parameterWithURL:url];
    NSString *communityId = dict[@"communityId"];
    NSString *spellId = dict[@"spellId"];
    if (communityId.length > 0 && spellId.length > 0) {
        NSDictionary *dict = @{@"communityId" : communityId, @"spellId" : spellId};
        [ShareUserInfo sharedUserInfo].shareDict = dict;
        UIViewController *rootVc = self.window.rootViewController;
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
            self.window.rootViewController = tabVc;
            tabVc.selectedIndex = 1;
            tabVc.selectedIndex = 0;
        }
    }
}

@end
