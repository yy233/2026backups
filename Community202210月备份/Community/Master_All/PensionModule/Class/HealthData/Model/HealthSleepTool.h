//
//  HealthSleepTool.h
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HealthSleepTool : NSObject
+ (NSString *)showHMStrTimeWithMinIntValue:(NSInteger)minNum;
+ (NSString *)showDescribeTheChangeHMStrWithChangeMinIntValue:(NSInteger)changeMinNum;
@end

NS_ASSUME_NONNULL_END
