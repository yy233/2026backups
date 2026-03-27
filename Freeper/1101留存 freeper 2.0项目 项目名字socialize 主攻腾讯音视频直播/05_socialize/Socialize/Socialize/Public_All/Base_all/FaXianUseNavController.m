//
//  FaXianUseNavController.m
//  Socialize
//
//  Created by 余莹 on 2023/9/6.
//
//发现页 涉及直播 所需要的navc
#import "FaXianUseNavController.h"
#define  NavTiTle_Font          [UIFont boldSystemFontOfSize:18.0f]

#import "FaXianWebVc.h"
#import "ZhiBoAllMianListAndCanCreatNewZhiBoViewController.h"
#import "ZhiBoMyListVC.h"
#import "ZhiBoTopTypeChooseView.h"
#import "DappUseBaseVc.h"

@interface FaXianUseNavController ()

@end

@implementation FaXianUseNavController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self baseTextFontBkColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DLog();
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        
        //透明时 使用self.edgesForExtendedLayout = UIRectEdgeNone 坐标从nav下摆开始，此处是navc透出来的 背景颜色
        if(self.childViewControllers.count == 1 && [self.childViewControllers.firstObject isKindOfClass:[FaXianWebVc class]]){
            [self hidenNavC:self.childViewControllers.firstObject];
            self.childViewControllers.firstObject.view.backgroundColor = JianBian_Blue_Color;
        }else if([self.childViewControllers.firstObject isKindOfClass:[DappUseBaseVc class]] ){
            [self nomalNavC:self.childViewControllers.firstObject];
            self.childViewControllers.firstObject.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Light_Str];
        }else{
            self.childViewControllers.firstObject.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Light_Str];
        }
        
    }else{
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str];
    }
  
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DLog();
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        
        //透明时 使用self.edgesForExtendedLayout = UIRectEdgeNone 坐标从nav下摆开始，此处是navc透出来的 背景颜色
        if(self.childViewControllers.count == 1 && [self.childViewControllers.firstObject isKindOfClass:[FaXianWebVc class]]){
            [self hidenNavC:self.childViewControllers.firstObject];
            self.childViewControllers.firstObject.view.backgroundColor = JianBian_Blue_Color;
        }else if([self.childViewControllers.firstObject isKindOfClass:[DappUseBaseVc class]]){
            [self nomalNavC:self.childViewControllers.firstObject];
            self.childViewControllers.firstObject.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Light_Str];
        }else{
            self.childViewControllers.firstObject.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Light_Str];
        }
        
    }else{
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str];
    }

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
    if([self.childViewControllers.firstObject isKindOfClass:[FaXianWebVc class]]){
        
        [self hidenNavC:self.childViewControllers.firstObject];
        DLog(@"隐藏 设置childViewControllers = %@",self.childViewControllers);
    }else if([self.childViewControllers.firstObject isKindOfClass:[DappUseBaseVc class]]){
        
        [self nomalNavC:self.childViewControllers.firstObject];
        DLog(@"普通nav色 设置childViewControllers = %@",self.childViewControllers);
    }else{
        [self clearnNavC:self.childViewControllers.firstObject];//透明色
        DLog(@"透明 设置childViewControllers = %@",self.childViewControllers);
    }
  
  
  
 
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    DLog(@"%s will show %@",__FUNCTION__,viewController);
    [self doNavColorChangeWithVc:viewController];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    DLog(@"%s didShowViewController %@",__FUNCTION__,viewController);
    [self doNavColorChangeWithVc:viewController];
}

- (void)doNavColorChangeWithVc:(UIViewController *)viewController{
    if([viewController isKindOfClass: NSClassFromString(@"TUIVoiceRoom.TRTCVoiceRoomViewController")]){//语音直播内容页面
        DLog(@"TRTVoiceRoomViewController语音直播页面不处理nav");
        return;
    }
    
    if([viewController isKindOfClass:[FaXianWebVc class]]){//发现主页
        //隐藏nav
        [self hidenNavC:viewController];
      
    }else if([viewController isKindOfClass:NSClassFromString(@"ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController")]
             || [viewController isKindOfClass: NSClassFromString(@"Socialize.ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController")]
             || [viewController isKindOfClass: NSClassFromString(@"ZhiBoPivTypeBaoMingVc")]){//创建直播工具主页 报名页
        //透明色
        [self clearnNavC:viewController];
        
    }else if([viewController isKindOfClass:[ZhiBoAllMianListAndCanCreatNewZhiBoViewController class]]
             || [viewController isKindOfClass:NSClassFromString(@"ZhiBoAllMianListAndCanCreatNewZhiBoViewController_Sw")]){//直播主列表
        //titleV 且 普通主题背景
//        [self nomalNavC:viewController];//0921
        [self jianbianColorNavc:viewController];//蓝色
//        [self clearnNavC:viewController];//透明
        [self setTitleV:viewController];
        
    }else{//比如我的直播
        //普通主题色
        [self nomalNavC:viewController];
    }
}

#pragma mark ===

- (void)hidenNavC:(UIViewController *)viewController{
    [viewController.navigationController setNavigationBarHidden:YES animated:YES];//发现页 隐藏nav
    if([self.childViewControllers.firstObject isKindOfClass:[FaXianWebVc class]]){//发现页 切换跳动的自己的背景色处理
        if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
            viewController.view.backgroundColor = JianBian_Blue_Color;
        }else{
            viewController.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str];
        }
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
    //透明时 坐标从nav下摆开始，此处是navc透出来的 背景颜色
    if([viewController isKindOfClass:NSClassFromString(@"ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController")]
       || [viewController isKindOfClass: NSClassFromString(@"Socialize.ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController")]
       || [viewController isKindOfClass: NSClassFromString(@"ZhiBoPivTypeBaoMingVc")]){
        
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str];//创建页的到的暗色背景
        viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];//白色按钮

    }else{
        self.view.backgroundColor = navBarColor;
    }

}


//普通主题
- (void)nomalNavC:(UIViewController *)viewController{
    
    //导航栏背景色
    UIColor *navBarColor;
    //字体色
    UIColor *navTitleColor = [UIColor blackColor];
    //按钮色
    UIColor *navItemColor = [UIColor blackColor];
    if([[ShareLocale shared].nowThemeStr  isEqualToString:Now_Theme_light]){
        navTitleColor = [UIColor blackColor];
        navItemColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Light_Str];
        navBarColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Light_Str];
    }else{
        navTitleColor = [UIColor whiteColor];
        navItemColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str];
        navBarColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str];
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
    
    //透明时 坐标从nav下摆开始，此处是navc透出来的 背景颜色
    self.view.backgroundColor = navBarColor;
}

- (void)jianbianColorNavc:(UIViewController *)viewController{
    
    
    //导航栏背景色
    UIColor *navBarColor;
    //字体色
    UIColor *navTitleColor = [UIColor blackColor];
    //按钮色
    UIColor *navItemColor = [UIColor blackColor];
    if([[ShareLocale shared].nowThemeStr  isEqualToString:Now_Theme_light]){
        navTitleColor = [UIColor blackColor];
        navItemColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Light_Str];
        navBarColor = JianBian_Blue_Color;//浅蓝
    }else{
        navTitleColor = [UIColor whiteColor];
        navItemColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str];
        navBarColor = [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Drak_Str];//暗色
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
    //透明时 坐标从nav下摆开始，此处是navc透出来的 背景颜色
    self.view.backgroundColor = navBarColor;
}
- (void)setTitleV:(UIViewController *)viewController{

    if([viewController.navigationItem.titleView isKindOfClass: [ZhiBoTopTypeChooseView class]]){
        //已经存在
    }else{
        ZhiBoTopTypeChooseView *navview = [[ZhiBoTopTypeChooseView alloc]initWithFrame:CGRectMake(0, 0, Screen_W*0.9, KNavBarHeight)];
        navview.delegate = viewController;
        navview.tag = 3333;//用于创建页处理显示隐藏
        viewController.navigationItem.titleView = navview;
    }
    viewController.navigationItem.titleView.hidden = NO;
    //透明时 坐标从nav下摆开始，此处是navc透出来的 背景颜色
    if([[ShareLocale shared].nowThemeStr  isEqualToString:Now_Theme_light]){
        self.view.backgroundColor = JianBian_Blue_Color;
    }else{
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str];
    }
    
}
@end
