//
//  AppDelegate+JGPush.h
//  极光Sdk使用
//
//  Created by 余莹 on 2021/9/14.
//

#import "AppDelegate.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）//广告
#import <AdSupport/AdSupport.h>

NS_ASSUME_NONNULL_BEGIN




@interface AppDelegate (JGPush)  <JPUSHRegisterDelegate> 
- (void)jgPushSDKSetup;
- (void)jgSetupWithOption:(NSDictionary *)launchOptions;
- (void)jgPushSDKRegisterDevice:(NSData *)deviceToken;
////自定义展示数据 只有在app运行时可以
//- (void)jgPushSetShowDidReceiveMessage;

 

@end

NS_ASSUME_NONNULL_END
