//
//  localeTool.m
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//

#import "localeTool.h"
/**
 参数：
 locale：语言[en,ja,korean,zh-Hans,zh-Hant]（英，日，韩，简中，繁中）
 utm_source：来源[freeper.ios,freeper.android]
 r：随机数（可选，目的不缓存网页）
 */


 
//用于获取或者存储路径的
NSString * const Now_Locale_Type_en = @"en";
NSString * const Now_Locale_Type_ja = @"ja";
//NSString * const Now_Locale_Type_korean = @"korean";
NSString * const Now_Locale_Type_ko = @"ko";
NSString * const Now_Locale_Type_zhHans = @"zh-Hans";
NSString * const Now_Locale_Type_zhHant = @"zh-Hant";


//用于显示的
NSString * const Now_Locale_Type_Show_en = @"English";
NSString * const Now_Locale_Type_Show_ja = @"日本語";
NSString * const Now_Locale_Type_Show_korean = @"한국어";
NSString * const Now_Locale_Type_Show_zhHans = @"简体中文";
NSString * const Now_Locale_Type_Show_zhHant = @"繁體中文";




//用于显示的
NSString * const Now_Theme_light = @"light";
NSString * const Now_Theme_dark = @"dark";


@implementation localeTool


@end
