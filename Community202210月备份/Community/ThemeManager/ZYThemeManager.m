//
//  ZYThemeManager.m
//  Community
//
//  Created by ZY on 2021/8/17.
//

#import "ZYThemeManager.h"

@implementation ZYThemeManager
singleton_implementation(shareManager)

#pragma mark - view
- (UIColor *)viewBackgroundThemeColor {
    if (!_viewBackgroundThemeColor) {
        _viewBackgroundThemeColor = [UIColor whiteColor];
    }
    if (self.themeType == ZYThemeType_White) {
        _viewBackgroundThemeColor = [UIColor whiteColor];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _viewBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#001534"];
    }
    
    return _viewBackgroundThemeColor;
}

- (UIColor *)viewBackgroundThemeColor_Lf0f1f6 {
    if (!_viewBackgroundThemeColor_Lf0f1f6) {
        _viewBackgroundThemeColor_Lf0f1f6 = [UIColor zy_colorWithHexString:@"#f0f1f6"];
    }
    if (self.themeType == ZYThemeType_White) {
        _viewBackgroundThemeColor_Lf0f1f6 = [UIColor zy_colorWithHexString:@"#f0f1f6"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _viewBackgroundThemeColor_Lf0f1f6 = [UIColor zy_colorWithHexString:@"#001534"];
    }
    
    return _viewBackgroundThemeColor_Lf0f1f6;
}

- (UIColor *)navigationBarBackgroundThemeColor {
    if (!_navigationBarBackgroundThemeColor) {
        _navigationBarBackgroundThemeColor = [UIColor whiteColor];
    }
    if (self.themeType == ZYThemeType_White) {
        _navigationBarBackgroundThemeColor = [UIColor whiteColor];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _navigationBarBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#112957"];
    }
    
    return _navigationBarBackgroundThemeColor;
}

- (UIColor *)navigationBarBackgroundThemeColor_D001534 {
    if (!_navigationBarBackgroundThemeColor_D001534) {
        _navigationBarBackgroundThemeColor_D001534 = [UIColor whiteColor];
    }
    if (self.themeType == ZYThemeType_White) {
        _navigationBarBackgroundThemeColor_D001534 =  [UIColor whiteColor];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _navigationBarBackgroundThemeColor_D001534 = [UIColor zy_colorWithHexString:@"#001534"];
    }
    
    return _navigationBarBackgroundThemeColor_D001534;
}

- (UIColor *)navigationBarBackgroundThemeColor_Lf0f1f6_D001534 {
    if (!_navigationBarBackgroundThemeColor_Lf0f1f6_D001534) {
        _navigationBarBackgroundThemeColor_Lf0f1f6_D001534 = [UIColor zy_colorWithHexString:@"#f0f1f6"];
    }
    if (self.themeType == ZYThemeType_White) {
        _navigationBarBackgroundThemeColor_Lf0f1f6_D001534 =  [UIColor zy_colorWithHexString:@"#f0f1f6"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _navigationBarBackgroundThemeColor_Lf0f1f6_D001534 = [UIColor zy_colorWithHexString:@"#001534"];
    }
    
    return _navigationBarBackgroundThemeColor_Lf0f1f6_D001534;
}

- (UIColor *)navigationBarBackgroundThemeColor_Lf7f7f9_D001534 {
    if (!_navigationBarBackgroundThemeColor_Lf0f1f6_D001534) {
        _navigationBarBackgroundThemeColor_Lf0f1f6_D001534 = [UIColor zy_colorWithHexString:@"#F7F7F9"];
    }
    if (self.themeType == ZYThemeType_White) {
        _navigationBarBackgroundThemeColor_Lf0f1f6_D001534 =  [UIColor zy_colorWithHexString:@"#F7F7F9"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _navigationBarBackgroundThemeColor_Lf0f1f6_D001534 = [UIColor zy_colorWithHexString:@"#001534"];
    }
    
    return _navigationBarBackgroundThemeColor_Lf0f1f6_D001534;
}

- (UIColor *)navigationItemThemeColor {
    if (!_navigationItemThemeColor) {
        _navigationItemThemeColor = [UIColor blackColor];
    }
    if (self.themeType == ZYThemeType_White) {
        _navigationItemThemeColor = [UIColor blackColor];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _navigationItemThemeColor = [UIColor whiteColor];
    }
    
    return _navigationItemThemeColor;
}

- (UIColor *)contentViewBackgroundThemeColor {
    if (!_contentViewBackgroundThemeColor) {
        _contentViewBackgroundThemeColor = [UIColor whiteColor];
    }
    if (self.themeType == ZYThemeType_White) {
        _contentViewBackgroundThemeColor = [UIColor whiteColor];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _contentViewBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#112957"];
    }
    
    return _contentViewBackgroundThemeColor;
}

- (UIColor *)contentViewBackgroundThemeColor_Lf0f1f6 {
    if (!_contentViewBackgroundThemeColor_Lf0f1f6) {
        _contentViewBackgroundThemeColor_Lf0f1f6 = [UIColor zy_colorWithHexString:@"#f0f1f6"];
    }
    if (self.themeType == ZYThemeType_White) {
        _contentViewBackgroundThemeColor_Lf0f1f6 = [UIColor zy_colorWithHexString:@"#f0f1f6"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _contentViewBackgroundThemeColor_Lf0f1f6 = [UIColor zy_colorWithHexString:@"#112957"];
    }
    
    return _contentViewBackgroundThemeColor_Lf0f1f6;
}

- (UIColor *)contentViewBackgroundThemeColor_L2672f9 {
    if (!_contentViewBackgroundThemeColor_L2672f9) {
        _contentViewBackgroundThemeColor_L2672f9 = [UIColor zy_colorWithHexString:@"#2672f9"];
    }
    if (self.themeType == ZYThemeType_White) {
        _contentViewBackgroundThemeColor_L2672f9 = [UIColor zy_colorWithHexString:@"#2672f9"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _contentViewBackgroundThemeColor_L2672f9 = [UIColor zy_colorWithHexString:@"#112957"];
    }
    
    return _contentViewBackgroundThemeColor_L2672f9;
}

- (UIColor *)contentViewBackgroundThemeColor_D001534 {
    if (!_contentViewBackgroundThemeColor_D001534) {
        _contentViewBackgroundThemeColor_D001534 = [UIColor whiteColor];
    }
    if (self.themeType == ZYThemeType_White) {
        _contentViewBackgroundThemeColor_D001534 = [UIColor whiteColor];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _contentViewBackgroundThemeColor_D001534 = [UIColor zy_colorWithHexString:@"#001534"];
    }
    
    return _contentViewBackgroundThemeColor_D001534;
}

- (UIColor *)separatorLineBackgroundThemeColor {
    if (!_separatorLineBackgroundThemeColor) {
        _separatorLineBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#C5C9D4" andAlpha:0.5];
    }
    if (self.themeType == ZYThemeType_White) {
        _separatorLineBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#C5C9D4" andAlpha:0.5];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _separatorLineBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#3E5177" andAlpha:0.5];
    }
    
    return _separatorLineBackgroundThemeColor;
}

- (UIColor *)borderLineBackgroundThemeColor {
    if (!_borderLineBackgroundThemeColor) {
        _borderLineBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#c5c9d4"];
    }
    if (self.themeType == ZYThemeType_White) {
        _borderLineBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#c5c9d4"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _borderLineBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#3E5177"];
    }
    
    return _borderLineBackgroundThemeColor;
}

- (UIColor *)lineViewBackgroundThemeColor {
    if (!_lineViewBackgroundThemeColor) {
        _lineViewBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#c5c9d4"];
    }
    if (self.themeType == ZYThemeType_White) {
        _lineViewBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#c5c9d4"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _lineViewBackgroundThemeColor = [UIColor zy_colorWithHexString:@"#0f387f"];
    }
    
    return _lineViewBackgroundThemeColor;
}

#pragma mark - label
- (UIColor *)titleThemeColor {
    if (!_titleThemeColor) {
        _titleThemeColor = [UIColor zy_colorWithHexString:@"#2b2c2f"];
    }
    if (self.themeType == ZYThemeType_White) {
        _titleThemeColor = [UIColor zy_colorWithHexString:@"#2b2c2f"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _titleThemeColor = [UIColor whiteColor];
    }
    
    return _titleThemeColor;
}

- (UIColor *)titleThemeColor_Lblack {
    if (!_titleThemeColor_Lblack) {
        _titleThemeColor_Lblack = [UIColor blackColor];
    }
    if (self.themeType == ZYThemeType_White) {
        _titleThemeColor_Lblack = [UIColor blackColor];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _titleThemeColor_Lblack = [UIColor whiteColor];
    }
    
    return _titleThemeColor_Lblack;
}

- (UIColor *)titleThemeColor_L2672f9 {
    if (!_titleThemeColor_L2672f9) {
        _titleThemeColor_L2672f9 = [UIColor zy_colorWithHexString:@"#2672f9"];
    }
    if (self.themeType == ZYThemeType_White) {
        _titleThemeColor_L2672f9 = [UIColor zy_colorWithHexString:@"#2672f9"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _titleThemeColor_L2672f9 = [UIColor whiteColor];
    }
    
    return _titleThemeColor_L2672f9;
}

- (UIColor *)titleThemeColor_L3c496f {
    if (!_titleThemeColor_L3c496f) {
        _titleThemeColor_L3c496f = [UIColor zy_colorWithHexString:@"#3c496f"];
    }
    if (self.themeType == ZYThemeType_White) {
        _titleThemeColor_L3c496f = [UIColor zy_colorWithHexString:@"#3c496f"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _titleThemeColor_L3c496f = [UIColor whiteColor];
    }
    
    return _titleThemeColor_L3c496f;
}

- (UIColor *)subTitleThemeColor {
    if (!_subTitleThemeColor) {
        _subTitleThemeColor = [UIColor zy_colorWithHexString:@"#6e727d"];
    }
    if (self.themeType == ZYThemeType_White) {
        _subTitleThemeColor =  [UIColor zy_colorWithHexString:@"#6e727d"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _subTitleThemeColor = [UIColor whiteColor];
    }
    
    return _subTitleThemeColor;
}

- (UIColor *)subTitleThemeColor_Dc5c9d4 {
    if (!_subTitleThemeColor_Dc5c9d4) {
        _subTitleThemeColor_Dc5c9d4 = [UIColor zy_colorWithHexString:@"#6e727d"];
    }
    if (self.themeType == ZYThemeType_White) {
        _subTitleThemeColor_Dc5c9d4 = [UIColor zy_colorWithHexString:@"#6e727d"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _subTitleThemeColor_Dc5c9d4 = [UIColor zy_colorWithHexString:@"#c5c9d4"];
    }
    
    return _subTitleThemeColor_Dc5c9d4;
}

- (UIColor *)subTitleThemeColor_D949daa {
    if (!_subTitleThemeColor_D949daa) {
        _subTitleThemeColor_D949daa = [UIColor zy_colorWithHexString:@"#6e727d"];
    }
    if (self.themeType == ZYThemeType_White) {
        _subTitleThemeColor_D949daa = [UIColor zy_colorWithHexString:@"#6e727d"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _subTitleThemeColor_D949daa = [UIColor zy_colorWithHexString:@"#949daa"];
    }
    
    return _subTitleThemeColor_D949daa;
}

- (UIColor *)threeLevelTitleThemeColor {
    if (!_threeLevelTitleThemeColor) {
        _threeLevelTitleThemeColor = [UIColor zy_colorWithHexString:@"#aaaeb9"];
    }
    if (self.themeType == ZYThemeType_White) {
        _threeLevelTitleThemeColor = [UIColor zy_colorWithHexString:@"#aaaeb9"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _threeLevelTitleThemeColor = [UIColor whiteColor];
    }
    
    return _threeLevelTitleThemeColor;
}

- (UIColor *)threeLevelTitleThemeColor_Dc5c9d4 {
    if (!_threeLevelTitleThemeColor_Dc5c9d4) {
        _threeLevelTitleThemeColor_Dc5c9d4 = [UIColor zy_colorWithHexString:@"#aaaeb9"];
    }
    if (self.themeType == ZYThemeType_White) {
        _threeLevelTitleThemeColor_Dc5c9d4 = [UIColor zy_colorWithHexString:@"#aaaeb9"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _threeLevelTitleThemeColor_Dc5c9d4 = [UIColor zy_colorWithHexString:@"#c5c9d4"];
    }
    
    return _threeLevelTitleThemeColor_Dc5c9d4;
}

- (UIColor *)placeholderThemeColor {
    if (!_placeholderThemeColor) {
        _placeholderThemeColor = [UIColor zy_colorWithHexString:@"#999999"];
    }
    if (self.themeType == ZYThemeType_White) {
        _placeholderThemeColor = [UIColor zy_colorWithHexString:@"#999999"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _placeholderThemeColor = [UIColor zy_colorWithHexString:@"#949daa"];
    }
    
    return _placeholderThemeColor;
}

#pragma mark - borderThemeColor
- (UIColor *)borderThemeColor {
    if (!_borderThemeColor) {
        _borderThemeColor = [UIColor zy_colorWithHexString:@"#c5c9d4"];
    }
    if (self.themeType == ZYThemeType_White) {
        _borderThemeColor = [UIColor zy_colorWithHexString:@"#c5c9d4"];
    }
    if (self.themeType == ZYThemeType_Dark) {
        _borderThemeColor = [UIColor zy_colorWithHexString:@"#667385"];
    }
    
    return _borderThemeColor;
}

#pragma mark - 签章底部按钮渐变色
- (UIColor *)electronicBottomGradientColorWithSize:(CGSize)size {
    
    return [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionLevel startColor:Y_RGBA(60, 156, 255, 1) endColor:Y_RGBA(37, 95, 255, 1)];
}

#pragma mark - image
- (UIImage *)themeImageNamed:(NSString *)name {
    
    UIImage *image = [UIImage imageNamed:name];
    if (self.themeType == ZYThemeType_White) {
        image = [UIImage imageNamed:name];
    }
    if (self.themeType == ZYThemeType_Dark) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Dark", name]];
        if (isNil(image)) {
            image = [UIImage imageNamed:name];
        }
    }
    
    return image;
}

@end
