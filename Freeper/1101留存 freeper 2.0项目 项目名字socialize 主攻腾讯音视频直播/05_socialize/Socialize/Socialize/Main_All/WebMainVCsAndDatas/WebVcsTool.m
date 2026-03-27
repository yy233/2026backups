//
//  WebVcsTool.m
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//

#import "WebVcsTool.h"


/**
 参数：
 locale：语言[en,ja,korean,zh-Hans,zh-Hant]（英，日，韩，简中，繁中）
 utm_source：来源[freeper.ios,freeper.android]
 r：随机数（可选，目的不缓存网页）
 */

//#define   webViewBase_InfoStr   @"locale=zh-Hans&utm_source=freeper.ios&r=12#/pages/user/index"

@implementation WebVcsTool

+ (NSString *)getWebUrlLocaleStr{
    NSString * loac = [ShareLocale shared].nowLocaleTypeStr;
    NSString * loacleStr = [NSString stringWithFormat:@"locale=%@",loac];
    NSString * utm_sourceStr = @"utm_source=freeper.ios";
    NSString * rStr = [NSString stringWithFormat:@"r=%d",[Y_ToolOfOthers getRandomInt:1 to:99999]];
    NSString * allSuffixStr  =  [NSString stringWithFormat:@"%@&%@&%@",loacleStr,utm_sourceStr,rStr];
     
    if([ShareLocale shared].nowThemeStr.length >0){
        NSString *theme  = [[ShareLocale shared] getNowThemeTypeStr];
        allSuffixStr = [NSString stringWithFormat:@"%@&theme=%@",allSuffixStr, theme];
    }
    NSLog(@"当前webv语言 %@ \n baseWebUrlSuffixStr -- %@",loacleStr,allSuffixStr);
    return allSuffixStr;
    
    
}
+ (NSString *)getWebUrlLocaleStrNotRandomstr{
    NSString * loac = [ShareLocale shared].nowLocaleTypeStr;
    NSString * loacleStr = [NSString stringWithFormat:@"locale=%@",loac];
    NSString * utm_sourceStr = @"utm_source=freeper.ios";
    NSString * allSuffixStr  =  [NSString stringWithFormat:@"%@&%@",loacleStr,utm_sourceStr];
    if([ShareLocale shared].nowThemeStr.length >0){
        NSString *theme  = [[ShareLocale shared] getNowThemeTypeStr];
        allSuffixStr = [NSString stringWithFormat:@"%@&theme=%@",allSuffixStr, theme];
    }
    NSLog(@"当前webv语言 %@ \n baseWebUrlSuffixStr -- %@",loacleStr,allSuffixStr);

    return allSuffixStr;
    
    
}

@end
