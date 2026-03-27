//
//  AppDelegate.m
//  Socialize
//
//  Created by 余莹 on 2023/5/10.
//

#import "AppDelegate.h"
//#import "DCUniMP.h"
#import <AVFAudio/AVFAudio.h>
#import "WalletSqlTools.h"
#import "MainTabbarControll.h"
#import <UserNotifications/UserNotifications.h>
#import "NSData+LGJExtension.h"
@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

#pragma mark ----- 本地远程推送相关
/**
1016 不做本地推送

//当点击进入应用时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSLog(@"当点击进入应用时触发 completionHandler --- %@",completionHandler);
}
//当应用在前台时，收到通知会触发这个代理方法；你可以在这个方法中对应用处于前台时接到通知做一些自己的处理
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@"completionHandler --- %@",completionHandler);
    NSLog(@"notification --- %@",notification);
    completionHandler(UNNotificationPresentationOptionSound + UNNotificationPresentationOptionAlert);

}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@" didFailToRegisterForRemoteNotificationsWithError 注册APNs-- (error)==%@",error);
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    NSString *string = [deviceToken convertedToUtf8String];
    
 
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    NSMutableString *valueString = [NSMutableString string];
    const unsigned *tokenBytes = [deviceToken bytes];
    NSInteger count = deviceToken.length;
    for (int i = 0; i < count; i++) {
        [valueString appendFormat:@"%02x", tokenBytes[i]&0x000000FF];
    }
//    NSString *tokenString = [[[[deviceToken description]
//                                 stringByReplacingOccurrencesOfString:@"<" withString:@""]
//                                stringByReplacingOccurrencesOfString:@">" withString:@""]
//                               stringByReplacingOccurrencesOfString:@" " withString:@""];
//       NSLog(@"Device Token: 注册APNs-- (成功) %@", tokenString);

    NSLog(@" didRegisterForRemoteNotificationsWithDeviceToken 注册APNs-- (成功)==string %@  位数=%ld",valueString,valueString.length);
    
    //9600e6c8311766cb60862b00000000000000000000000000200100000000b001 //20efff08df854b2191a10000000000000000700189a10000e002000206010000
}

- (void)getNotificationSettings{
    [[UNUserNotificationCenter currentNotificationCenter]getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@" settings = %@",settings);
        if(settings.authorizationStatus == UNAuthorizationStatusAuthorized){ //应用被授权发布用户通知 表明用户允许推送
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];//实际注册APNs
                NSLog(@" registerForRemoteNotifications 实际注册APNs action");
            });
          
        }
    }];
}
- (void)resgierForPushNotifications{//认证APNs，指定通知类型
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionSound|UNAuthorizationOptionBadge|UNAuthorizationOptionAlert
                                                                        completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@" granted = %d  error =%@",granted,error);
        if(granted){
            [self getNotificationSettings];
        }
    }];
}

#pragma mark ----- 本地远程推送相关--1 end


- (void)puchNotionficationWithNotificationContent:(UNMutableNotificationContent *)content{
    //推送内容
    if(content.title.length<=0){
        content.title = @".";
    }
    NSLog(@"本地远程推送 content.title = %@  ,content.subc = %@",content.title,content.subtitle);
    //
    content.sound = [UNNotificationSound defaultSound]; //默认提示音
     //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
 
    NSDateComponents *date = [[NSDateComponents alloc] init];
    [date setSecond:[currentComps second] + 2];//间隔几秒
    
    UNCalendarNotificationTrigger* calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:date repeats:NO];
    //倒计时推送，2s后推送本地消息
    UNTimeIntervalNotificationTrigger *intervalTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
    NSString *randStrID = [NSString stringWithFormat:@"loction_push_ide_%@",[Url_OtherTool getRandStringWithLength: (3 + (arc4random() % (8-3+1)) )]];//3-8位随机
    //int lenth = (int)( 6 + (arc4random() % ( 16 - 6 + 1) )); //6-16位随机
    UNNotificationRequest* request = [UNNotificationRequest    requestWithIdentifier:randStrID content:content trigger:calendarTrigger];
    //将推送请求添加到管理中心才会生效
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@" 本地推送 err=%@", error.localizedDescription);
        }else{
            NSLog(@"当前本地推送 OK  -    title  =  %@ | body  = %@   | randStrID=%@",content.title,content.body,randStrID);
        }
    }];
}

- (void)getNoticeWithNeedPushInfo:(NSNotification *)notice{
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        NSLog(@" getNoticeWithNeedPushInfo -- UIApplicationStateActive 在前台活跃中 不做推送");
        return;
    }else{
        NSLog(@" getNoticeWithNeedPushInfo  UIApplicationStateBackground 后台状态 或  UIApplicationStateInactive 待激活状");
    }
    
    if(isNotNil(notice.object) && ([notice.object isKindOfClass:[UNNotificationContent class]] || [notice.object isKindOfClass:[UNMutableNotificationContent class]])){
        [self puchNotionficationWithNotificationContent:notice.object];
    }
    
}
 */

#pragma mark ----------------------------------------------------------------------------
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"推送 DeviceToke --- %@",deviceToken)
    V2TIMAPNSConfig *confg = [[V2TIMAPNSConfig alloc] init];
    /* 用户自己到苹果注册开发者证书，在开发者账号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，控制台会自动生成一个证书 ID，将证书 ID 传入以下 busiId 参数中。*/
    //推送证书 ID
    confg.businessID = TXpush_ID;
    confg.token = deviceToken;
    [[V2TIMManager sharedInstance] setAPNS:confg succ:^{
       NSLog(@" %s, succ ", __func__);
    } fail:^(int code, NSString *msg) {
       NSLog(@" %s, fail, %d, %@", __func__, code, msg);
    }];

}

TUIOfflinePushCertificateIDForAPNS(TXpush_ID) //正式环境的//配置生产环境证书
 
//当点击进入应用时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSLog(@"当点击进入应用时触发 completionHandler --- %@",completionHandler);
}

// 统一点击跳转
// 您可以直接拷贝当前的方法名到您的 AppDelegate 中
- (void)navigateToTUIChatViewController:(NSString *)userID groupID:(NSString *)groupID
{
  // 示例: 点击推送通知后，首先跳转到会话列表页面，然后再会话列表页跳转到聊天页面
  // 1. 获取当前 app 的 tabBarController
  // 2. 获取 tabBarController 的 firstObject，也即 ConversationController
  // 3. 执行 pushToViewController: 跳转到 ChatViewController
  // 跳转到聊天页面后，支持点击左上角的返回按钮回退到主页面
    
    

    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if (![tab isKindOfClass: UITabBarController.class] || ![tab isKindOfClass: MainTabbarControll.class] ) {
        // 正在登录中
        return;
    }
    if (tab.selectedIndex != 0) {
        [tab setSelectedIndex:0];
    }
    self.window.rootViewController = tab;
    UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
    if (![nav isKindOfClass:UINavigationController.class]) {
        return;
    }

    UIViewController *vc = nav.viewControllers.firstObject;
    if (![vc isKindOfClass:NSClassFromString(@"ConversationController")] && ![vc isKindOfClass:NSClassFromString(@"ImMainChatListViewController")]) {
        return;
    }
    if ([vc respondsToSelector:NSSelectorFromString(@"pushToChatViewController:userID:")]) {
        [vc performSelector:NSSelectorFromString(@"pushToChatViewController:userID:") withObject:groupID withObject:userID];
    }
}

// 统一收到离线推送 |自定义离线内容解析
- (BOOL)processTUIOfflinePushNotification:(NSDictionary *)userInfo
{
    // 自定义解析收到的 userInfo
    NSLog(@"腾讯离线推送>>> 您可以在此处自定义解析, %@", userInfo);

/***
 腾讯离线推送>>> 您可以在此处自定义解析, {
    action = 1;
    chatType = 2;
    content = 3;
    faceUrl = "https://test.freeper.l-z.vip:61131/avatar/2023-10/7/1Fc9Gfd_720_1600_146997_gmi.jpg";
    nickname = "\U65b0\U7684\U9a8c\U8bc1\U7fa41";//群昵称
    sendTime = 0;
    sender = FreeGroupudJT62LXwNHTp8152493;//发送的群ID
    version = 1;
}
 */

    // 如果您不想执行 TUIOfflinePush 默认的解析逻辑，直接返回 YES
    // 如果您只是想查看推送的内容，依然依赖 TUIOfflinePush 的默认解析及统一跳转逻辑，直接返回 NO
    return NO;
}

#pragma mark ====  didFinishLaunchingWithOptions

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

       NSLog(@"告诉app支持后台播放")
      AVAudioSession *audioSession = [AVAudioSession sharedInstance];
      [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
      [audioSession setActive:YES error:nil];
    
    /**
     本地推送相关 1016不做本地推送
     //本地通知触发
     Y_NSNotificationCenter_Creat_NameAction(Notice_Name_NeedLocationPushInfo, getNoticeWithNeedPushInfo:);
     //管理所有的通知活动
     [self resgierForPushNotifications];
     */
  
    
    
//    //配置参数
//      NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:launchOptions];
//      // 设置 debug YES 会在控制台输出 js log，默认不输出 log，注：需要引入 liblibLog.a 库
//      [options setObject:[NSNumber numberWithBool:YES] forKey:@"debug"];
      // 初始化引擎
      //[DCUniMPSDKEngine initSDKEnvironmentWithLaunchOptions:options];
    
    
    //调用 TUIRegisterThemeResourcePath 注册修改后的主题包资源路径，用于覆盖 TUIChat 内置的主题包，您可以参考 TUIKitDe
    // 自定义修改 TUIChat 组件的主题 - 修改主题资源包中的内置主题
        // -- 1. 获取自定义后的资源包路径
//        NSString *customChatThemePath = [NSBundle.mainBundle pathForResource:@"TUIChatCustomTheme.bundle" ofType:nil];
//        // -- 2. 给 TUIChat 组件注册自定义的主题资源包路径，用于覆盖内置的主题，note: 此时只能覆盖 TUIThemeModuleChat
//        TUIRegisterThemeResourcePath(customChatThemePath, TUIThemeModuleChat);
//
//
//        // TUIKitDemo 注册主题
//        NSString *demoThemePath = [NSBundle.mainBundle pathForResource:@"TUIDemoTheme.bundle" ofType:nil];
//        TUIRegisterThemeResourcePath(demoThemePath, TUIThemeModuleDemo);
//
//
//        [ThemeSelectController applyLastTheme];
//
//
//        [self setupListener];
//        [self setupGlobalUI];
//        [self setupConfig];
//        [self tryAutoLogin];



    return YES;
}



#pragma mark - App 生命周期方法
- (void)applicationDidBecomeActive:(UIApplication *)application {
   // [DCUniMPSDKEngine applicationDidBecomeActive:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
   // [DCUniMPSDKEngine applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   // [DCUniMPSDKEngine applicationDidEnterBackground:application];
//    [[WalletSqlTools share] dbCloseAction]; 
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  //  [DCUniMPSDKEngine applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  //  [DCUniMPSDKEngine destory];
}

#pragma mark - 如果需要使用 URL Scheme 或 通用链接相关功能，请实现以下方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // 通过 url scheme 唤起 App
   // [DCUniMPSDKEngine application:app openURL:url options:options];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    // 通过通用链接唤起 App
   // [DCUniMPSDKEngine application:application continueUserActivity:userActivity];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
