//
//  TabBarController.m
//  test
//
//  Created by 余莹 on 2020/11/9.
//

#import "TabBarController.h"

@interface TabBarController () <UITabBarControllerDelegate>
@property (nonatomic,strong) NSArray *vSavecArr;

@property (nonatomic,strong) OttoFPSButton  *fpsShowBtn;

@property (nonatomic,strong) UIWindow *lastObjectWindow;

@end
/**
 
 typedef enum : NSUInteger {
     TabBarSubVc_Num_Commounity,
     TabBarSubVc_Num_Shop,
     TabBarSubVc_Num_Qianzhang,
     TabBarSubVc_Num_Mine,
 } TabBarSubVc_Num;


 */
@implementation TabBarController

// test fps  20211223
- (OttoFPSButton *)fpsShowBtn{
    if (!_fpsShowBtn) {
        CGRect frame = CGRectMake(Screen_W-85, 100, 80, 30);
        UIColor *btnBGColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        _fpsShowBtn = [OttoFPSButton setTouchWithFrame:frame titleFont:[UIFont systemFontOfSize:15] backgroundColor:btnBGColor backgroundImage:nil];
    }
    return _fpsShowBtn;
}
- (UIWindow *)lastObjectWindow{
    if (!_lastObjectWindow) {
        _lastObjectWindow  = [[UIApplication sharedApplication].windows lastObject];
    }
    return _lastObjectWindow;
}

- (void)fpsTest{
    [self.lastObjectWindow addSubview:self.fpsShowBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self fpsTest];
    
    [ThemeManager shareManager].saveThemeTypeWithStr = [[NSUserDefaults standardUserDefaults] objectForKey:Key_SaveThemeTypeWithStr];
    if ( isNil( [ThemeManager shareManager].saveThemeTypeWithStr ) || [ThemeManager shareManager].saveThemeTypeWithStr.length==0) {//初始没有值 赋予暗黑主题
        [ThemeManager shareManager].type = ThemeType_Drak;
        [ThemeManager shareManager].saveThemeTypeWithStr = kSaveThemeTypeWithStr_Dray;
        [ZYThemeManager shareManager].themeType = ZYThemeType_Dark;
        NSLog(@"saveThemeTypeWithStr 初始没有值 赋予暗黑主题");
    }else{
        //已经赋值过 则str有值 取出当前主题
        if ([[ThemeManager shareManager].saveThemeTypeWithStr isEqualToString: kSaveThemeTypeWithStr_Dray]) {
            [ThemeManager shareManager].type = ThemeType_Drak;
            [ZYThemeManager shareManager].themeType = ZYThemeType_Dark;
        }
        if ([[ThemeManager shareManager].saveThemeTypeWithStr isEqualToString: kSaveThemeTypeWithStr_White]) {
            [ThemeManager shareManager].type = ThemeType_White;
            [ZYThemeManager shareManager].themeType = ZYThemeType_White;
        }
        NSLog(@"saveThemeTypeWithStr 有值");
    }

//    [ThemeManager shareManager].type = ThemeType_White;//登录后大界面初始化
    [self initializeUserInterface];
    [[UITabBar appearance] setBackgroundColor:[ZYThemeManager shareManager].contentViewBackgroundThemeColor];
    [[UITabBar appearance] setBarTintColor:[ZYThemeManager shareManager].contentViewBackgroundThemeColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor zy_colorWithHexString:@"#237CFA"]} forState:UIControlStateSelected];
    //
    self.delegate = self;
    //
    [self initNoticeThemeIsChange];
}
- (void)initializeUserInterface{
    if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1) {
         CommunityManagementMainVcLate *commuityManageVC = [[CommunityManagementMainVcLate alloc]init];
         PersonCenterVcLate *personCenterVC = [[PersonCenterVcLate alloc]init];
        //(暂时商城隐藏)
        NSArray *vcArr = @[commuityManageVC,personCenterVC];
        self.vSavecArr = vcArr.mutableCopy;
        NSArray *vcNavTitles = @[@"社区",@"我的"];
        NSMutableArray * navs = [@[]mutableCopy];
        NSArray *normalImgs = @[@"Tab_Community_Normal",@"Tab_Mine_Normal"];
        NSArray *selectImgs = @[@"Tab_Community_Select",@"Tab_Mine_Select"];
        [vcArr enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
            vc.title = vcNavTitles[idx];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:vcNavTitles[idx] image:[[UIImage imageNamed:normalImgs[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage: [[UIImage imageNamed:selectImgs[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            /* 统一配置导航控制器 */
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
            if (idx == TabBarSubVc_Num_Commounity || idx == TabBarSubVc_Num_Mine) {//主页num0  商城1  签章2 我的个人中心3 (暂时商城隐藏)
                [self navBackColorClearn];
            }else{
                //            [self navBackColorClearn];
                [self navBackColorAndTitilColorWithNavController:nav];
            }
            [navs addObject:nav];
            UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
            backBtn.title = @"";
            nav.navigationItem.backBarButtonItem = backBtn;
        }];
        self.viewControllers = navs;//导航控制器 关联上 标签控制器
        self.selectedIndex = TabBarSubVc_Num_Commounity;
        self.oldSelectIndex =  self.selectedIndex;
    }else{
         CommunityManagementMainVcLate *commuityManageVC = [[CommunityManagementMainVcLate alloc]init];
        //    BusinessServicesVC *businessServicesVC = [[BusinessServicesVC alloc]init];
         ElectronicSignatureVC *electronicSignatureVC = [[ElectronicSignatureVC alloc]init];
         PersonCenterVcLate *personCenterVC = [[PersonCenterVcLate alloc]init];
        /**
         NSArray *vcArr = @[commuityManageVC,businessServicesVC,electronicSignatureVC,personCenterVC];
         self.vSavecArr = vcArr.mutableCopy;
         NSArray *vcNavTitles = @[@"社区",@"商城",@"签章",@"我的"];
         NSMutableArray * navs = [@[]mutableCopy];
         NSArray *lightImgs = @[@"Tab_Community_Normal",@"Tab_Shoppingmall_Normal",@"Tab_Signatureandseal_Normal",@"Tab_Mine_Normal"];
         NSArray *darkImgs = @[@"Tab_Community_Select",@"Tab_Shoppingmall_Select",@"Tab_Signatureandseal_Select",@"Tab_Mine_Select"];
         */
        //(暂时商城隐藏)
        NSArray *vcArr = @[commuityManageVC,electronicSignatureVC,personCenterVC];
        self.vSavecArr = vcArr.mutableCopy;
        NSArray *vcNavTitles = @[@"社区",@"签章",@"我的"];
        NSMutableArray * navs = [@[]mutableCopy];
        NSArray *normalImgs = @[@"Tab_Community_Normal",@"Tab_Signatureandseal_Normal",@"Tab_Mine_Normal"];
        NSArray *selectImgs = @[@"Tab_Community_Select",@"Tab_Signatureandseal_Select",@"Tab_Mine_Select"];
        [vcArr enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
            vc.title = vcNavTitles[idx];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:vcNavTitles[idx] image:[[UIImage imageNamed:normalImgs[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage: [[UIImage imageNamed:selectImgs[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            /* 统一配置导航控制器 */
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
            if (idx == TabBarSubVc_Num_Commounity || idx == TabBarSubVc_Num_Mine) {//主页num0  商城1  签章2 我的个人中心3 (暂时商城隐藏)
                [self navBackColorClearn];
            }else{
                //            [self navBackColorClearn];
                [self navBackColorAndTitilColorWithNavController:nav];
            }
            [navs addObject:nav];
            UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
            backBtn.title = @"";
            nav.navigationItem.backBarButtonItem = backBtn;
        }];
        self.viewControllers = navs;//导航控制器 关联上 标签控制器
        self.selectedIndex = TabBarSubVc_Num_Commounity;
        self.oldSelectIndex =  self.selectedIndex;
    }

 
}
 
- (void)navBackColorAndTitilColorWithNavController:(UINavigationController *)nav{
//    [ThemeManager shareManager].type = ThemeType_Drak;
    if ( [ThemeManager shareManager].type) {
        NSLog(@"ThemeManager type= %lu", (unsigned long)[ThemeManager shareManager].type);
    }else{
        NSLog(@"ThemeManager type= %lu", (unsigned long)[ThemeManager shareManager].type);
    }
    NSLog(@"ThemeManager ========type= %lu", (unsigned long)[ThemeManager shareManager].type);
 
  
    nav.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    nav.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor};
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].themeColorVCBackViewColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (void)navBackColorClearn{
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor};
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setTranslucent:YES];
}
- (void)tabbarChangImgWhenTypechanged{
    //
    NSArray *vcNavTitles = @[@"社区",@"商城",@"签章",@"我的"];
    //
    NSArray *lightImgs = @[@"Tab_Community_Normal",@"Tab_Shoppingmall_Normal",@"Tab_Signatureandseal_Normal",@"Tab_Mine_Normal"];
    NSArray *darkImgs = @[@"Tab_Community_Select",@"Tab_Shoppingmall_Select",@"Tab_Signatureandseal_Select",@"Tab_Mine_Select"];
    NSMutableArray *imageNames = [[NSMutableArray alloc]init];;
    NSMutableArray *imageSelectedNames = [[NSMutableArray alloc]init];;
    if ([ThemeManager shareManager].type==ThemeType_White) {
        imageNames = darkImgs.mutableCopy;
        imageSelectedNames = lightImgs.mutableCopy;
    }else{
        imageNames = lightImgs.mutableCopy;
        imageSelectedNames = darkImgs.mutableCopy;
    }
    [self.vSavecArr enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) { 
        vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:vcNavTitles[idx] image:[[UIImage imageNamed:imageNames[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage: [[UIImage imageNamed:imageSelectedNames[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }];
}

#pragma mark ====
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController API_AVAILABLE(ios(3.0)){
    self.oldSelectIndex = tabBarController.selectedIndex;
    // 记录之前选择的selectedIndex
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
   
    if (tabBarController.selectedIndex == TabBarSubVc_Num_Qianzhang) {//____________签章
      //此处判断是否登录、如果未登录需要执行弹出登录页面的操作
       
        WEAKSELF
        STRONGSELF
        if ([IsLoginTool share].save_Login_Type==IS_Login_Tourists) {
            //    //未登录将tabbar的selectedIndex设置为之前选择的selectedIndex
            tabBarController.selectedIndex = self.oldSelectIndex;
            //登录view
            [[IsLoginTool share]willPresentLoginViewControllerWithLoginVCBlock:^(UINavigationController * _Nonnull navc) {
                navc.modalPresentationStyle = UIModalPresentationFullScreen;
                [strongSelf presentViewController:navc animated:YES completion:^{
                    NSLog(@"tabbar present弹出登录vc");
                }];
            }];
        } else if( [IsLoginTool share].save_Login_Type==IS_Login_UnboundPhone){
            
             //未登录将tabbar的selectedIndex设置为之前选择的selectedIndex
            tabBarController.selectedIndex = self.oldSelectIndex;
            //用三方ID绑定电话
            //苹果 绑定手机操作
            AppleLoginModel *model = [[AppleLoginModel alloc]init];
            model.thirdPlatformId = [IsLoginTool share].appleLoginSaveThridIdWillUseToBindPhone;
            //
            BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
            bindVc.appleUserModel = model;
            bindVc.hidesBottomBarWhenPushed = YES;
            [strongSelf.vSavecArr[tabBarController.selectedIndex] pushVc:bindVc];

        }
    }
    if (tabBarController.selectedIndex == TabBarSubVc_Num_Mine) {//—————————————— 我的个人中心
      //此处判断是否登录、如果未登录需要执行弹出登录页面的操作
       
        WEAKSELF
        STRONGSELF
        if ([IsLoginTool share].save_Login_Type==IS_Login_Tourists) {
            //    //未登录将tabbar的selectedIndex设置为之前选择的selectedIndex
            tabBarController.selectedIndex = self.oldSelectIndex;
            //登录view
            [[IsLoginTool share]willPresentLoginViewControllerWithLoginVCBlock:^(UINavigationController * _Nonnull navc) {
                navc.modalPresentationStyle = UIModalPresentationFullScreen;
                [strongSelf presentViewController:navc animated:YES completion:^{
                    NSLog(@"tabbar present弹出登录vc");
                }];
            }];
        } else if( [IsLoginTool share].save_Login_Type==IS_Login_UnboundPhone){
            /** 我的界面 不跳绑定 需要展示该界面 且能够走退出按钮
             
             //未登录将tabbar的selectedIndex设置为之前选择的selectedIndex
            tabBarController.selectedIndex = self.oldSelectIndex;
            //用三方ID绑定电话
            //苹果 绑定手机操作
            AppleLoginModel *model = [[AppleLoginModel alloc]init];
            model.thirdPlatformId = [IsLoginTool share].appleLoginSaveThridIdWillUseToBindPhone;
            //
            BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
            bindVc.appleUserModel = model;
            bindVc.hidesBottomBarWhenPushed = YES;
            [strongSelf.vSavecArr[tabBarController.selectedIndex] pushVc:bindVc];
             */
           
           
        }
    }
}
 
 
//暂留

//if ([[ShareUserInfo sharedUserInfo].token isEqualToString:Tourists_LoginTokenStr]) {
//    //未登录将tabbar的selectedIndex设置为之前选择的selectedIndex
//    tabBarController.selectedIndex = self.oldSelectIndex;
//    LoginVC *loginVC = [[LoginVC alloc]init];
//    loginVC.isPopVcType = YES;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//
//    [self presentViewController:nav animated:YES completion:^{
//        NSLog(@"弹出登录");
//    }];
//
//} else {//不做任何判断
//}
//- (BOOL)shouldShowLoginVcOrBindVcBool{
//    WEAKSELF
//    STRONGSELF
//    if ([IsLoginTool share].save_Login_Type==IS_Login_Tourists) {
//        //登录view
//        [[IsLoginTool share]willPresentLoginViewControllerWithLoginVCBlock:^(UINavigationController * _Nonnull navc) {
//                [strongSelf presentViewController:navc animated:YES completion:^{
//                    NSLog(@"present弹出登录vc");
//                }];
//        }];
//        return YES;
//
//    } else if( [IsLoginTool share].save_Login_Type==IS_Login_UnboundPhone){
//        //用三方ID绑定电话
//        //苹果 绑定手机操作
//        AppleLoginModel *model = [[AppleLoginModel alloc]init];
//        model.thirdPlatformId = [IsLoginTool share].appleLoginSaveThridIdWillUseToBindPhone;
//        //
//        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
//        bindVc.appleUserModel = model;
//        [self.navigationController pushViewController:bindVc animated:YES];
//        return YES;
//    }
//    return NO;
//}

#pragma mark == 主题色
- (void)initNoticeThemeIsChange{
    Y_NSNotificationCenter_Creat_NameAction(NOTICE_NAME_ThemeISChanged, themeIsChange:)
}
- (void)themeIsChange:(NSNotification*)notice{
    NSLog(@"----Base VC---themeIsChange----%@",[self class]);
    DLog(@"themeIsChange");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tabBar setBackgroundColor:[ZYThemeManager shareManager].contentViewBackgroundThemeColor];
        [self.tabBar setBarTintColor:[ZYThemeManager shareManager].contentViewBackgroundThemeColor];
    });
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(NOTICE_NAME_ThemeISChanged)
    
    [self.fpsShowBtn removeFromSuperview];
}

@end
