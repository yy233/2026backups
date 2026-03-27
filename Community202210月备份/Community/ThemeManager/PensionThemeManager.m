//
//  PensionThemeManage.m
//  Community
//
//  Created by 余莹 on 2021/11/3.
//

#import "PensionThemeManager.h"

@implementation PensionThemeManager
singleton_implementation(shareManager)

#pragma mark == 彩色
//Pension_OrangeColor//#FFA82B
- (UIColor *)Pension_OrangeColor{
    if (!_Pension_OrangeColor) {
        _Pension_OrangeColor = Y_ColorWith16FromRGB(0xFFA82B);
    }
    return _Pension_OrangeColor;
}
//Pension_RedColor;//#FF7E6E
- (UIColor *)Pension_RedColor{
    if (!_Pension_RedColor) {
        _Pension_RedColor = Y_ColorWith16FromRGB(0xFF7E6E);
    }
    return _Pension_RedColor;
}
//Pension_BlueColor;//#539CFC
- (UIColor *)Pension_BlueColor{
    if (!_Pension_BlueColor) {
        _Pension_BlueColor = Y_ColorWith16FromRGB(0x539CFC);
    }
    return _Pension_BlueColor;
}
//Pension_Gray197Color;//#C5C5C5
- (UIColor *)Pension_Gray197Color{
    if (!_Pension_Gray197Color) {
        _Pension_Gray197Color = Y_ColorWith16FromRGB(0xC5C5C5);
    }
    return _Pension_Gray197Color;
}
#pragma mark == 绿色总
//绿色总
//Pension_NavGreenBackGroundColor;//nav绿色背景色 #36C8C1
- (UIColor *)Pension_NavGreenBackGroundColor{
    if (!_Pension_NavGreenBackGroundColor) {
        _Pension_NavGreenBackGroundColor = Y_ColorWith16FromRGB(0x36C8C1);
    }
    return _Pension_NavGreenBackGroundColor;
}
//Pension_SubMainGreenColor;//#38C1BA
- (UIColor *)Pension_SubMainGreenColor{
    if (!_Pension_SubMainGreenColor) {
        _Pension_SubMainGreenColor =  Y_ColorWith16FromRGB(0x38C1BA);
    }
    return _Pension_SubMainGreenColor;
}
//Pension_GradualGreen_DrayGreenColor;//#38C1BA
- (UIColor *)Pension_GradualGreen_DrayGreenColor{
    if (!_Pension_GradualGreen_DrayGreenColor) {
        _Pension_GradualGreen_DrayGreenColor = Y_ColorWith16FromRGB(0x38C1BA);
    }
    return _Pension_GradualGreen_DrayGreenColor;
}
//Pension_GradualGreen_LightGreenColor;//#2CE7BD
- (UIColor *)Pension_GradualGreen_LightGreenColor{
    if (!_Pension_GradualGreen_LightGreenColor) {
        _Pension_GradualGreen_LightGreenColor = Y_ColorWith16FromRGB(0x2CE7BD);
    }
    return _Pension_GradualGreen_LightGreenColor;
}
#pragma mark == 文本相关色
//文本相关色  __________ 黑色灰色
//Pension_TextMainColor;//#2B2C2F
- (UIColor *)Pension_TextMainColor{
    if (!_Pension_TextMainColor) {
        _Pension_TextMainColor = Y_ColorWith16FromRGB(0x2B2C2F);
    }
    return _Pension_TextMainColor;
}


//Pension_TextSubMainColor;//#6E727D
- (UIColor *)Pension_TextSubMainColor{
    if (!_Pension_TextSubMainColor) {
        _Pension_TextSubMainColor = Y_ColorWith16FromRGB(0x6E727D);
    }
    return _Pension_TextSubMainColor;
}

//Pension_TextGray170Color;//#AAAEB9
- (UIColor *)Pension_TextGray170Color{
    if (!_Pension_TextGray170Color) {
        _Pension_TextGray170Color = Y_ColorWith16FromRGB(0xAAAEB9);
    }
    return _Pension_TextGray170Color;
}
#pragma mark == 背景 相关色
//Pension_LineColor;//#C5C9D4
- (UIColor *)Pension_LineColor{
    if (!_Pension_LineColor) {
        _Pension_LineColor = Y_ColorWith16FromRGB(0xC5C9D4);
    }
    return _Pension_LineColor;
}


//Pension_LightGrayBackGroundColor;//#F0F1F6
- (UIColor *)Pension_LightGrayBackGroundColor{
    if (_Pension_LightGrayBackGroundColor) {
        _Pension_LightGrayBackGroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
    }
    return _Pension_LightGrayBackGroundColor;
}

#pragma mark ==
//字体大小 养老医疗暂不确定大小是否更改

- (UIFont *)Pension_TextFont_18{
    if (!_Pension_TextFont_18) {
        _Pension_TextFont_18 = [UIFont systemFontOfSize:18];
    }
    return _Pension_TextFont_18;
}
- (UIFont *)Pension_TextFont_B15{
    if (!_Pension_TextFont_B15) {
        _Pension_TextFont_B15 = [UIFont boldSystemFontOfSize:15];
    }
    return _Pension_TextFont_B15;
}
- (UIFont *)Pension_TextFont_15{
    if (!_Pension_TextFont_15) {
        _Pension_TextFont_15 = [UIFont systemFontOfSize:15];
    }
    return _Pension_TextFont_15;
}
- (UIFont *)Pension_TextFont_B14{
    if (!_Pension_TextFont_B14) {
        _Pension_TextFont_B14 = [UIFont boldSystemFontOfSize:14];
    }
    return _Pension_TextFont_B14;
}
- (UIFont *)Pension_TextFont_14{
    if (!_Pension_TextFont_14) {
        _Pension_TextFont_14 = [UIFont systemFontOfSize:14];
    }
    return _Pension_TextFont_14;
}
- (UIFont *)Pension_TextFont_B13{
    if (!_Pension_TextFont_B13) { 
        _Pension_TextFont_B13 = [UIFont boldSystemFontOfSize:13];
    }
    return _Pension_TextFont_B13;
}
- (UIFont *)Pension_TextFont_13{
    if (!_Pension_TextFont_13) {
        _Pension_TextFont_13 = [UIFont boldSystemFontOfSize:13];
    }
    return _Pension_TextFont_13;
}
- (UIFont *)Pension_TextFont_12{
    if (!_Pension_TextFont_12) {
        _Pension_TextFont_12 = [UIFont systemFontOfSize:12];
    }
    return _Pension_TextFont_12;
}
- (UIFont *)Pension_TextFont_11{
    if (!_Pension_TextFont_11) {
        _Pension_TextFont_11 = [UIFont systemFontOfSize:11];
    }
    return _Pension_TextFont_11;
}

@end
