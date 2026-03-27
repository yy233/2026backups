//
//  SwiftLanguageDealStrHeader.m
//  Socialize
//
//  Created by 余莹 on 2023/8/3.
//

#import "SwiftLanguageDealStrHeader.h"

@implementation SwiftLanguageDealStrHeader

NSString *mainSwiftUseLanguageStr(NSString *key){

 
    NSString *nowLangeStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Locale_Type"]];
    NSString *nowLanglprojFailBundlePathStr = [[NSBundle mainBundle] pathForResource:nowLangeStr  ofType:@"lproj"];
    NSBundle *nowLanglprojFailBundle = [NSBundle bundleWithPath: nowLanglprojFailBundlePathStr];
    NSString *getStr = [nowLanglprojFailBundle  localizedStringForKey:key value:@"" table:@"Locale_Type"];

    return getStr;
}

 
 /**
  
  用文件名的
  NSString *a = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Locale_Type"]];
  NSString *b = [[NSBundle mainBundle] pathForResource:a  ofType:@"lproj"];
  NSBundle *ccc = [NSBundle bundleWithPath:b];
  NSString *dd = [ccc  localizedStringForKey:@"完成" value:@"" table:@"Locale_Type"];
  DLog(@"a=  %@ \n b =  %@ \n c =  %@ \n  d = %@ ",a,b,ccc,dd);
  

  
  a=  zh-Hant
  b =  /private/var/containers/Bundle/Application/7ECE0CB7-7CC9-44D6-9AC1-EED7631EEE41/Socialize.app/zh-Hant.lproj
 c =  NSBundle </var/containers/Bundle/Application/7ECE0CB7-7CC9-44D6-9AC1-EED7631EEE41/Socialize.app/zh-Hant.lproj> (not yet loaded)
  d = 完成繁体
  
  a-d。a当前语言- b获取lproj文件路径，c路径bundle d用Locale_Type名字去拿对应数据
 
 

  \ 以下这种取不到正确值
  
  //\Bundle.main.localizedString(forKey: "完成", value: nil, table: "Locale_Type")
  NSBundle *x = [NSBundle mainBundle];
  if (@available(iOS 15.0, *)) {
      NSAttributedString *y = [x localizedAttributedStringForKey:@"完成" value:nil table:@"Locale_Type.zh-Hant"];
      NSLog(@"x %@, y %@",x,y);
  } else {
      // Fallback on earlier versions
      NSLog(@"x %@",x);
  }
  
  x TUIBundle </private/var/containers/Bundle/Application/7ECE0CB7-7CC9-44D6-9AC1-EED7631EEE41/Socialize.app> (loaded)
  y 完成{
  NSLanguage = "zh-Hans";
  
  (lldb) po x.bundlePath
  /private/var/containers/Bundle/Application/7ECE0CB7-7CC9-44D6-9AC1-EED7631EEE41/Socialize.app

  (lldb) po x.resourcePath
  /private/var/containers/Bundle/Application/7ECE0CB7-7CC9-44D6-9AC1-EED7631EEE41/Socialize.app

  (lldb) po x.resourceURL
  file:///private/var/containers/Bundle/Application/7ECE0CB7-7CC9-44D6-9AC1-EED7631EEE41/Socialize.app/
  
  
  */

/**  另一种 用url的
 
 NSURL *voiceRoomKitBundleURL = [[NSBundle mainBundle] URLForResource:@"TUIVoiceRoomKitBundle" withExtension:@"bundle"];
 NSBundle*bu = [NSBundle bundleWithURL:voiceRoomKitBundleURL];
 getStr  = [bu localizedStringForKey:key value:@"" table:@"VoiceRoomLocalized"];
 
 */


@end
