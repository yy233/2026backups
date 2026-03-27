//
//  BaseViewController.h
//  test
//
//  Created by 余莹 on 2020/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
- (void)setupNavigationBarWhiteStyle;
- (void)setupNavigationBarTransparentStyle;
- (void)setupNavigationBarStyleWithMainColor;//更改透明为主题色
- (void)setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw;//0924主题色 深色不变 浅色主题时 nav为白色
- (void)setupNavigationBarStyleWithMainColorWhenWitheNavIsWwBackIsCountViewBackBulue;//主题色 深色=浅蓝内容背景色 浅色主题时 nav为白色

- (void)setupNavigationBarBlackStyle;
- (void)pushVc:(id)vc;
- (void)popVC;

- (void)setupNavigationBarWhiteTextColorWithBackViewCustomColor:(UIColor *)customColor;
 
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomColor:(UIColor *)customColor;//自定色
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomBeginColor:(UIColor *)customBeginColor andBackViewCustomEndColor:(UIColor *)customEndColor andSize:(CGSize)custimSize;
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomImg:(UIImage *)cImg;
- (void)setupsetupNavigationBarWithChatVcStyle;//聊天的nav渐变色
@end

NS_ASSUME_NONNULL_END
