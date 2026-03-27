//
//  TUIGiftViewLocalized.m
//  Pods
//
//  Created by WesleyLei on 2021/9/7.
//  Copyright © 2021 wesleylei. All rights reserved.
//

#import "TUIBarrageLocalized.h"

#pragma mark - Base
NSBundle *TUIBarrageBundle(void) {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //没使用Framework的情况下
        NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:@"TUIBarrageBundle" withExtension:@"bundle"];
        //使用framework形式
        if (!associateBundleURL) {
            associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
            associateBundleURL = [associateBundleURL URLByAppendingPathComponent:@"TUIBarrage"];
            associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
            NSBundle *associateBundle = [NSBundle bundleWithURL:associateBundleURL];
            associateBundleURL = [associateBundle URLForResource:@"TUIBarrageBundle" withExtension:@"bundle"];
        }
        bundle = [NSBundle bundleWithURL:associateBundleURL];
    });
    return bundle;
}

NSString *TUIBarrageLocalizeLanguageKey(void) {
    NSString *nowLangeStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Locale_Type"]];
    //    NSString *language = [NSLocale preferredLanguages].firstObject;
    NSString *language = nowLangeStr;
    
//    if ([language hasPrefix:@"en"]) {
//        return @"en";
//    } else if ([language hasPrefix:@"zh"]) {
//        return @"zh-Hans";
//    } else {
////        return @"en";
//        return nowLangeStr;
//    }
//
    //聊天的语言初始设置 //0901
    if([language isEqualToString: @"en"] || [language isEqualToString:@"zh-Hans"] || [language isEqualToString:@"zh-Hant"] || [language isEqualToString:@"ja"]){
        return language;
    }else if([language containsString: @"ko"]){//韩文
        return @"ko";
    }else{
        return @"en";//不是五种语言 切成英文
    }
}


//底部按钮部分可多语言 部分不可
NSString *TUIBarrageLocalizeFromTable(NSString *key, NSString *table) {
    //从FrameworkTestBundle.bundle中查找资源
    NSString *bundlePath = [TUIBarrageBundle() pathForResource:TUIBarrageLocalizeLanguageKey() ofType:@"lproj"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return  [bundle localizedStringForKey:key value:@"" table:table];
}

#pragma mark - Calling
NSString *const TUIBarrage_Localize_TableName = @"Localized";
NSString *TUIBarrageLocalize(NSString *key) {
    return TUIBarrageLocalizeFromTable(key, TUIBarrage_Localize_TableName);
}

