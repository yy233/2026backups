//
//  localeTool.h
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//

#import <Foundation/Foundation.h>
 

//（英，日，韩，简中，繁中）
typedef  NSString * Now_Locale_Type NS_STRING_ENUM;
FOUNDATION_EXPORT   Now_Locale_Type const Now_Locale_Type_en;
FOUNDATION_EXPORT   Now_Locale_Type const Now_Locale_Type_ja;
//FOUNDATION_EXPORT   Now_Locale_Type const Now_Locale_Type_korean;
FOUNDATION_EXPORT   Now_Locale_Type const Now_Locale_Type_ko;
FOUNDATION_EXPORT   Now_Locale_Type const Now_Locale_Type_zhHans;
FOUNDATION_EXPORT   Now_Locale_Type const Now_Locale_Type_zhHant;


typedef  NSString *Now_Theme NS_STRING_ENUM;
FOUNDATION_EXPORT   Now_Theme const Now_Theme_light;
FOUNDATION_EXPORT   Now_Theme const Now_Theme_dark;

NS_ASSUME_NONNULL_BEGIN

@interface localeTool : NSObject



@end

NS_ASSUME_NONNULL_END
