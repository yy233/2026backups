//
//  ZYFormatStringTool.m
//  Community
//
//  Created by ZY on 2021/12/6.
//

#import "ZYFormatStringTool.h"
#import "BRDatePickerView.h"

@implementation ZYFormatStringTool

+ (NSString *)formatTimeStringWithDate:(NSDate *)date {
    NSInteger tempTime = ([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]) / 60;
    if (tempTime < 0) {
        
        return @"-";
    }else if (tempTime < 1) {
        
        return @"刚刚";
    }else if (tempTime < 60) {
        
        return [NSString stringWithFormat:@"%ld分钟前", tempTime];
    }else if (tempTime < 24 * 60) {
        
        return [NSString stringWithFormat:@"%ld小时前", tempTime/60];
    }else if (tempTime < 2 * 24 * 60) {
        
        return @"昨天";
    }else if (tempTime < 3 * 24 * 60) {
        
        return @"前天";
    }else if (tempTime < 30 * 24 * 60) {
        
        return [NSString stringWithFormat:@"%ld天前", tempTime/60/24];
    }else {
        
        return [NSDate br_stringFromDate:date dateFormat:@"yyyy-MM-dd"];
    }
}

+ (NSString *)formatStringWithDistance:(NSInteger)distance {
    if (distance < 0) {
        
        return @"-";
    }else if (distance < 100) {
        
        return @"100m以内";
    }else if (distance < 1000) {
        
        return [NSString stringWithFormat:@"%ldm", distance];
    }else {
        
        return [NSString stringWithFormat:@"%ldkm", distance/1000];
    }
}

@end
