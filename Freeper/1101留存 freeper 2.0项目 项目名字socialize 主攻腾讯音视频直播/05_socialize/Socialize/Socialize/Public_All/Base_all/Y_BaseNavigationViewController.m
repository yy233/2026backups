//
//  Y_BaseNavigationViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/10.
//

#import "Y_BaseNavigationViewController.h"

@interface Y_BaseNavigationViewController ()

@end

@implementation Y_BaseNavigationViewController

- (UIViewController *)childViewControllerForStatusBarStyle{//顶部状态栏主题相关
    return self.topViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (UIColor *)nav_bk_color{
    
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
//        return [UIColor whiteColor];
        return [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Light_Str];
        
    }else{
//        return Color_51BlackColor;
        return [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Drak_Str];
    }
   
}
+ (UIImage *)nav_bk_img{
    return [UIImage imageWithColor:[self nav_bk_color]];
}

+(void)initialize{
   
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.shadowColor = nil;
        appearance.backgroundEffect = nil;//这是关键
        appearance.backgroundImage = [self nav_bk_img];
        [appearance setBackIndicatorImage:[self nav_bk_img] transitionMaskImage:[self nav_bk_img]];

        appearance.backgroundColor =  [self nav_bk_color];
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        navigationBar.backgroundColor = [self nav_bk_color];
        navigationBar.barTintColor = [self nav_bk_color];
        navigationBar.shadowImage = [UIImage new];//Y_gray_img;
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance= [UINavigationBar appearance].standardAppearance;;//appearance;
    }
    else {
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        navigationBar.backgroundColor = [self nav_bk_color];
        navigationBar.barTintColor = [self nav_bk_color];
        navigationBar.shadowImage = [UIImage new];// Y_gray_img;
        [[UINavigationBar appearance] setTranslucent:NO];
        [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(Screen_W, KNavBarHeight)] forBarMetrics:UIBarMetricsDefault];
        
    }
  

}
  
 


//重写push后返回按钮的文字,文字可以为空字符串.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //修改返回文字
//    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mainBack"] style:UIBarButtonItemStylePlain target:nil action:nil];
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];

    [super pushViewController:viewController animated:animated];
}

-(void)popSelf
{
    [self popViewControllerAnimated:YES];
}
 
@end

