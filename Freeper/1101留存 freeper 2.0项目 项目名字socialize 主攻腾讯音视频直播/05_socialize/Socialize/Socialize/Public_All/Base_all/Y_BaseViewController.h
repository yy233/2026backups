//
//  Y_BaseViewController.h
//  Socialize
//
//  Created by 余莹 on 2023/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Y_BaseViewController : UIViewController
//自定义色
- (void)setupNavigationBarWhiteTextColorWithBackViewCustomColor:(UIColor *)customColor;
- (void)setupNavigationBarblackTextColorWithBackViewCustomColor:(UIColor *)customColor;
/// navigationBar默认背景色
- (void)setupNavigationBarStyleWithColor;

/// 设置navigationBar为透明色
- (void)setupNavigationBarTransparentStyle;




/// 隐藏navigationBar
- (void)hiddenNavigationBar;

- (void)pushVc:(id)vc;

- (void)popVc:(id)vc;

- (void)popVC;

#pragma mark - 设置navigationBar为透明色_黑白两文本
- (void)setup_NavigationBar_TransparentBk_whiteText;
- (void)setup_NavigationBar_TransparentBk_blackText;
/// 设置navigationBar为透明色 自定义文本
- (void)setup_NavigationBar_TransparentBk_CustomColorText:(UIColor *)customTextColor;
@end

NS_ASSUME_NONNULL_END

/**
 
 - (void)baseVcnvc{
 [self.navigationItem setBackButtonTitle:@""];
 self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];//黑色的按钮
 self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
     //0704 透明导航 无论前页面是不是透明 本方法都能透明  但是12mini试过 不行 得与navBackColorreturn的 两种合起来用才透明 或者  appearance.backgroundEffect = nil;//这是关键的一行 可以使本段代码透明
     NSDictionary *attDic = @{
         NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
         NSForegroundColorAttributeName:[UIColor blueColor]};
     [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];//bk
     [self.navigationController.navigationBar setTranslucent:YES]; //透明
     [self.navigationController setNavigationBarHidden:NO animated:YES];//不隐藏
     if (@available(iOS 15.0, *)) {
         UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
         appearance.titleTextAttributes = attDic;
         appearance.backgroundColor = [UIColor clearColor];//bk
         appearance.shadowColor = [UIColor clearColor];//阴影线
 
         self.navigationController.navigationBar.standardAppearance = appearance;
         self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
     }else {
         [self.navigationController.navigationBar setTitleTextAttributes:attDic];
         [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
     }
 }
 */
