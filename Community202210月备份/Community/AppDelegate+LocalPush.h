//
//  AppDelegate+LocalPush.h
//  Community
//
//  Created by ZY on 2021/11/27.
//

#import "AppDelegate.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (LocalPush) <UNUserNotificationCenterDelegate>

- (void)localNotificationSetup;

@end

NS_ASSUME_NONNULL_END
