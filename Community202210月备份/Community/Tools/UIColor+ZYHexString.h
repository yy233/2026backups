//
//  UIColor+ZYHexString.h
//  Community
//
//  Created by ZY on 2021/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZYHexString)

// 将十六进制数转化为UIColor
+ (UIColor *)zy_colorWithHexString:(NSString *)hexString;

// 将十六进制数转化为UIColor及透明度
+ (UIColor*)zy_colorWithHexString:(NSString*)hexString andAlpha:(float)alpha;

@end

NS_ASSUME_NONNULL_END
