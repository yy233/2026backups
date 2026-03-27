//
//  ZYBaseViewController.m
//  Community
//
//  Created by ZY on 2021/8/18.
//

#import "ZYBaseViewController.h"

@interface ZYBaseViewController ()

@end

@implementation ZYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBarStyleWithThemeColor];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    }else {
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        
        return UIStatusBarStyleDarkContent;
    }else {
        
        return UIStatusBarStyleLightContent;
    }
}

#pragma mark - navigationBar主题色
- (void)setupNavigationBarStyleWithThemeColor {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [ZYThemeManager shareManager].navigationItemThemeColor;
    self.navigationItem.rightBarButtonItem.tintColor = [ZYThemeManager shareManager].navigationItemThemeColor;
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[ZYThemeManager shareManager].navigationItemThemeColor};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[ZYThemeManager shareManager].navigationItemThemeColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [ZYThemeManager shareManager].navigationBarBackgroundThemeColor;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 改变navigationBar主题色
- (void)navigationBarStyleWithThemeColorChanged:(UIColor *)color {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [ZYThemeManager shareManager].navigationItemThemeColor;
    self.navigationItem.rightBarButtonItem.tintColor = [ZYThemeManager shareManager].navigationItemThemeColor;
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[ZYThemeManager shareManager].navigationItemThemeColor};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[ZYThemeManager shareManager].navigationItemThemeColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = color;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 设置navigationBar为透明色
- (void)setupNavigationBarTransparentStyle {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [ZYThemeManager shareManager].navigationItemThemeColor;
    self.navigationItem.rightBarButtonItem.tintColor = [ZYThemeManager shareManager].navigationItemThemeColor;
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[ZYThemeManager shareManager].navigationItemThemeColor};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[ZYThemeManager shareManager].navigationItemThemeColor];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor clearColor];
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 清除navigationBar的颜色
- (void)setupNavigationBarClearTransparentStyle {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor clearColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor clearColor];
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 隐藏navigationBar
- (void)hiddenNavigationBar {
   
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark - 跳转
- (void)pushVc:(id)vc {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)popVc:(id)vc {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popToViewController:vc animated:YES];
    });
}

- (void)popVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
