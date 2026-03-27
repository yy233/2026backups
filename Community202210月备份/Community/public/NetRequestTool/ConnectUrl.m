//
//  ConnectUrl.m
//  Community
//
//  Created by 余莹 on 2020/12/23.
//

#import "ConnectUrl.h"

@implementation ConnectUrl
/**
 * 传入参数与url，拼接为一个带参数的url
 **/
//+(NSString *) connectUrl:(NSMutableDictionary *)params url:(NSString *) urlLink{
//    // 初始化参数变量
//    NSString *str = @"&";
//
//    // 快速遍历参数数组
//    for(id key in params) {
//        NSLog(@"key :%@  value :%@", key, [params objectForKey:key]);
//        str = [str stringByAppendingString:key];
//        str = [str stringByAppendingString:@"＝"];
//        if ([[params objectForKey:key] isKindOfClass: [NSNumber class]]) {
//            str = [str stringByAppendingFormat:@"%ld", (long)[[params objectForKey:key] integerValue]];
//        }else{
//            str = [str stringByAppendingString:[params objectForKey:key]];
//        }
//        str = [str stringByAppendingString:@"&"];
//    }
//    // 处理多余的&以及返回含参url
//    if (str.length > 1) {
//        // 去掉末尾的&
//        str = [str substringToIndex:str.length - 1];
//        // 返回含参url
//        return [urlLink stringByAppendingString:str];
//    }
//    return Nil;
//}

/**?+&
 eg:
 url=http://smart.free.idcfengye.com/api/v1/proprietor/user/query?houseId=115&token=dd9988432a4a4fb7aaeb8694d0242637
 */
+(NSString *) connectUrl:(NSMutableDictionary *)params url:(NSString *) urlLink{
    // 初始化参数变量
    NSString *strFirstHeader = @"?";
    NSString *strOtherHeader = @"&";
    __block  NSString *str = @"";
    NSArray *keyArr = [params allKeys];
    [keyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = keyArr[idx];
        NSLog(@"key :%@  value :%@", key, [params objectForKey:key]);
        if (idx==0) {
            str = [strFirstHeader stringByAppendingString:key];
        }else{
            str = [str stringByAppendingString:key];
        }
        str = [str stringByAppendingString:@"="];
        if ([[params objectForKey:key] isKindOfClass: [NSNumber class]]) {
            str = [str stringByAppendingFormat:@"%ld", (long)[[params objectForKey:key] integerValue]];
        }else{
//            str = [str stringByAppendingString:[params objectForKey:key]];//中文符号转英文符号
            str = [str stringByAppendingString:[[params objectForKey:key] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];//中文符号转英文符号
      
        }
        str = [str stringByAppendingString:strOtherHeader];
    }];
    // 处理多余的&以及返回含参url
    if (str.length > 1) {
        // 去掉末尾的&
        str = [str substringToIndex:str.length - 1];
        // 返回含参url
        return [urlLink stringByAppendingString:str];
    }
//    return Nil;
    return @"";
}
@end
