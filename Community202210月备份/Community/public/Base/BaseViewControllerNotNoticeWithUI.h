//
//  BaseViewControllerNotNoticeWithUI.h
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewControllerNotNoticeWithUI : UIViewController
- (void)setupNavigationBarWithBackItemHaveTitleWithStr:(NSString *)titleStr;
- (void)setupNavigationBarWithBackItemNoTitle;
- (void)setupNavigationBarWhiteStyle;
- (void)setupNavigationBarTransparentStyle;
- (void)setupNavigationBarClearTransparentStyle;
- (void)setupNavigationBarStyleWithMainColor;//更改透明为主题色
- (void)setupNavigationBarBlackStyle;
- (void)setupNavigationBarWhiteTextColorWithBackViewCustomColor:(UIColor *)customColor;//自定义背景色
- (void)setupNavigationBarClearnTextColorWithBackViewCustomColor:(UIColor *)customColor;//透明色
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomColor:(UIColor *)customColor;//自定色
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomBeginColor:(UIColor *)customBeginColor andBackViewCustomEndColor:(UIColor *)customEndColor andSize:(CGSize)custimSize;
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomImg:(UIImage *)cImg;
- (void)setupsetupNavigationBarWithChatVcStyle;//聊天的nav渐变色

- (void)pushVc:(id)vc;
- (void)popVC;
@end

NS_ASSUME_NONNULL_END
