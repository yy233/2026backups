//
//  ZBLocalNotification.h
//  Backlog
//
//  Created by Zombie on 2018/11/1.
//  Copyright © 2018 Zombie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

typedef NS_ENUM(NSInteger, ZBLocalNotificationRepeat) {
    ZBLocalNotificationRepeatNone,
    ZBLocalNotificationRepeatEveryDay,
    ZBLocalNotificationRepeatEveryWeek,
    ZBLocalNotificationRepeatEveryMonth,
    ZBLocalNotificationRepeatEveryYear,
    ZBLocalNotificationRepeatEveryWorkDay
};

typedef NSString * ZBLocalNotificationKey;
typedef NSString * ZBLocalNotificationSoundName;

extern ZBLocalNotificationKey const ZBNotificationFireDate;         //提醒时间
extern ZBLocalNotificationKey const ZBNotificationAlertTitle;       //标题
extern ZBLocalNotificationKey const ZBNotificationAlertBody;        //提醒内容
extern ZBLocalNotificationKey const ZBNotificationAlertAction;      //按钮
extern ZBLocalNotificationKey const ZBNotificationSoundName;        //声音
extern ZBLocalNotificationKey const ZBNotificationUserInfoName;     //通知名
extern ZBLocalNotificationKey const ZBNotificationPriority;         //通知优先级
extern ZBLocalNotificationKey const ZBNotificationRepeat;           //通知是否重复
extern ZBLocalNotificationSoundName const ZBNotificationSoundAlarm; //声音提醒方式
extern ZBLocalNotificationSoundName const ZBNotificationSoundOther; //其它声音提醒方式

@interface ZBLocalNotification : NSObject

/**
 创建本地通知

 @param attribute 通知的属性
 */
+ (void)createLocalNotificationWithAttribute:(NSDictionary *)attribute;

/**
 取消通知

 @param notificationName 通知名字
 */
+ (void)cancelLocalNotificationWithName:(NSString *)notificationName;

/**
 取消通知集合

 @param notiIds 通知id数组
 */
+ (void)cancelLocalNotificationWithNotiIds:(NSArray *)notiIds;

@end

