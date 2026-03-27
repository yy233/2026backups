//
//  ZYFormatStringTool.h
//  Community
//
//  Created by ZY on 2021/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYFormatStringTool : NSObject

+ (NSString *)formatTimeStringWithDate:(NSDate *)date;

+ (NSString *)formatStringWithDistance:(NSInteger)distance;

@end

NS_ASSUME_NONNULL_END
