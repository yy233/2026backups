//
//  Y_BaseViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/14.
//

#import "Y_BaseViewController.h"

@interface Y_BaseViewController ()

@end

@implementation Y_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];//顶部状态栏主题相关
}

//顶部状态栏主题相关
- (UIStatusBarStyle)preferredStatusBarStyle{
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        return UIStatusBarStyleDarkContent ;//黑色内容
    }else{
        return UIStatusBarStyleLightContent;//白色内容
    }
}
#pragma mark -

#pragma mark - 设置navigationBar为透明色
- (void)setup_NavigationBar_TransparentBk_whiteText {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundEffect = nil;//这是关键
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
- (void)setup_NavigationBar_TransparentBk_blackText {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundEffect = nil;//这是关键
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

- (void)setup_NavigationBar_TransparentBk_CustomColorText:(UIColor *)customTextColor {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = customTextColor;
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundEffect = nil;//这是关键
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

#pragma mark ===



- (void)setupNavigationBarblackTextColorWithBackViewCustomColor:(UIColor *)customColor{
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                             NSForegroundColorAttributeName:[UIColor blackColor]
    };
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage  imageWithColor:customColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor: [UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
     
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = customColor;
        
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor: customColor] forBarMetrics:UIBarMetricsDefault];
    }
   
}

- (void)setupNavigationBarWhiteTextColorWithBackViewCustomColor:(UIColor *)customColor{
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                             NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage  imageWithColor:customColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor: [UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
     
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = customColor;
        
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor: customColor] forBarMetrics:UIBarMetricsDefault];
    }
   
}
#pragma mark - navigationBar默认背景色
- (void)setupNavigationBarStyleWithColor {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor whiteColor];
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]   forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 设置navigationBar为透明色
- (void)setupNavigationBarTransparentStyle {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
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

#pragma mark - 改变浅色navigationBar背景色
- (void)navigationBarWhiteStyleWithColorChanged:(UIColor *)color {
    
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        [self.navigationItem setBackButtonTitle:@""];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
        NSDictionary *attDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor blackColor]};
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
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
    }else{
                
        [self navigationBarDarkStyleWithColorChanged:[UIColor whiteColor]];
    }

   
}

#pragma mark - 改变深色navigationBar背景色
- (void)navigationBarDarkStyleWithColorChanged:(UIColor *)color {
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        [self.navigationItem setBackButtonTitle:@""];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        NSDictionary *attDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
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
    }else{
        [self navigationBarWhiteStyleWithColorChanged: Color_51BlackColor];
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
