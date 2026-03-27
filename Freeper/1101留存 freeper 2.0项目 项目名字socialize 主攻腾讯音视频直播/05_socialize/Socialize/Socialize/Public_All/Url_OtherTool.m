//
//  Url_OtherTool.m
//  Socialize
//
//  Created by 余莹 on 2023/10/10.
//

#import "Url_OtherTool.h"

@implementation Url_OtherTool
//产生length个长度随机字符串
+ (NSString *)getRandStringWithLength:(int)length {
    NSString *sourceStr = @"0123456789abcdefghijklmnopqrstuvwxyz";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i < length; i++) {
        unsigned index = arc4random() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+ (NSString *)getNewUrlWithAddRandStr:(NSString *)nowUrlPstr{
    if(nowUrlPstr.length<=0){
        return nowUrlPstr;
    }
    NSString *resStr = @"";
    int lenth = (int)( 6 + (arc4random() % ( 16 - 6 + 1) )); //6-16位随机
    NSString *randStr = [self getRandStringWithLength: lenth];
    resStr = [NSString stringWithFormat:@"%@%@",randStr,nowUrlPstr];
    return resStr;
}


+ (NSString *)getNewUrlNeedInterRandStrWithAllUrl:(NSString *)nowAllUrlstr{
    if(nowAllUrlstr.length<=0 || ![nowAllUrlstr containsString:@"%@"]){//适用于带%@的字符
        return nowAllUrlstr;
    }
    NSString *resStr = @"";
    int lenth = (int)( 6 + (arc4random() % ( 16 - 6 + 1) )); //6-16位随机
    NSString *randStr = [self getRandStringWithLength: lenth];
    resStr = [NSString stringWithFormat:nowAllUrlstr,randStr];
    return resStr;
}
@end
