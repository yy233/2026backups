//
//  NSString+ReplceStr.m
//  Community
//
//  Created by 余莹 on 2021/6/7.
//

#import "NSString+ReplceStr.h"

@implementation NSString (ReplceStr)
- (NSString *)replaceStringWithAsteriskStartLocation:(NSInteger)startLocation length:(NSInteger)length {
    NSString *replaceStr = self;
    for (NSInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        replaceStr = [replaceStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return replaceStr;
}
@end
