//
//  MedicalCareThemeManager.m
//  Community
//
//  Created by 余莹 on 2021/11/3.
//

#import "MedicalCareThemeManager.h"

@implementation MedicalCareThemeManager
singleton_implementation(shareManager)

//Medical_GreenColor;//#12C797
- (UIColor *)Medical_GreenColor{
    if (!_Medical_GreenColor) {
        _Medical_GreenColor = Y_ColorWith16FromRGB(0x12C797);
    }
    return _Medical_GreenColor;
}
//Medical_OrangeColor;//#FFA82B
- (UIColor *)Medical_OrangeColor{
    if (!_Medical_OrangeColor) {
        _Medical_OrangeColor = Y_ColorWith16FromRGB(0xFFA82B);
    }
    return _Medical_OrangeColor;
}
//Medical_BlueColor;//#1EABFA
- (UIColor *)Medical_BlueColor{
    if (!_Medical_BlueColor) {
        _Medical_BlueColor = Y_ColorWith16FromRGB(0x1EABFA);
    }
    return _Medical_BlueColor;
}
//Medical_PurpleColor;//#811FFF
- (UIColor *)Medical_PurpleColor{
    if (!_Medical_PurpleColor) {
        _Medical_PurpleColor = Y_ColorWith16FromRGB(0x811FFF);
    }
    return _Medical_PurpleColor;
}
//Medical_RedColor;//#FF7E6E
- (UIColor *)Medical_RedColor{
    if (!_Medical_RedColor) {
        _Medical_RedColor = Y_ColorWith16FromRGB(0xFF7E6E);
    }
    return _Medical_RedColor;
}

#pragma mark ===
#pragma mark == 文本相关色
//文本相关色  __________ 黑色灰色
//Pension_TextMainColor;//#2B2C2F
- (UIColor *)Medical_TextMainColor{
    if (!_Medical_TextMainColor) {
        _Medical_TextMainColor = Y_ColorWith16FromRGB(0x2B2C2F);
    }
    return _Medical_TextMainColor;
}


//Pension_TextSubMainColor;//#6E727D
- (UIColor *)Medical_TextSubMainColor{
    if (!_Medical_TextSubMainColor) {
        _Medical_TextSubMainColor = Y_ColorWith16FromRGB(0x6E727D);
    }
    return _Medical_TextSubMainColor;
}

//Pension_TextGray170Color;//#AAAEB9
- (UIColor *)Medical_TextGray170Color{
    if (!_Medical_TextGray170Color) {
        _Medical_TextGray170Color = Y_ColorWith16FromRGB(0xAAAEB9);
    }
    return _Medical_TextGray170Color;
}
#pragma mark == 背景 相关色
//Pension_LineColor;//#C5C9D4
- (UIColor *)Medical_LineColor{
    if (!_Medical_LineColor) {
        _Medical_LineColor = Y_ColorWith16FromRGB(0xC5C9D4);
    }
    return _Medical_LineColor;
}


//Pension_LightGrayBackGroundColor;//#F0F1F6
- (UIColor *)Medical_LightGrayBackGroundColor{
    if (_Medical_LightGrayBackGroundColor) {
        _Medical_LightGrayBackGroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
    }
    return _Medical_LightGrayBackGroundColor;
}

#pragma mark ==== 字体大小
- (UIFont *)Medical_TextFont_18{
    if (!_Medical_TextFont_18) {
        _Medical_TextFont_18 = [UIFont systemFontOfSize:18];
    }
    return _Medical_TextFont_18;
}
- (UIFont *)Medical_TextFont_B15{
    if (!_Medical_TextFont_B15) {
        _Medical_TextFont_B15 = [UIFont boldSystemFontOfSize:15];
    }
    return _Medical_TextFont_B15;
}
- (UIFont *)Medical_TextFont_15{
    if (!_Medical_TextFont_15) {
        _Medical_TextFont_15 = [UIFont systemFontOfSize:15];
    }
    return _Medical_TextFont_15;
}
- (UIFont *)Medical_TextFont_B14{
    if (!_Medical_TextFont_B14) {
        _Medical_TextFont_B14 = [UIFont boldSystemFontOfSize:14];
    }
    return _Medical_TextFont_B14;
}
- (UIFont *)Medical_TextFont_14{
    if (!_Medical_TextFont_14) {
        _Medical_TextFont_14 = [UIFont systemFontOfSize:14];
    }
    return _Medical_TextFont_14;
}
- (UIFont *)Medical_TextFont_12{
    if (!_Medical_TextFont_12) {
        _Medical_TextFont_12 = [UIFont systemFontOfSize:12];
    }
    return _Medical_TextFont_12;
}
- (UIFont *)Medical_TextFont_11{
    if (!_Medical_TextFont_11) {
        _Medical_TextFont_11 = [UIFont systemFontOfSize:11];
    }
    return _Medical_TextFont_11;
}

@end
