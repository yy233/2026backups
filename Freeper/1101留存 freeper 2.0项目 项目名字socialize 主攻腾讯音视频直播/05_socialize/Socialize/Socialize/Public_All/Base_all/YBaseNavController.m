//
//  YBaseNavController.m
//  Socialize
//
//  Created by 余莹 on 2023/9/5.
//

#import "YBaseNavController.h"
#define  NavTiTle_Font          [UIFont boldSystemFontOfSize:18.0f]

@interface YBaseNavController ()

@end

@implementation YBaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DLog(@"");
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        //透明时 使用self.edgesForExtendedLayout = UIRectEdgeNone 坐标从nav下摆开始，此处是navc透出来的 背景颜色
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Light_Str];
    }else{
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str];
    }
    [self baseTextFontBkColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    DLog(@"");
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    DLog(@"");
}

#pragma mark === 顶部状态栏主题相关
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

#pragma mark === 重写push
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //修改返回文字
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];//[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mainBack"] style:UIBarButtonItemStylePlain target:nil action:nil]
    //tabbar隐藏
    if(self.viewControllers.count > 0 ){
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
 

#pragma mark === 基础字体颜色
- (void)baseTextFontBkColor{
    if(self.childViewControllers.count<0){
        return;
    }
    [self clearnNavC:self.childViewControllers.firstObject];//透明色
    DLog(@"childViewControllers = %@",self.childViewControllers);
 
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    DLog(@"%s will show %@",__FUNCTION__,viewController);
    if([viewController isKindOfClass:[MyViewController class]]){
        [self clearnNavC:viewController];
    }else{
        
    }
}
- (void)clearnNavC:(UIViewController *)viewController{
    //导航栏背景色
    UIColor *navBarColor = [UIColor clearColor];
    //字体色
    UIColor *navTitleColor = [UIColor blackColor];
    //按钮色
    UIColor *navItemColor = [UIColor blackColor];
    if([[ShareLocale shared].nowThemeStr  isEqualToString:Now_Theme_light]){
        navTitleColor = [UIColor blackColor];
        navItemColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Light_Str];
    }else{
        navTitleColor = [UIColor whiteColor];
        navItemColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str];
    }

    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = navBarColor;
        appearance.backgroundEffect = nil;
        appearance.titleTextAttributes = @{NSFontAttributeName:NavTiTle_Font,
                                           NSForegroundColorAttributeName:navTitleColor};
        appearance.shadowColor= [UIColor clearColor];  //去掉导航栏下的阴影线
        viewController.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        viewController.navigationController.navigationBar.standardAppearance = appearance;
    }else{
        [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:navBarColor size:CGSizeMake(300, 20)]
                                                                forBarMetrics:UIBarMetricsDefault];
        //设置导航栏文字颜色
        [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:NavTiTle_Font,
                                                                                    NSForegroundColorAttributeName:navTitleColor}];

    }
    viewController.navigationController.navigationBar.tintColor = navItemColor;
    viewController.navigationController.navigationBar.backgroundColor = navBarColor;//底色
    [viewController.navigationController setNavigationBarHidden:NO animated:YES];//存在nav
}
@end
