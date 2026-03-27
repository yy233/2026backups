//
//  ZYPensionBaseVC.h
//  Community
//
//  Created by ZY on 2021/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYPensionBaseVC : UIViewController

/// navigationBar默认背景色
- (void)setupNavigationBarStyleWithColor;

/// SOS navigationBar的颜色
- (void)setupNavigationBarStyleWithSOSColor;

/// SOS navigationBar的颜色 大字体
- (void)setupNavigationBarStyleWithSOSBoldTextColor;

/// 改变浅色navigationBar背景色
- (void)navigationBarWhiteStyleWithColorChanged:(UIColor *)color;

/// 改变深色navigationBar背景色
- (void)navigationBarDarkStyleWithColorChanged:(UIColor *)color;

/// 设置navigationBar为透明色
- (void)setupNavigationBarTransparentStyle;

/// 清除navigationBar的颜色
- (void)setupNavigationBarClearTransparentStyle;

/// 隐藏navigationBar
- (void)hiddenNavigationBar;
//
- (void)notHiddenNavigationBar;

- (void)pushVc:(id)vc;

- (void)popVc:(id)vc;

- (void)popVC;

@end

NS_ASSUME_NONNULL_END
