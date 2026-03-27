//
//  HealthSleepTool.m
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import "HealthSleepTool.h"

@implementation HealthSleepTool
+ (NSString *)showHMStrTimeWithMinIntValue:(NSInteger)minNum
{
    int minutes = minNum % 60;
    int hours = (int)(minNum / 60);
    if ( (hours<=0) && (minutes <=0)) {
        return [NSString stringWithFormat:@"0分钟"];
    }else if (hours<=0) {
        return [NSString stringWithFormat:@"%02d分钟", minutes];
    }else if(minutes <=0){
        return [NSString stringWithFormat:@"%02d小时0分钟",hours];
    }else{
        return [NSString stringWithFormat:@"%02d小时%02d分钟",hours, minutes];
    }
 
}

+ (NSString *)showDescribeTheChangeHMStrWithChangeMinIntValue:(NSInteger)changeMinNum {
    NSString *descroneStr = @"";
    NSString *subTimeStr = @"";
    
    if (changeMinNum == 0) {
        descroneStr = @"无变化";
    }else if (changeMinNum < 0){
        descroneStr = @"少";
        subTimeStr = [self showHMStrTimeWithMinIntValue:(labs(changeMinNum))];
    }else if (changeMinNum > 0){
        descroneStr = @"多";
        subTimeStr = [self showHMStrTimeWithMinIntValue:changeMinNum];
    }
    return [descroneStr stringByAppendingString:subTimeStr];
}
@end
