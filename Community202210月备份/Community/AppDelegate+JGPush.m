//
//  AppDelegate+JGPush.m
//  极光Sdk使用
//
//  Created by 余莹 on 2021/9/14.
//

#import "AppDelegate+JGPush.h"
#import "JGSaveIdShare.h"
#import "MainAllTypeInformationVC.h"
#import "ZYMessageVc.h"

static NSInteger kMessageOnSelectedTarBarIndex = 0;

@implementation AppDelegate (JGPush)

//自定义展示数据 只有在app运行时可以
- (void)jgPushSetShowDidReceiveMessage{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的 Extras 附加字段，key 是自己定义的
}
#pragma mark _____________________________________________________ base
- (void)jgPushSDKSetup{
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //————————拿到id
    [self getJgIdAction];
}

- (void)jgSetupWithOption:(NSDictionary *)launchOptions{
    [JPUSHService setupWithOption:launchOptions appKey:JG_Appkey  channel:nil apsForProduction:NO];//JG_Appkey JG_Secret
}

- (void)jgPushSDKRegisterDevice:(NSData *)deviceToken{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
#pragma mark _____________________________________________________ 拿到id
- (void)getJgIdAction{
    [JPUSHService registrationIDCompletionHandler :^( int resCode, NSString *registrationID) {
        if (resCode == 0 ){
            NSLog ( @" \n _______registrationID获取成功：%@" ,registrationID);
            [self saveJgId:registrationID];
        }
        else {
            NSLog ( @" \n _______registrationID获取失败，code：%d" ,resCode);
        }
    }];
    //__或
    /**
     NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
     [defaultCenter addObserver:self selector:@selector(jgDidLoginNotice:) name:kJPFNetworkDidLoginNotification object:nil];
  
}

- (void)jgDidLoginNotice:(NSNotification *)notification{
    NSLog(@"已登录");
    NSString *registrationIdStr = [JPUSHService registrationID];
    //存储 后续再使用
    NSLog(@"\n _______ jgDidLoginNotice registrationID获取  == %@",registrationIdStr);
    [self saveJgId:registrationIdStr];
     */
}
- (void)saveJgId:(NSString *)registrationIdStr{
    [JGSaveIdShare sharedUserInfo].registrationID = registrationIdStr;
    NSLog(@"\n _______ share registrationID 已存  == %@",[JGSaveIdShare sharedUserInfo].registrationID);
    
}



#pragma mark _____________________________________________________ JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];//*****在app运行时得到推送后本处被调

    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support 活动状态 点击通知横条
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    UNNotificationContent *nContent = response.notification.request.content;
    NSLog(@"活动状态 点击通知横条 %@ %@",nContent.title,nContent.body);//展示在通知条上的文本
    //    UNNotificationContent = [response.notification.request.content Class];
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];//点击通知栏后得到推送后本处被调
        [self JGNotificationInfoGetToDoPushVcWithUserInfo:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    
    NSLog(@"%@",info);
    
}
#pragma mark === 角标
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"state =  %ld",(long)application.applicationState);
    if (application.applicationState == UIApplicationStateActive) {//点击home之后的0状态调用 但是其他状态不被调用
        //桌面角标置0，通知栏消息列表清除
        if ( [UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
            //
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [JPUSHService setBadge:0];
        }
     
        //1.唤醒app后桌面角标置0，通知栏消息列表清
//        [[UIApplication sharedApplication] cancelAllLocalNotifications];//仍有其他消息，则考虑清除.本方法已经过期

    }else if  (application.applicationState == UIApplicationStateInactive) {
        
    }else if  (application.applicationState == UIApplicationStateBackground) {
        
    }
}

#pragma mark _____________________________________________________
#pragma mark ____________***** ____________|

- (void)JGNotificationInfoGetToDoPushVcWithUserInfo:(NSDictionary *)userInfo{
    /**
     (lldb) po userInfo
     {
     "_j_business" = 1;
     "_j_data_" = "{\"data_msgtype\":1,\"push_type\":1,\"is_vip\":0}";
     "_j_msgid" = 9007444974209348;
     "_j_uid" = 55378908062;
     aps =     {
     alert =         {
     body = "1_hhh";
     title = "\U54c8\U54c8\U54c8";
     };
     badge = 1;
     "mutable-content" = 1;
     sound = default;
     };
     "type000_1" = 999;
     }
 
     */
    //———————角标
    NSInteger currentNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (currentNumber > 0) {
        currentNumber--;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = currentNumber;
    [JPUSHService setBadge:currentNumber];
    
 
    //———————跳转vc
//    UIViewController *rootV = [self topViewControllerWithRootViewController:self.window.rootViewController];
    UINavigationController *rootV = [self topViewControllerWithRootViewController:self.window.rootViewController];
    NSDictionary *apsAlertDic = [NSDictionary dictionaryWithDictionary:userInfo];//alert只有展示文本
    NSString *sessionId = [apsAlertDic objectForKey:@"sessionId"];
    UIViewController *willPushVc = [self willPushVcWithGetDic:apsAlertDic];
 
  
  NSLog(@"\n apsAlertDic == %@",apsAlertDic);
  if (isNotNil(rootV) && isNotNil(willPushVc)) {
      NSLog(@"|******* 后台运行中变活动中 点击通知栏后 跳转界面vc_class == %@ %@ ******|",rootV ,willPushVc);
      willPushVc.hidesBottomBarWhenPushed = YES;
      [rootV pushViewController:willPushVc animated:YES];
//      Y_SVP_SHOW_INFO_MES_5Delay(@"_________***________");
  }else{
   
      if ([self isAutoLogin]) {
          if (isNil(willPushVc)) {
              NSLog(@"|******* jgpush______后台为登录页 或者app才开启状态 走登录主页******|");
//              Y_SVP_SHOW_INFO_MES_5Delay(@"_________*** isAutoLogin _________*** no");
        
              return;
          }else{
//              Y_SVP_SHOW_INFO_MES_5Delay(@"_________*** isAutoLogin _________*** yes");
              NSLog(@"|******* jgpush______被杀掉但是在登录有效期内 不走登录 root去主页 跳转消息列表******|");
              TabBarController *tabBarController = [[TabBarController alloc]init];
              self.window.rootViewController = tabBarController;
              tabBarController.oldSelectIndex = kMessageOnSelectedTarBarIndex;
              tabBarController.selectedIndex = kMessageOnSelectedTarBarIndex;
              NSInteger selectedNum = kMessageOnSelectedTarBarIndex;
              UINavigationController *selectedNav = tabBarController.viewControllers[selectedNum];
              rootV = selectedNav;
              willPushVc.hidesBottomBarWhenPushed = YES;
              [rootV pushViewController:willPushVc animated:YES];
          }
      }
      
  }
   

}
- (BOOL)isAutoLogin{
    //退出时 过期时间置空 不会做自动登录
    //普通展示状态|有rootvc
    //被杀掉状态｜登录界面不需要 直接rootvc走tabbar. 和已经有的willpushvc进行跳转
    NSString  *exporedTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:kLogin_ExpiredTime_Key];
    BOOL ifCanLogin = NO;
    NSString *exT = [ToolOfTimeChangeFormat getTimeStrWithString:exporedTimeStr];
    NSString *nowT = [ToolOfTimeChangeFormat currentTimeStr];

    // token非过期时间 则自动登录 （登录账户号码相同 本推送横条点击后 不走登录界面走tabbar ?）
    if (([exT integerValue] > [nowT integerValue])) {
        ifCanLogin = YES;
    }
    if (ifCanLogin) {
        return YES;
    }else{
        NSLog(@"去rootvc 登录页");
        return NO;
    
    }

}

- (UIViewController*)willPushVcWithGetDic:(NSDictionary *)dataDic{
    NSInteger willType = [[dataDic objectForKey:@"fromUserType"] intValue]; //toUserType
    MainAllTypeInformationVC *vc = [[MainAllTypeInformationVC alloc]init];
    return vc;
    //会话vc之后再做处理
//    switch (willType) {//1普通用户 2群 3公众号
//        case 1:
//        {
//            ZYMessageVc *messageVc = [[ZYMessageVc alloc]init];
//            return messageVc;
//        }
//            break;
//        case 2:
//        {
//            ZYMessageVc *messageVc = [[ZYMessageVc alloc]init];
//            return messageVc;
//        }
//            break;
//        case 3:
//        {
//            MainAllTypeInformationVC *vc = [[MainAllTypeInformationVC alloc]init];
//            return vc;
//        }
//            break;
//
//        default: //其他类型
//        {
//            MainAllTypeInformationVC *vc = [[MainAllTypeInformationVC alloc]init];
//            return vc;
//            //test ZYMessageVc dismiss
////            ZYMessageVc *messageVc = [[ZYMessageVc alloc]init];
////            return messageVc;
//        }
//            break;
//    }
    
}
//- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController{
//
//
//
//    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
//
//        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
//
//        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
//
//    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
//
//        UINavigationController* navigationController = (UINavigationController*)rootViewController;
//
//        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
//
//    } else if (rootViewController.presentedViewController) {
//
//        UIViewController* presentedViewController = rootViewController.presentedViewController;
//
//        return [self topViewControllerWithRootViewController:presentedViewController];
//
//    } else {
//
//        return rootViewController;
//
//    }
//
//}
- (UINavigationController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController{
    
    NSLog(@"|*****  vc_rootViewController  %@",rootViewController);
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        //在app内页运行中home后的vc
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        NSInteger selectedNum = tabBarController.selectedIndex;
        UINavigationController *selectedNav = tabBarController.viewControllers[selectedNum];
        return selectedNav;
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {  //登录页 -- ‘用户未登录，请进行登录’
      
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
//        return navigationController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
        
    } else if (rootViewController.presentedViewController) {
        
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
        
    } else {
//        UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:rootViewController];
//        return navC;
       
        return nil;
    }
    
}

#pragma mark ____________***** ____________|
@end
