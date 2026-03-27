//
//  HealthGetSleepOneDayModel.h
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HealthGetSleepOneDayModel : NSObject
@property (nonatomic,assign) NSInteger totalSleepTime;
@property (nonatomic,assign) NSInteger deepSleepTime;
@property (nonatomic,assign) NSInteger lightSleepTime;
@property (nonatomic,assign) NSInteger wakeUpTime;
@property (nonatomic,assign) NSInteger sleepScore;
@property (nonatomic,strong) NSString *timeValue;
@property (nonatomic,strong) NSString *timeTitle;
@property (nonatomic,strong) NSString *timeWeek;

/**
 data =     {
     compareAvgSleepTime = "<null>";
     lastSevenDayAvgSleepTime = "<null>";
     lastSevenDayTotalSleepTime = "<null>";
     list =         (
                     {
             deepSleepTime = 0;
             lightSleepTime = 0;
             sleepScore = 0;
             timeTitle = "2021年11月17日";
             timeValue = "11/17";
             totalSleepTime = 0;
             wakeUpTime = 0;
         }
     );
 };*/
@end

NS_ASSUME_NONNULL_END
