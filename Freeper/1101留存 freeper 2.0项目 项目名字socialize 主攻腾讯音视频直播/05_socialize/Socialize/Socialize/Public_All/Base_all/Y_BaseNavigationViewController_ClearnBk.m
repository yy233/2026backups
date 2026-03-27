//
//  Y_BaseNavigationViewController_ClearnBk.m
//  Socialize
//
//  Created by 余莹 on 2023/5/14.
//

#import "Y_BaseNavigationViewController_ClearnBk.h"

@interface Y_BaseNavigationViewController_ClearnBk ()

@end

@implementation Y_BaseNavigationViewController_ClearnBk

- (UIViewController *)childViewControllerForStatusBarStyle{//顶部状态栏主题相关
    return self.topViewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


+(void)initialize{
   
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.shadowColor = nil;
        appearance.backgroundEffect = nil;//这是关键
        appearance.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        [appearance setBackIndicatorImage:[UIImage imageWithColor:[UIColor clearColor]] transitionMaskImage:[UIImage imageWithColor:[UIColor clearColor]]];

      
        appearance.backgroundColor =  [UIColor clearColor];
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        navigationBar.backgroundColor = [UIColor clearColor];
        navigationBar.barTintColor = [UIColor clearColor];
        navigationBar.shadowImage =  [UIImage new];// Y_gray_img;
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance= [UINavigationBar appearance].standardAppearance;;//appearance;
//        导航栏背景颜色BarTintColor 导航栏按钮颜色TintColor | itemImgv 原图方法 imageWithRenderingMode

        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            navigationBar.tintColor = [UIColor blackColor];
//            navigationBar.backgroundColor = [UIColor whiteColor];
            navigationBar.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Light_Str];

            
        }else{
            navigationBar.tintColor = [UIColor whiteColor];
//            navigationBar.backgroundColor = Color_51BlackColor;
            navigationBar.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Drak_Str];

            
        }

        
        

        [[UINavigationBar appearance] setTranslucent:NO];

    }
    else {
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        navigationBar.backgroundColor = [UIColor clearColor];
        navigationBar.barTintColor = [UIColor clearColor];
        navigationBar.shadowImage =  [UIImage new];//  Y_gray_img;
        [[UINavigationBar appearance] setTranslucent:NO];
        [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(Screen_W, KNavBarHeight)] forBarMetrics:UIBarMetricsDefault];
        
        /**
         设置self.navigationController.navigationBar.translucent = NO;就可以取消半透明效果
         edgesForExtendedLayout
         当translucent = YES，controller中self.view的原点是从导航栏左上角开始计算
         当translucent = NO，controller中self.view的原点是从导航栏左下角开始计算
         */
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.shadowColor = nil;
        appearance.backgroundEffect = nil;//这是关键
        appearance.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        [appearance setBackIndicatorImage:[UIImage imageWithColor:[UIColor clearColor]] transitionMaskImage:[UIImage imageWithColor:[UIColor clearColor]]];

      
        appearance.backgroundColor =  [UIColor clearColor];
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        navigationBar.backgroundColor = [UIColor clearColor];
        navigationBar.barTintColor = [UIColor clearColor];
        navigationBar.shadowImage =  [UIImage new];// Y_gray_img;
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance= [UINavigationBar appearance].standardAppearance;;//appearance;
//        导航栏背景颜色BarTintColor 导航栏按钮颜色TintColor | itemImgv 原图方法 imageWithRenderingMode

        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            navigationBar.tintColor = [UIColor blackColor];
           // navigationBar.backgroundColor = [UIColor whiteColor];
            navigationBar.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Light_Str];
        }else{
            navigationBar.tintColor = [UIColor whiteColor];
            //navigationBar.backgroundColor = Color_51BlackColor;
            navigationBar.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Drak_Str];

            
        }

        //nav颜色
        UIColor *textColor = nil;
        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            textColor = Color_51BlackColor;
        }else{
            textColor = [UIColor whiteColor];
        }
        NSDictionary *attDic = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
            NSForegroundColorAttributeName:textColor};
        
        navigationBar.titleTextAttributes = attDic;
        

//        [[UINavigationBar appearance] setTranslucent:NO];

    }
    else {
        
        //nav颜色
        UIColor *textColor = nil;
        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            textColor = Color_51BlackColor;
        }else{
            textColor = [UIColor whiteColor];
        }
        NSDictionary *attDic = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
            NSForegroundColorAttributeName:textColor};
        
  
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        navigationBar.backgroundColor = [UIColor clearColor];
        navigationBar.barTintColor = [UIColor clearColor];
        navigationBar.shadowImage =  [UIImage new];//  Y_gray_img;
//        [[UINavigationBar appearance] setTranslucent:NO];
        [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(Screen_W, KNavBarHeight)] forBarMetrics:UIBarMetricsDefault];
        navigationBar.titleTextAttributes = attDic;
        
        /**
         设置self.navigationController.navigationBar.translucent = NO;就可以取消半透明效果
         edgesForExtendedLayout
         当translucent = YES，controller中self.view的原点是从导航栏左上角开始计算
         当translucent = NO，controller中self.view的原点是从导航栏左下角开始计算
         */
    }
}

//重写push后返回按钮的文字,文字可以为空字符串.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //修改返回文字
//    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mainBack"] style:UIBarButtonItemStylePlain target:nil action:nil];
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    UIColor *textColor = nil;
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        textColor = Color_51BlackColor;
    }else{
        textColor = [UIColor whiteColor];
    }
    viewController.navigationItem.backBarButtonItem.tintColor =  textColor;
    [super pushViewController:viewController animated:animated];
}

-(void)popSelf
{
    [self popViewControllerAnimated:YES];
}
 
 
@end
