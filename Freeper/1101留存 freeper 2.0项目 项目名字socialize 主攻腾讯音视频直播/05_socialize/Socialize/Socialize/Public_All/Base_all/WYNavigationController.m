//
//  WYNavigationController.m
//  WYNavigationDemo
//
//  Created by 王俨 on 16/7/9.
//  Copyright © 2016年 wangyan. All rights reserved.
//

#import "WYNavigationController.h"
#import "ViewController.h"


@interface WYNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation WYNavigationController
- (UIViewController *)childViewControllerForStatusBarStyle{//顶部状态栏主题相关
    return self.topViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    id target = self.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];//返回按钮文本“”字符
    
    
    
    
    if([viewController isKindOfClass:NSClassFromString(@"ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController")]){//创建页的nav
        [super pushViewController:viewController animated:animated];
    }else{
        [super pushViewController:viewController animated:animated];
    }
    


        
    [self dealNavColor:viewController]; //nav颜色

 
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isHideNav = ([viewController isKindOfClass:[ViewController class]]
                      || [viewController isKindOfClass: NSClassFromString(@"FaXianWebVc")]
                      );//发现页使用这个作nav隐藏
    //||[viewController isKindOfClass:NSClassFromString(@"ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController")]0901创建页先不做隐藏
    DLog( @" childViewControllers -- %@",self.childViewControllers);
    DLog(@"isHide =viewController%@ %d",viewController, isHideNav);
    if([viewController isKindOfClass:NSClassFromString(@"TRTVoiceRoomViewController")]){//语音直播页面不处理nav
        NSLog(@"TRTVoiceRoomViewController语音直播页面不处理nav");
        return;
    }
    if(isHideNav == NO){
        [self dealNavColor:viewController];
    }else{//透明色
    }
    [self setNavigationBarHidden:isHideNav animated:YES];
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL isHideNav = ([viewController isKindOfClass:[ViewController class]]
                      || [viewController isKindOfClass: NSClassFromString(@"FaXianWebVc")]
                      );//发现页使用这个作nav隐藏
    //||0902语音直播页
    
    DLog( @" childViewControllers -- %@",self.childViewControllers);
    DLog(@"didShowViewController viewController%@ isHideNav = %d ",viewController, isHideNav);
    if([viewController isKindOfClass:NSClassFromString(@"TRTVoiceRoomViewController")]){//语音直播页面不处理nav
        NSLog(@"TRTVoiceRoomViewController语音直播页面不处理nav 111");
        return;
    }else if([viewController isKindOfClass: NSClassFromString(@"TUIVoiceRoom.TRTCVoiceRoomViewController")]){
        NSLog(@"TRTVoiceRoomViewController语音直播页面不处理nav 222");
        return;
    }
    if(isHideNav == NO){
        [self dealNavColor:viewController];
    }else{//透明色 
    }
    
    
    if(([viewController isKindOfClass:NSClassFromString(@"ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController")])
       || [viewController isKindOfClass:NSClassFromString(@"TRTCVoiceRoomViewController")]
       || [viewController isKindOfClass: NSClassFromString(@"TUIVoiceRoom.TRTCVoiceRoomViewController")]){//0902禁止侧滑
        //黑名单中的控制器关闭手势返回
        self.interactivePopGestureRecognizer.enabled = NO;
        self.interactivePopGestureRecognizer.delegate = nil;
    }else
    {
        //其他的页面默认开启手势返回
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)dealNavColor:(UIViewController *)viewController{
    DLog(@"WYNav ---vc = %@",viewController);
    if([viewController isKindOfClass:NSClassFromString(@"ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController")]){//创建页的nav 一直是黑色rgba(27, 26, 39, 1)
        self.view.backgroundColor = rgba(27, 26, 39, 1);
        UIColor *textColor = [UIColor whiteColor];
        NSDictionary *attDic = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
            NSForegroundColorAttributeName:textColor};
        
        self.navigationBar.titleTextAttributes = attDic;
        
        Y_BaseViewController *creatVc = (Y_BaseViewController *)viewController;
        
        [creatVc setup_NavigationBar_TransparentBk_blackText];
//        if (@available(iOS 15.0, *)) {
//            UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
//            [appearance configureWithDefaultBackground];
//            appearance.shadowColor = nil;
//            appearance.backgroundEffect = nil;
//            appearance.backgroundColor =  [self navBackColor];
//            UINavigationBar *navigationBar = self.navigationController.navigationBar;
//            navigationBar.backgroundColor = [self navBackColor];
//     //       navigationBar.barTintColor = [self navBackColor];白色返回按钮?无效
//            navigationBar.barTintColor = [UIColor whiteColor];
//            navigationBar.shadowImage = [UIImage new];
//            NSDictionary *attDic = @{
//                NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
//                NSForegroundColorAttributeName:[UIColor whiteColor]};
//            navigationBar.titleTextAttributes = attDic;
//            navigationBar.standardAppearance = appearance;
//            navigationBar.scrollEdgeAppearance= appearance;
//
//        }
//        else {
//            UINavigationBar *navigationBar = self.navigationController.navigationBar;
//            navigationBar.backgroundColor = [self navBackColor];
//     //       navigationBar.barTintColor = [self navBackColor];白色返回按钮?无效
//            navigationBar.barTintColor = [UIColor whiteColor];
//            navigationBar.shadowImage = [UIImage new];
//            [[UINavigationBar appearance] setTranslucent:NO];
//        }
        [creatVc setupNavigationBarWhiteTextColorWithBackViewCustomColor:rgba(27, 26, 39, 1)];
    }else{
        //nav颜色
        UIColor *textColor = nil;
        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            textColor = Color_51BlackColor;
            self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Light_Str];
        }else{
            textColor = [UIColor whiteColor];
            self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Drak_Str];
        }
        NSDictionary *attDic = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
            NSForegroundColorAttributeName:textColor};
        self.navigationBar.titleTextAttributes = attDic;
    }
}

@end
