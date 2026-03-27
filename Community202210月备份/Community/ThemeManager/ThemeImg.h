//
//  ThemeImg.h
//  Community
//
//  Created by 余莹 on 2020/11/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThemeImg : NSObject

+ (UIImage *)themeImageWithBaseName:(NSString *)imgNameStr;
+ (UIImage *)loginModuleThemeImageWithBaseName:(NSString *)imgNameStr;
+ (UIImage *)mainModulethemeImageWithBaseName:(NSString *)imgNameStr;

@end

NS_ASSUME_NONNULL_END
