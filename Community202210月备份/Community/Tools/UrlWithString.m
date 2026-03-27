//
//  UrlWithString.m
//  Community
//
//  Created by 余莹 on 2020/12/19.
//

#import "UrlWithString.h"

@implementation UrlWithString
+ (NSURL *)getURLWithStr:(NSString *)str{
    NSURL *newUrl = [NSURL URLWithString:@"http://baidu.com"];
    if (isNotNil(str) && str.length>0) {
        NSString *newStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//把中文处理掉
        newUrl = [NSURL URLWithString:newStr];
    }
    return newUrl;
}
@end
