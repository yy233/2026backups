//
//  ZYDecimalNumberTool.h
//  Community
//
//  Created by ZY on 2022/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYDecimalNumberTool : NSObject

+ (float)floatWithdecimalNumber:(double)num;

+ (float)floatWithDecimalString:(NSString *)str;

+ (double)doubleWithdecimalNumber:(double)num;

+ (NSString *)stringWithDecimalNumber:(double)num;

+ (NSString *)stringWithDecimalString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
