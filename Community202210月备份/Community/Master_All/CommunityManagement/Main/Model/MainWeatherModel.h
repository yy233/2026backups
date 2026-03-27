//
//  MainWeatherModel.h
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainWeatherModel : NSObject
//
@property (nonatomic,strong) NSString *pname;
@property (nonatomic,strong) NSString *secondaryname;
@property (nonatomic,strong) NSString *name;
//
@property (nonatomic,assign)NSInteger windSpeed;
@property (nonatomic,assign)NSInteger windLevel;
@property (nonatomic,assign)NSInteger temp;
@property (nonatomic,assign)NSInteger tempDay;
@property (nonatomic,assign)NSInteger tempNight;
//@property (nonatomic,assign)NSInteger ;
//@property (nonatomic,strong)NSString *;
@property (nonatomic,strong)NSString *updateDay;
@property (nonatomic,strong)NSString *windDir;
@property (nonatomic,strong)NSString *tips;
@property (nonatomic,strong)NSString *dayOfWeek;
@property (nonatomic,strong)NSString *condition;
//
@property (nonatomic,assign)NSInteger conditionId;
@property (nonatomic,assign)NSInteger conditionIdDay;
@property (nonatomic,assign)NSInteger conditionIdNight;

/**
 ]data =     {
 city =         {
     cityId = 86;
     counname = "中国";
     ianatimezone = "Asia/Shanghai";
     name = "渝北区";
     pname = "重庆市";
     secondaryname = "重庆市";
     timezone = 8;
 };
 condition =         {
     condition = "小雨";
     conditionId = 51;
     dayOfWeek = "周一";
     humidity = 90;
     icon = 7;
     pressure = 968;
     realFeel = 5;
     sunRise = "2021-01-21 07:48:00";
     sunSet = "2021-01-21 18:22:00";
     temp = 7;
     tips = "今天有雨，天冷了，该加衣服了！";
     updateDay = "01/25";
     updatetime = "2021-01-25 11:14:21";
     uvi = 1;
     vis = 2500;
     windDegrees = 135;
     windDir = "东南风";
     windLevel = 2;
     windSpeed = "2.0";
 };
 forecast =         (
                 {
         conditionDay = "多云";
         conditionIdDay = 1;
         conditionIdNight = 30;
         conditionNight = "晴";
         dayOfWeek = "周二";
         humidity = 83;
         moonphase = WaxingGibbous;
         moonrise = "2021-01-22 13:16:00";
         moonset = "2021-01-22 01:54:00";
         pop = 40;
         predictDate = "2021-01-22";
         qpf = "0.3";
         sunrise = "2021-01-22 07:48:00";
         sunset = "2021-01-22 18:23:00";
         tempDay = 11;
         tempNight = 4;
         updateDay = "01/26";
         updatetime = "2021-01-26 11:14:21";
         uvi = 1;
         windDegreesDay = 90;
         windDegreesNight = 90;
         windDirDay = "东风";
         windDirNight = "东风";
         windLevelDay = 1;
         windLevelNight = 2;
         windSpeedDay = "0.9";
         windSpeedNight = "2.4";
     },
                 {
         conditionDay = "多云";
         conditionIdDay = 1;
         conditionIdNight = 31;
         conditionNight = "多云";
         dayOfWeek = "周三";
         humidity = 75;
         moonphase = WaxingGibbous;
         moonrise = "2021-01-23 13:50:00";
         moonset = "2021-01-23 02:48:00";
         pop = 20;
         predictDate = "2021-01-23";
         qpf = "0.0";
         sunrise = "2021-01-23 07:48:00";
         sunset = "2021-01-23 18:24:00";
         tempDay = 15;
         tempNight = 5;
         updateDay = "01/27";
         updatetime = "2021-01-27 11:14:21";
         uvi = 4;
         windDegreesDay = 90;
         windDegreesNight = 90;
         windDirDay = "东风";
         windDirNight = "东风";
         windLevelDay = 1;
         windLevelNight = 1;
         windSpeedDay = "0.9";
         windSpeedNight = "0.9";
    */
@end

NS_ASSUME_NONNULL_END
