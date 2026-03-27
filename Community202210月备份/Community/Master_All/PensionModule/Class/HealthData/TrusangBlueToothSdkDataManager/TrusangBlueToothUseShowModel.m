//
//  TrusangBlueToothUseShowModel.m
//  Community
//
//  Created by 余莹 on 2021/11/11.
//

#import "TrusangBlueToothUseShowModel.h"

@implementation TrusangBlueToothUseShowModel
 
/**
 
 @property (nonatomic,strong) NSMutableArray *histroy_TempArr;
 @property (nonatomic,strong) NSMutableArray *histroy_SleepArr;
 @property (nonatomic,strong) NSMutableArray *histroy_HeartRateArr;
 @property (nonatomic,strong) NSMutableArray *histroy_BpSpArr;
 @property (nonatomic,strong) NSMutableArray *histroy_BoArr;

 (ZHJHeartRate * _Nonnull hr, ZHJBloodPressure * _Nonnull bp, ZHJBloodOxygen * _Nonnull bo) {
 */
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"histroy_TempArr" :      [ZHJTemperature class],
             @"histroy_SleepArr" :     [ZHJSleep class],
             @"histroy_HeartRateArr" : [ZHJHeartRate class],
             @"histroy_BpSpArr" :      [ZHJBloodPressure class],
             @"histroy_BoArr" :        [ZHJBloodOxygen class]
    };
}
@end
