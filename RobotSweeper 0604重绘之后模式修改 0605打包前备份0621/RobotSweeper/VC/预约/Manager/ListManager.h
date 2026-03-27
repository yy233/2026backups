//
//  ListManager.h
//  扫地机闹钟多表联查
//
//  Created by Joey on 2018/4/12.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RobotModel;
@class TimmerModel;

@interface ListManager : NSObject
//+ (void)addRobotWithModel:(RobotModel*)RobotModel;
//+ (void)deleteRobotWithModel:(RobotModel*)RobotModel;

+ (BOOL)addTimerWithModel:(TimmerModel*)timmerModel;
+ (BOOL)deleteTimerWithModel:(TimmerModel*)timmerModel;
+ (BOOL)changeTimerWithModel:(TimmerModel*)timmerModel
                withNewModel:(TimmerModel *)newTimerModel;
+ (NSMutableArray *)searchTimerWithRobot:(NSString *)robotJid;
@end
