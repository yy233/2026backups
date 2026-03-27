//
//  GHDropMenuHeader.h
//  GHDropMenuDemo
//
//  Created by zhaozhiwei on 2018/12/15.
//  Copyright © 2018年 GHome. All rights reserved.
//  gitHub:https://github.com/shabake/GHDropMenuDemo

#ifndef GHDropMenuHeader_h
#define GHDropMenuHeader_h
#define weakself(self)  __weak __typeof(self) weakSelf = self

// ScreenWidth & kScreenHeight
#define kGHScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kGHScreenHeight [UIScreen mainScreen].bounds.size.height

//#define iPhoneXRAndXSMAX (kGHScreenWidth == 414.f && kGHScreenHeight == 896.f ? YES : NO)
//// iPhoneX
//#define iPhoneXAndXS (kGHScreenWidth == 375.f && kGHScreenHeight == 812.f ? YES : NO)
//#define kGHSafeAreaBottomHeight ((iPhoneXAndXS || iPhoneXRAndXSMAX) ?34 : 0)

#define isIphoneXx \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define kGHSafeAreaBottomHeight (isIphoneXx ? 34.f : 0.f)

// StatusbarH + NavigationH
#define kGHSafeAreaTopHeight (isIphoneXx ? 88.f : 64.f)
// StatusBarHeight
#define kStatusBarHeight (isIphoneXx  ? 44.f : 20.f)
// NavigationBarHeigth
#define kNavBarHeight  ((isIphoneXx) ? 88 : 64)
// TabBarHeight
#define kTabBarHeight  (isIphoneXx ? (49.f+34.f) : 49.f)

// KeyWindow
#define kKeyWindow [UIApplication sharedApplication].keyWindow

// Rete
#define kScreenWidthRete   kScreenWidth / 375.0 //比率
#define kScreenHeightRete  kScreenWidth / 667.0 //比率
// AutoSize
#define kAutoWithSize(r) r*kScreenWidth / 375.0
#define kFont(size) kAutoWithSize(size)

#define kAutoHeightSize(r) r*kScreenHeight / 667.0

#define kFilterButtonHeight 44
#define kFilterButtonWidth 44

#import "UIView+Extension.h"

#endif /* GHDropMenuHeader_h */
