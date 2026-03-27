//
//  UIColor+ZYHexString.m
//  Community
//
//  Created by ZY on 2021/8/18.
//

#import "UIColor+ZYHexString.h"

@implementation UIColor (ZYHexString)

#pragma mark - Public
+ (UIColor *)zy_colorWithHexString:(NSString *)hexString {
    
    return [UIColor zy_colorWithHexString:hexString andAlpha:1.0];
}

+ (UIColor*)zy_colorWithHexString:(NSString*)hexString andAlpha:(float)alpha {
    UIColor *color;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    uint hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        color = [UIColor colorWithHex:hexValue alpha:alpha];
    } else {
        color = [UIColor blackColor];
    }
    
    return color;
}

#pragma mark - Private
// 根据NSInteger获取颜色值
+ (UIColor *)colorWithHex:(NSInteger)hexValue {
    
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

@end
