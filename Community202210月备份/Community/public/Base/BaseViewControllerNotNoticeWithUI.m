//
//  BaseViewControllerNotNoticeWithUI.m
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import "BaseViewControllerNotNoticeWithUI.h"

@interface BaseViewControllerNotNoticeWithUI ()

@end

@implementation BaseViewControllerNotNoticeWithUI

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBarWithBackItemNoTitle];
}
#pragma mark == nav
- (void)setupNavigationBarWithBackItemHaveTitleWithStr:(NSString *)titleStr{
    if (isNil(titleStr) || titleStr.length == 0) {
        return;
    }
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = titleStr;
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
}
- (void)setupNavigationBarWithBackItemNoTitle{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
}
//
- (void)pushVc:(id)vc{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}
- (void)popVC{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
//- (void)setupNavigationBarWhiteStyle {
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[UIColor blackColor]
//    }];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor whiteColor]]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[UIColor blackColor]
//    }];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
////    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setTranslucent:NO];
//
//}
- (void)setupNavigationBarWhiteStyle {
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]
    };
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]
    }];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor whiteColor];;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor: [UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    }
    
}

//- (void)setupNavigationBarStyleWithMainColor{  //更改透明为主题色
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor};
//    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].themeColorVCBackViewColor] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
//    [self.navigationController.navigationBar setTranslucent:NO];
//}

- (void)setupNavigationBarStyleWithMainColor{  //更改透明为主题色 //主题色 深色不变 浅色主题时 nav为非白色
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].themeColorVCBackViewColor] forBarMetrics:UIBarMetricsDefault];
    }
}

//- (void)setupNavigationBarTransparentStyle {
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[UIColor whiteColor]
//    }];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTranslucent:YES];
//}

- (void)setupNavigationBarTransparentStyle {
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
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
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor: [UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    }
    
    
}

- (void)setupNavigationBarClearTransparentStyle {
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
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
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor: [UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    }
}

//- (void)setupNavigationBarBlackStyle {
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[UIColor whiteColor]
//    }];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MainBackgroundColor] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:MainBackgroundColor]];
//    [self.navigationController.navigationBar setBackgroundColor:MainBackgroundColor];
//    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTranslucent:NO];
//}
- (void)setupNavigationBarBlackStyle {
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MainBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:MainBackgroundColor]];
    [self.navigationController.navigationBar setBackgroundColor:MainBackgroundColor];
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = MainBackgroundColor;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor: MainBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    }
   
}

//- (void)setupNavigationBarWhiteTextColorWithBackViewCustomColor:(UIColor *)customColor{
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage  imageWithColor:customColor] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor: [UIColor whiteColor]];
//    [self.navigationController.navigationBar setTranslucent:NO];
//}

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

- (void)setupNavigationBarClearnTextColorWithBackViewCustomColor:(UIColor *)customColor{
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                             NSForegroundColorAttributeName:[UIColor clearColor]};//
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
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomColor:(UIColor *)customColor{
    self.navigationItem.leftBarButtonItem.tintColor = itemsTintColor;
    self.navigationItem.rightBarButtonItem.tintColor = itemsTintColor;
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:titleTextColor};//
        [self.navigationController.navigationBar setTintColor: titleTextColor];//?
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage  imageWithColor:customColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
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

#pragma mark == 渐变色的nav
//color +size
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomBeginColor:(UIColor *)customBeginColor andBackViewCustomEndColor:(UIColor *)customEndColor andSize:(CGSize)custimSize{
    UIColor *beginColor = customBeginColor;
    UIColor *endColor = customEndColor;
    CGSize size = custimSize;
    UIImage *cImg = [UIImage gradientColorImageFromColors:@[beginColor,endColor] gradientType:GradientTypeLeftToRight imgSize:size];
    [self setupNavigationBarTextColor:[UIColor whiteColor] andBarItemsColor:[UIColor whiteColor] andBackViewCustomImg:cImg];

}
//img
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomImg:(UIImage *)cImg{
    self.navigationItem.leftBarButtonItem.tintColor = itemsTintColor;
    self.navigationItem.rightBarButtonItem.tintColor = itemsTintColor;
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:titleTextColor};//
        [self.navigationController.navigationBar setTintColor: titleTextColor];//?
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
   //渐变色
    [self.navigationController.navigationBar setBackgroundImage:cImg forBarMetrics:UIBarMetricsDefault];
    //
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];

    [self.navigationController.navigationBar setTranslucent:NO];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor colorWithPatternImage:cImg];//图片做背景色
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:cImg forBarMetrics:UIBarMetricsDefault];
    }

}

//聊天的nav渐变色
- (void)setupsetupNavigationBarWithChatVcStyle{
    UIColor *beginColor = Y_ColorWith16FromRGB(0x567BF3);
    UIColor *endColor = Y_ColorWith16FromRGB(0x3B8FFD);
    CGSize size = CGSizeMake(Screen_W, KNavBarHeight);
    UIImage *cImg = [UIImage gradientColorImageFromColors:@[beginColor,endColor] gradientType:GradientTypeLeftToRight imgSize:size];
    [self setupNavigationBarTextColor:[UIColor whiteColor] andBarItemsColor:[UIColor whiteColor] andBackViewCustomImg:cImg];
}
@end
