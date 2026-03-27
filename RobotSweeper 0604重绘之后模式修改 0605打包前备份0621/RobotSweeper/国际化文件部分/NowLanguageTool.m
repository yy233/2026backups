//
//  NowLanguageTool.m
//  RobotSweeper
//
//  Created by Joey on 2018/12/14.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "NowLanguageTool.h"

@implementation NowLanguageTool

/**  *得到本机现在用的语言  * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ......  */
+ (int)robotAppOfGetPreferredLanguageNum {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"robotAppOfGetPreferredLanguageNum Language:%@", preferredLang);
    
    if ([preferredLang containsString:@"zh-Hans"] || [preferredLang containsString:@"zh-Hant"] || [preferredLang containsString:@"zh"]) {//中简体／中文繁体
        return 0;//中文
    } else {
        return 1;//英文
    }
    
}

@end
