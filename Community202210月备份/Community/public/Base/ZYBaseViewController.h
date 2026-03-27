//
//  ZYBaseViewController.h
//  Community
//
//  Created by ZY on 2021/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYBaseViewController : UIViewController

/// navigationBar主题色
- (void)setupNavigationBarStyleWithThemeColor;

/// 改变navigationBar主题色
- (void)navigationBarStyleWithThemeColorChanged:(UIColor *)color;

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
