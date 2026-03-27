//
//  ShareLocale.m
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//

#import "ShareLocale.h"

#import "TUIDefine.h" //聊天

#define  kLocale_Type_Key      @"Locale_Type"
#define  kTheme_Type_Key       @"Theme_Type"
#define  kShowLauncVc_TypeKey  @"Have_ShowLauncVc"

@implementation ShareLocale
singleton_implementation(shared)
 
#pragma mark ==== 初始轮播图 只显示一次
- (BOOL)get_Have_ShowLauncVc{
    NSString *now_Have_ShowLauncVc =  [[NSUserDefaults standardUserDefaults] objectForKey:kShowLauncVc_TypeKey];
    if([now_Have_ShowLauncVc isEqualToString:@"1"]){
        return YES;
    }else{
        return NO;
    }

}
- (void)save_Have_ShowLauncVc{
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:kShowLauncVc_TypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark ==== 语言

- (void)getNowLacaleTypeStr{
    [ShareLocale shared].nowLocaleTypeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kLocale_Type_Key];
}


- (void)saveNowLacaleTypeStr:(NSString *)localeType{
    [ShareLocale shared].nowLocaleTypeStr = localeType;
    [[NSUserDefaults standardUserDefaults] setValue:localeType forKey:kLocale_Type_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    DLog(@"saveNowLacaleTypeStr 语言 切换 --- 当前传入的 %@",localeType);
    [self dealChatLange:localeType];
    //刷新控件文本多语言
    [[MJRefreshConfig defaultConfig] setLanguageCode: [ShareLocale shared].nowLocaleTypeStr];
    
}

- (void)dealChatLange:(NSString *)localeType{
    //聊天的语言初始设置 0830
    if([localeType isEqualToString: @"en"] || [localeType isEqualToString:@"zh-Hans"] || [localeType isEqualToString:@"zh-Hant"] || [localeType isEqualToString:@"ja"]){
        [TUIGlobalization setPreferredLanguage:localeType];//聊天的语言
    }else if([localeType containsString: @"ko"]){//韩文
        [TUIGlobalization setPreferredLanguage:@"ko"];
    }else{
        [TUIGlobalization setPreferredLanguage:@"en"];//不是五种语言 切成英文
    }
}

 
#pragma mark ==== 颜色
- (NSString *)getNowThemeTypeStr{//iseq
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type
    if(nowThemeStr.length<=0){//没设置过主题时
        if( [[UITraitCollection currentTraitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark){//系统暗色时
            nowThemeStr = Now_Theme_dark;//黑色模式
        }else if( [[UITraitCollection currentTraitCollection] userInterfaceStyle] ==  UIUserInterfaceStyleLight){//系统暗色时
                nowThemeStr = Now_Theme_light;//白色模式
        }else{//否则
            nowThemeStr = Now_Theme_light;//白色模式

        }
    }
    [ShareLocale shared].nowThemeStr  = nowThemeStr;
    [self dealChatTheme: nowThemeStr];
    return [ShareLocale shared].nowThemeStr;
}

- (void)saveNowThemeTypeStr:(NSString *)localeThemeType{
    [ShareLocale shared].nowThemeStr = localeThemeType;
    [[NSUserDefaults standardUserDefaults] setValue:localeThemeType forKey:kTheme_Type_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    DLog(@"saveNowThemeTypeStr 主题 切换 --- 当前传入的 %@",localeThemeType);
    [self dealChatTheme: localeThemeType];
}


- (void)dealChatTheme:(NSString *)localeThemeType{
//    [TUIGlobalization setPreferredLanguage:localeThemeType];
    
    // 获取 App 上次启动所使用的主题 ID
//      NSString *lastThemeID = [self getCacheThemeID];
      NSString *lastThemeID = @"";
      if (localeThemeType.length) {
          lastThemeID = localeThemeType;
      }


      // 组件: 应用/卸载主题 
      if (lastThemeID == nil || lastThemeID.length == 0 || [lastThemeID isEqualToString:@"system"]) {
          // 主题 ID 为空，或者明确跟随系统，卸载所有组件的主题
          [TUIShareThemeManager unApplyThemeForModule:TUIThemeModuleAll];
      } else {
            // 为所有组件应用主题
          [TUIShareThemeManager applyTheme:lastThemeID forModule:TUIThemeModuleAll];
      }


     /**
      // 系统暗黑样式: 与主题互斥
      dispatch_async(dispatch_get_main_queue(), ^{
          if (@available(iOS 13.0, *)) {
              if (lastThemeID == nil || lastThemeID.length == 0 || [lastThemeID isEqualToString:@"system"]) {
                  // 跟随系统变化
                  UIApplication.sharedApplication.keyWindow.overrideUserInterfaceStyle = 0;
              } else if ([lastThemeID isEqual: Now_Theme_dark]) {
                  // 强制切换成黑夜模式
                  UIApplication.sharedApplication.keyWindow.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
              } else {
                  // 忽略系统变化，强制切换成白天模式，并使用主题
                  UIApplication.sharedApplication.keyWindow.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
              }
          }
      });*/

}




 
@end
