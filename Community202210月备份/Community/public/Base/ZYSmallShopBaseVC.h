//
//  ZYSmallShopBaseVC.h
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopBaseVC : UIViewController

/// navigationBar默认背景色(浅色)
- (void)setupNavigationBarStyleWithColor;

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

- (void)pushVc:(id)vc;

- (void)popVc:(id)vc;

- (void)popVC;

@end

NS_ASSUME_NONNULL_END
