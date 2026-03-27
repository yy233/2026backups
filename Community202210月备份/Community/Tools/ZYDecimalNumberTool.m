//
//  ZYDecimalNumberTool.m
//  Community
//
//  Created by ZY on 2022/3/17.
//

#import "ZYDecimalNumberTool.h"

@implementation ZYDecimalNumberTool

+ (float)floatWithdecimalNumber:(double)num {
   return [[self decimalNumber:num] floatValue];
}

+ (float)floatWithDecimalString:(NSString *)str {
    return [[self decimalNumber:[str doubleValue]] floatValue];
}

+ (double)doubleWithdecimalNumber:(double)num {
   return [[self decimalNumber:num] doubleValue];
}

+ (NSString *)stringWithDecimalNumber:(double)num {
   return [[self decimalNumber:num] stringValue];
}

+ (NSString *)stringWithDecimalString:(NSString *)str {
   return [[self decimalNumber:[str doubleValue]] stringValue];
}

+ (NSDecimalNumber *)decimalNumber:(double)num {
   NSString *numString = [NSString stringWithFormat:@"%lf", num];
   return [NSDecimalNumber decimalNumberWithString:numString];
}

@end
