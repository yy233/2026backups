//
//  TrusangBlueToothUseShowModel.h
//  Community
//
//  Created by 余莹 on 2021/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrusangBlueToothUseShowModel : NSObject
@property (nonatomic,strong) NSString *saveNowDevName;
@property (nonatomic,strong) NSString *saveNowDevMac;
@property (nonatomic,strong) NSString *saveNowDevVersion; 

@property (nonatomic,assign) NSInteger powerIntVale;
@property (nonatomic,assign) double temperature;
@property (nonatomic,assign) NSInteger heartRete;
@property (nonatomic,assign) NSInteger bp_bp;
@property (nonatomic,assign) NSInteger bp_sp;
@property (nonatomic,assign) NSInteger bo;
@property (nonatomic,assign) double sleepAllTimeDoubleV;
//当前健康记录 //没给这个做kvo 要依附于上边存数据的kvo
@property (nonatomic,strong) ZHJHeartRateDetail *now_HeartRateDetail;//心率
@property (nonatomic,strong) ZHJBloodPressureDetail *now_BpDetail;
@property (nonatomic,strong) ZHJBloodOxygenDetail *now_BoDetail;
@property (nonatomic,strong) ZHJTemperatureDetail *now_TempDetail;//体温
//历史记录
@property (nonatomic,strong) NSMutableArray <ZHJTemperature *>   *histroy_TempArr;
@property (nonatomic,strong) NSMutableArray <ZHJSleep *>         *histroy_SleepArr;
@property (nonatomic,strong) NSMutableArray <ZHJHeartRate *>     *histroy_HeartRateArr;
@property (nonatomic,strong) NSMutableArray <ZHJBloodPressure *> *histroy_BpSpArr;
@property (nonatomic,strong) NSMutableArray <ZHJBloodOxygen *>   *histroy_BoArr;
 
//健康数据警告区间相关
@property (nonatomic,assign) double temperatureAlarmLimit_Max;
@property (nonatomic,assign) double temperatureAlarmLimit_Min;
@property (nonatomic,assign) double heartReteAlarmLimit_Min;
@property (nonatomic,assign) double heartReteAlarmLimit_Max;

@end

NS_ASSUME_NONNULL_END
