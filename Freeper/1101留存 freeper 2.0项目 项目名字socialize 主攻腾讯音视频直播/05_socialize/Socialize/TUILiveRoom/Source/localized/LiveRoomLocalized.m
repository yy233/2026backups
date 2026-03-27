//
//  LiveRoomLocalized.m
//  Pods
//
//  Created by abyyxwang on 2021/5/6.
//  Copyright © 2022 Tencent. All rights reserved.

#import "LiveRoomLocalized.h"


/**
 *NSString *mainSwiftUseLanguageStr(NSString *key){
  NSString *nowLangeStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Locale_Type"]];
 NSString *nowLanglprojFailBundlePathStr = [[NSBundle mainBundle] pathForResource:nowLangeStr  ofType:@"lproj"];
 NSBundle *nowLanglprojFailBundle = [NSBundle bundleWithPath: nowLanglprojFailBundlePathStr];
 * c =  NSBundle </var/containers/Bundle/Application/7ECE0CB7-7CC9-44D6-9AC1-EED7631EEE41/Socialize.app/zh-Hant.lproj> (not yet loaded)主工程的语言bud
 NSString *getStr = [nowLanglprojFailBundle  localizedStringForKey:key value:@"" table:@"Locale_Type"];

 return getStr;
}

 */
#pragma mark - Base

// 官方旧版 可用于图片类型
NSBundle *liveRoomBundleM(void) {

    NSURL *liveRoomKitBundleURL = [[NSBundle mainBundle] URLForResource:@"TUILiveRoomKitBundle" withExtension:@"bundle"];
    NSBundle *liveRoomBundle = [NSBundle bundleWithURL:liveRoomKitBundleURL];
    return liveRoomBundle;
}

// 官方旧版 可用于图片类型
NSBundle *liveRoomBundle_UseNoTexType(void) {

    NSURL *liveRoomKitBundleURL = [[NSBundle mainBundle] URLForResource:@"TUILiveRoomKitBundle" withExtension:@"bundle"];
    NSBundle *liveRoomBundle = [NSBundle bundleWithURL:liveRoomKitBundleURL];
    return liveRoomBundle;
}


//当前可用
NSBundle *liveRoomBundle(void) {
    Class selfClass = NSClassFromString(@"TRTCLiveRoom");//本live库的主文件之一 不用self它非类
    if(selfClass == nil){
        NSURL *x = [[NSBundle mainBundle] URLForResource:@"TUILiveRoomKitBundle" withExtension:@"bundle"];
        NSBundle *y = [NSBundle bundleWithURL:x];
        return y;
    }
    //当前库用到的Bundle
    NSBundle *selfNSBundle = [NSBundle bundleForClass: selfClass];
    NSURL *liveRoomKitBundleURL = [selfNSBundle  URLForResource:@"TUILiveRoomKitBundle" withExtension:@"bundle"];
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
    
    /**
     (lldb) po selfClass
     TRTCLiveRoom

     (lldb) po selfNSBundle
     TUIBundle </private/var/containers/Bundle/Application/DD665C65-7B67-437C-97DC-079361C3B597/Socialize.app> (loaded)

     (lldb) po liveRoomKitBundleURL
     file:///private/var/containers/Bundle/Application/DD665C65-7B67-437C-97DC-079361C3B597/Socialize.app/TUILiveRoomKitBundle.bundle/

     (lldb)
     /Socialize.app/TUILiveRoomKitBundle.bundle/en.lproj 这个格式可以拿到英文的文本。但是会导致图片拿不到
     */
    
}


NSString *liveRoomLocalizeFromTable(NSString *key, NSString *table) {
    
    
    return [liveRoomBundle() localizedStringForKey:key value:@"" table:table];//给文本用的
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

NSString *localizeReplaceThreeCharacter(NSString *origin, NSString *xxx_replace, NSString *yyy_replace, NSString *zzz_replace) {
    if (zzz_replace == nil) { zzz_replace = @"";}
    return [localizeReplace(origin, xxx_replace, yyy_replace) stringByReplacingOccurrencesOfString:@"zzz" withString:zzz_replace];
}

NSString *localizeReplaceFourCharacter(NSString *origin, NSString *xxx_replace, NSString *yyy_replace, NSString *zzz_replace, NSString *mmm_replace) {
    if (mmm_replace == nil) { mmm_replace = @"";}
    return [localizeReplaceThreeCharacter(origin, xxx_replace, yyy_replace, zzz_replace)
 stringByReplacingOccurrencesOfString:@"mmm" withString:mmm_replace];
}

NSString *localizeReplaceFiveCharacter(NSString *origin, NSString *xxx_replace, NSString
 *yyy_replace, NSString *zzz_replace, NSString *mmm_replace, NSString *nnn_replace) {
    if (nnn_replace == nil) { nnn_replace = @"";}
    return [localizeReplaceFourCharacter(origin, xxx_replace, yyy_replace, zzz_replace,
 mmm_replace) stringByReplacingOccurrencesOfString:@"nnn" withString:nnn_replace];
}


#pragma mark - LiveRoom
NSString *const liveRoom_Localize_TableName = @"LiveRoomLocalized";
NSString *liveRoomLocalize(NSString *key) {
    
    return liveRoomLocalizeFromTable(key, liveRoom_Localize_TableName);
    
    
}
