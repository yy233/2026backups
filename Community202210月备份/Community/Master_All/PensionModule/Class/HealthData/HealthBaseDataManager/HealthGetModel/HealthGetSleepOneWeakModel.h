//
//  HealthGetSleepOneWeakModel.h
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import <Foundation/Foundation.h>
#import "HealthGetSleepOneDayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HealthGetSleepOneWeakModel : NSObject

@property (nonatomic,assign) NSInteger compareAvgSleepTime;
@property (nonatomic,assign) NSInteger lastSevenDayAvgSleepTime;
@property (nonatomic,assign) NSInteger lastSevenDayTotalSleepTime;
@property (nonatomic,strong) NSMutableArray <HealthGetSleepOneDayModel*>*list;
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
