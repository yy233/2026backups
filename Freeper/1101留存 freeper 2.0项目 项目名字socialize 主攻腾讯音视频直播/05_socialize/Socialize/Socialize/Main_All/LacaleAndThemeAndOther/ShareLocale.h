//
//  ShareLocale.h
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//

#import <Foundation/Foundation.h>
#import "MethodsHeader.h"




NS_ASSUME_NONNULL_BEGIN

@interface ShareLocale : NSObject<NSCopying,NSMutableCopying>
singleton_interface(shared);

@property (nonatomic,copy) NSString *nowLocaleTypeStr;
@property (nonatomic,copy) NSString *nowThemeStr;


#pragma mark ==== 初始轮播图 只显示一次
- (BOOL)get_Have_ShowLauncVc;
- (void)save_Have_ShowLauncVc;

- (void)saveNowLacaleTypeStr:(NSString *)localeType;
- (void)getNowLacaleTypeStr;


- (void)saveNowThemeTypeStr:(NSString *)localeThemeType;
- (NSString *)getNowThemeTypeStr;

@end

NS_ASSUME_NONNULL_END





/**
 
 //（英，日，韩，简中，繁中）
 typedef enum : NSUInteger {
     Now_Locale_Type_en,
     Now_Locale_Type_korean,  Now_Locale_Type_ko
     Now_Locale_Type_zhHans,
     Now_Locale_Type_zhHant,
 } Now_Locale_Type;
 
 
 
 extern const struct Now_Locale_Type
 {
     __unsafe_unretained NSString *en;
     __unsafe_unretained NSString *korean;
     __unsafe_unretained NSString *zhHans;
     __unsafe_unretained NSString *zhHant;
     
 } AMPlayerState;

 const struct Now_Locale_Type AMPlayerState =
 {
     .en = @"en",
     .korean = @"korean",
     .zhHans = @"zhHans",
     .zhHant = @"zhHant",
 };

 
 //-----
 
 // 使用NS_STRING_ENUM宏，定义了一个枚举类型
 typedef NSString * NSKeyValueChangeKey NS_STRING_ENUM;

 FOUNDATION_EXPORT NSKeyValueChangeKey const NSKeyValueChangeKindKey;
 FOUNDATION_EXPORT NSKeyValueChangeKey const NSKeyValueChangeNewKey;
 FOUNDATION_EXPORT NSKeyValueChangeKey const NSKeyValueChangeOldKey;
 FOUNDATION_EXPORT NSKeyValueChangeKey const NSKeyValueChangeIndexesKey;
 FOUNDATION_EXPORT NSKeyValueChangeKey const NSKeyValueChangeNotificationIsPriorKey;
 
 */
