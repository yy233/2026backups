//
//  ZYWeekStringTool.h
//  Community
//
//  Created by ZY on 2021/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYWeekStringTool : NSObject

+ (NSString *)weekdayStringWithNum:(NSInteger)weekNum;

+ (NSInteger)weekdayNumWithString:(NSString *)weekStr;

@end

NS_ASSUME_NONNULL_END
