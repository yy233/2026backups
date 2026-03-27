//
//  VoiceRoomLocalized.m
//  Pods
//
//  Created by abyyxwang on 2021/5/6.
//  Copyright © 2022 Tencent. All rights reserved.

#import "VoiceRoomLocalized.h"

#pragma mark - Base
//官方旧版
NSBundle *voiceRoomBundleM() {
    NSURL *voiceRoomKitBundleURL = [[NSBundle mainBundle] URLForResource:@"TUIVoiceRoomKitBundle" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:voiceRoomKitBundleURL];
}
//当前可用 非文本的
NSBundle *voiceRoomBundle_UseNoTexType() {

    NSURL *voiceRoomKitBundleURL = [[NSBundle mainBundle] URLForResource:@"TUIVoiceRoomKitBundle" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:voiceRoomKitBundleURL];
    
}


//当前可用 文本的
NSBundle *voiceRoomBundle() {

    Class selfClass = NSClassFromString(@"TRTCVoiceRoom");//本voice库的主文件之一 不用self它非类
    if(selfClass == nil){
        NSURL *x = [[NSBundle mainBundle] URLForResource:@"TUIVoiceRoomKitBundle" withExtension:@"bundle"];
        NSBundle *y = [NSBundle bundleWithURL:x];
        return y;
    }
    //当前库用到的Bundle
    NSBundle *selfNSBundle = [NSBundle bundleForClass: selfClass];
    NSURL *liveRoomKitBundleURL = [selfNSBundle  URLForResource:@"TUIVoiceRoomKitBundle" withExtension:@"bundle"];
    NSBundle *liveRoomBundle = [NSBundle bundleWithURL:liveRoomKitBundleURL];

    //Bundle拼接上当前所需设置语言的尾缀
    NSString *nowLangeStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Locale_Type"]];
    
    NSString *localeType = nowLangeStr;
   /**
    //___ 中英支持

    if([localeType isEqualToString: @"en"] || [localeType isEqualToString:@"zh-Hans"]){
        //中英文
        // nowLangeStr 不改动
    
    }else if([localeType isEqualToString:@"zh-Hant"]){
        //@"zh-Hans" 中文 繁简 //语言  繁体时切换 中简@"zh-Hans"
        nowLangeStr = @"zh-Hans";
    }else{
        //其他
        nowLangeStr = @"en";
    }
    //___ 中英支持
    
    //0830去掉限制 当前允许五种
    
    */

    //聊天的语言初始设置 0830
    if([localeType isEqualToString: @"en"] || [localeType isEqualToString:@"zh-Hans"] || [localeType isEqualToString:@"zh-Hant"] || [localeType isEqualToString:@"ja"]){
    }else if([localeType containsString: @"ko"]){//韩文
        nowLangeStr = @"ko";
    }else{
        nowLangeStr = @"en";//不是五种语言 切成英文
    }
    
    NSString *nowLanglprojFailBundlePathStr = [liveRoomBundle pathForResource:nowLangeStr  ofType:@"lproj"];
    NSBundle *nowLanglprojFailBundle = [NSBundle bundleWithPath: nowLanglprojFailBundlePathStr];
    
    return nowLanglprojFailBundle;
    
}


 



NSString *tvrLocalizeFromTable(NSString *key, NSString *table) {
    return [voiceRoomBundle() localizedStringForKey:key value:@"" table:table];
}

NSString *tvrLocalizeFromTableAndCommon(NSString *key, NSString *common, NSString *table) {
    return tvrLocalizeFromTable(key, table);
}

#pragma mark - Replace String
NSString *localizeReplaceXX(NSString *origin, NSString *xxx_replace) {
    if (xxx_replace == nil) { xxx_replace = @"";}
    return [origin stringByReplacingOccurrencesOfString:@"xxx" withString:xxx_replace];
}

NSString *localizeReplace(NSString *origin, NSString *xxx_replace, NSString *yyy_replace) {
    if (yyy_replace == nil) { yyy_replace = @"";}
    return [localizeReplaceXX(origin, xxx_replace) stringByReplacingOccurrencesOfString:@"yyy" withString:yyy_replace];
}

NSString *localizeReplaceThreeCharacter(NSString *origin, NSString *xxx_replace, NSString *yyy_replace,
 NSString *zzz_replace) {
    if (zzz_replace == nil) { zzz_replace = @"";}
    return [localizeReplace(origin, xxx_replace, yyy_replace) stringByReplacingOccurrencesOfString:@"zzz" withString:zzz_replace];
}

NSString *localizeReplaceFourCharacter(NSString *origin, NSString *xxx_replace, NSString *yyy_replace,
 NSString *zzz_replace, NSString *mmm_replace) {
    if (mmm_replace == nil) { mmm_replace = @"";}
    return [localizeReplaceThreeCharacter(origin, xxx_replace, yyy_replace, zzz_replace)
     stringByReplacingOccurrencesOfString:@"mmm" withString:mmm_replace];
}

NSString *localizeReplaceFiveCharacter(NSString *origin, NSString *xxx_replace, NSString *yyy_replace,
 NSString *zzz_replace, NSString *mmm_replace, NSString *nnn_replace) {
    if (nnn_replace == nil) { nnn_replace = @"";}
    return [localizeReplaceFourCharacter(origin, xxx_replace, yyy_replace, zzz_replace,
     mmm_replace) stringByReplacingOccurrencesOfString:@"nnn" withString:nnn_replace];
}


#pragma mark - VoiceRoom
NSString *const voiceRoom_Localize_TableName = @"VoiceRoomLocalized";
NSString *voiceRoomLocalize(NSString *key) {
    return tvrLocalizeFromTable(key, voiceRoom_Localize_TableName);
}



