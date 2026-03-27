//
//  ZYThemeManager.h
//  Community
//
//  Created by ZY on 2021/8/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZYThemeType_White = 0,
    ZYThemeType_Dark = 1
} ZYThemeType;

@interface ZYThemeManager : NSObject
singleton_interface(shareManager)

@property (nonatomic, assign) ZYThemeType themeType;

// view
/// view背景主题色
@property (nonatomic, strong) UIColor *viewBackgroundThemeColor;

/// view背景主题色Lf0f1f6
@property (nonatomic, strong) UIColor *viewBackgroundThemeColor_Lf0f1f6;

/// navigationBar背景主题色
@property (nonatomic, strong) UIColor *navigationBarBackgroundThemeColor;

/// navigationBar背景主题色D001534
@property (nonatomic, strong) UIColor *navigationBarBackgroundThemeColor_D001534;

/// navigationBar背景主题色Lf0f1f6D001534
@property (nonatomic, strong) UIColor *navigationBarBackgroundThemeColor_Lf0f1f6_D001534;

/// navigationBar背景主题色Lf7f7f9D001534
@property (nonatomic, strong) UIColor *navigationBarBackgroundThemeColor_Lf7f7f9_D001534;

/// navigationItem主题色
@property (nonatomic, strong) UIColor *navigationItemThemeColor;

/// 内容视图背景主题色
@property (nonatomic, strong) UIColor *contentViewBackgroundThemeColor;

/// 内容视图背景主题色Lf0f1f6
@property (nonatomic, strong) UIColor *contentViewBackgroundThemeColor_Lf0f1f6;

/// 内容视图背景主题色L2672f9
@property (nonatomic, strong) UIColor *contentViewBackgroundThemeColor_L2672f9;

/// 内容视图背景主题色D001534
@property (nonatomic, strong) UIColor *contentViewBackgroundThemeColor_D001534;

/// 分割线背景主题色
@property (nonatomic, strong) UIColor *separatorLineBackgroundThemeColor;

/// 边框线背景主题色
@property (nonatomic, strong) UIColor *borderLineBackgroundThemeColor;

/// 线条背景主题色
@property (nonatomic, strong) UIColor *lineViewBackgroundThemeColor;


// label
/// 主标题主题色
@property (nonatomic, strong) UIColor *titleThemeColor;

/// 主标题主题色black
@property (nonatomic, strong) UIColor *titleThemeColor_Lblack;

/// 主标题主题色L2672f9
@property (nonatomic, strong) UIColor *titleThemeColor_L2672f9;

/// 主标题主题色L3c496f
@property (nonatomic, strong) UIColor *titleThemeColor_L3c496f;

/// 副标题主题色
@property (nonatomic, strong) UIColor *subTitleThemeColor;

/// 副标题主题色Dc5c9d4
@property (nonatomic, strong) UIColor *subTitleThemeColor_Dc5c9d4;

/// 副标题主题色D949daa
@property (nonatomic, strong) UIColor *subTitleThemeColor_D949daa;

/// 三级标题主题色
@property (nonatomic, strong) UIColor *threeLevelTitleThemeColor;

/// 三级标题主题色Dc5c9d4
@property (nonatomic, strong) UIColor *threeLevelTitleThemeColor_Dc5c9d4;

/// 文本提示色
@property (nonatomic, strong) UIColor *placeholderThemeColor;


/// border主题色
@property (nonatomic, strong) UIColor *borderThemeColor;

// 渐变主题色
/// 签章底部按钮渐变色
- (UIColor *)electronicBottomGradientColorWithSize:(CGSize)size;


// image
/// 主题图片
- (UIImage *)themeImageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
