//
//  ZYWeekStringTool.m
//  Community
//
//  Created by ZY on 2021/12/3.
//

#import "ZYWeekStringTool.h"

@implementation ZYWeekStringTool

+ (NSString *)weekdayStringWithNum:(NSInteger)weekNum {
    switch (weekNum) {
        case 1:
        {
            return @"周一";
        }
            break;
        case 2:
        {
            return @"周二";
        }
            break;
        case 3:
        {
            return @"周三";
        }
            break;
        case 4:
        {
            return @"周四";
        }
            break;
        case 5:
        {
            return @"周五";
        }
            break;
        case 6:
        {
            return @"周六";
        }
            break;
        case 7:
        {
            return @"周日";
        }
            break;
            
        default:
            break;
    }
    
    return @"";
}

+ (NSInteger)weekdayNumWithString:(NSString *)weekStr {
    if ([weekStr isEqual:@"周一"]) {
        
        return 1;
    }else if ([weekStr isEqual:@"周二"]) {
        
        return 2;
    }else if ([weekStr isEqual:@"周三"]) {
        
        return 3;
    }else if ([weekStr isEqual:@"周四"]) {
        
        return 4;
    }else if ([weekStr isEqual:@"周五"]) {
        
        return 5;
    }else if ([weekStr isEqual:@"周六"]) {
        
        return 6;
    }else if ([weekStr isEqual:@"周日"]) {
        
        return 7;
    }
    
    return 0;
}

@end
