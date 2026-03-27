//
//  BaseHealthHeader.h
//  Community
//
//  Created by 余莹 on 2021/11/13.
//

#ifndef BaseHealthHeader_h
#define BaseHealthHeader_h



////未知状态0 123优良差
typedef enum : NSUInteger {
    HealthShow_Type_NoStaus = 0,
    HealthShow_Type_Good    = 1,    //良好
    HealthShow_Type_Warning = 2,    //需要注意
    HealthShow_Type_Bad     = 3,    //危险
} HealthShow_Type; //健康状态
//1：绿色，2：黄色，3：红色 同后台数据一样
static NSString *kHealthShow_Type_Good_Str = @"健康良好";
static NSString *kHealthShow_Type_Warning_Str = @"一般";
static NSString *kHealthShow_Type_Bad_Str = @"较差";

/**
 6-8小时以上绿色

 4-6小时黄色

 4小时以下红色
 */

static NSInteger DaySleepMinutesInv_GreenColorMin = 6*60;
static NSInteger DaySleepMinutesInv_OrangeColorMin = 4*60;


#define Color_HealthShow_Type_NoStaus      Y_ColorWith16FromRGB(0xC5C9D4)
#define Color_HealthShow_Type_Good         Y_ColorWith16FromRGB(0x1CD298)
#define Color_HealthShow_Type_Warning      Y_ColorWith16FromRGB(0xFE9C36)
#define Color_HealthShow_Type_Bad          Y_ColorWith16FromRGB(0xFF3F3F)

#import "DevGetNowUsersDevInfoModel.h"
#import "DevGetRecentHealthModel.h"
#import "DevUpDataSleepModel.h"
#import "DevUpDataTemperatureModel.h"
#import "DevUpDataHeartRateModel.h"

#define  Color_HealthMainGreenColor        Y_ColorWith16FromRGB(0x36C8C1)

#import "HealthBaseTotalDataContTouchTableViewCell.h" //不可点击basecell


#import "HealthSleepTotalVc.h"
#import "HealthTemperatureAndHeartBaseTotalVc.h"
#import "HealthTemperatureTotalVc.h"
#import "HealthHeartTotalVc.h"


 
#import "HealthGetSleepOneDayModel.h"
#import "HealthGetSleepOneWeakModel.h"

//深睡one 浅睡two 梦醒thr
//绿色
#define Color_HealthShow_SleepType_Green_Deep      Y_ColorWith16FromRGB(0x1CB1AA)
#define Color_HealthShow_SleepType_Green_Light     Y_ColorWith16FromRGB(0x36C8C1)
#define Color_HealthShow_SleepType_Green_Awake     Y_ColorWith16FromRGB(0xA4F0EC)
//橘色
#define Color_HealthShow_SleepType_Orange_Deep      Y_ColorWith16FromRGB(0xF56D2A)
#define Color_HealthShow_SleepType_Orange_Light     Y_ColorWith16FromRGB(0xFA8951)
#define Color_HealthShow_SleepType_Orange_Awake     Y_ColorWith16FromRGB(0xFFBFA0)


#endif /* BaseHealthHeader_h */
