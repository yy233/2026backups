//
//  CigarTabBarController.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import "CigarTabBarController.h"
#import "CigarWarehouse-Swift.h"

@interface CigarTabBarController () <UITabBarControllerDelegate>
@property (nonatomic,strong) NSArray *vSavecArr;
@property (nonatomic,strong) UIWindow *lastObjectWindow;

@end

@implementation CigarTabBarController
//获取权限和角色
- (void)initAdminDatas{
    if ([ShareUserInfo share].userInfo.token.length<=0) {
        return;
    }
    /**
    [[LoginThingsTool share]adminGetAllRolewithBlock:^(BOOL succ, id  _Nonnull dataThings) {
        if (succ) {
            
        }
            
    }];
    [[LoginThingsTool share]adminGetAllPermissionithBlock:^(BOOL succ, id  _Nonnull dataThings) {
        if (succ) {
            
        }
    }];

 
 [[[testAAA  alloc]init] testNetModel];
 [[[testAAA  alloc]init] funcname];
 
 [testAAA zhijieDiaoYong];
//    [[[testAAA  alloc]init]  buenngzhijieDiaoYong2];
 */
    
}
#pragma mark ===
- (UIWindow *)lastObjectWindow{
    if (!_lastObjectWindow) {
        _lastObjectWindow  = [[UIApplication sharedApplication].windows lastObject];
    }
    return _lastObjectWindow;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
  
    [self initializeUserInterface];
    //UITabBar背景颜色
    [[UITabBar appearance] setBackgroundColor:CC_Brown_C];
    //UITabBarItem文本色
    self.tabBar.tintColor = CC_Red_Drak_A;//点击状态
    self.tabBar.unselectedItemTintColor = [UIColor lightGrayColor];//普通未点击状态
    [self initAdminDatas];
    
}

- (void)initializeUserInterface{
    
    AllStockRoomThingsShowVC *homeMainVC = [[AllStockRoomThingsShowVC alloc]init];
    ImorExOrderMainVC *managerMainVC = [[ImorExOrderMainVC alloc]init];
    MyVC *personMainVC = [[MyVC alloc]init];
    
    NSArray *vcArr = @[homeMainVC,managerMainVC,personMainVC];
    self.vSavecArr = vcArr.mutableCopy;
    NSArray *vcNavTitles = @[@"首页",@"出入库",@"我的"];
    NSMutableArray * navs = [@[]mutableCopy];
    NSArray *normalImgs = @[@"tab_home_gray",@"tab_tongji_gray",@"tab_my_gray"];
    NSArray *selectImgs = @[@"tab_home_blue",@"tab_tongji_blue",@"tab_my_blue"];
    
    [vcArr enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        vc.title = vcNavTitles[idx];
        //vc.view.backgroundColor = [UIColor whiteColor];//各vc颜色Did前就是这个颜色了
        vc.view.backgroundColor = CC_Brown_D;
        //原色
        /**
         vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:vcNavTitles[idx]
                                                      image:[[UIImage imageNamed:normalImgs[idx]]
                                                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage: [[UIImage imageNamed:selectImgs[idx]]
                                                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
         */
        //自定色tint
        UIImage *selectedImg = [[UIImage imageNamed:selectImgs[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage *selectedImg_TintColor = [selectedImg imageWithTintColor:CC_Red_Drak_A renderingMode:UIImageRenderingModeAlwaysOriginal];
        
        vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:vcNavTitles[idx]
                                                     image:[[UIImage imageNamed:normalImgs[idx]]
                                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                             selectedImage: selectedImg_TintColor];
        
       
        /* 统一配置导航控制器 */
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self navColorSetWithNav:nav];
        //返回按钮文本配置
        [vc.navigationItem setBackButtonTitle:@""];
//        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//        backBtn.title = @"";
//        nav.navigationItem.backBarButtonItem = backBtn;
        [navs addObject:nav];
    }];
    self.viewControllers = navs;//导航控制器 关联上 标签控制器
    self.selectedIndex = TabBarSubVc_Num_ManagerPage;
    self.oldSelectIndex =  self.selectedIndex;
}


- (void)navColorSetWithNav:(UINavigationController *)navc{//颜色配置
    [navc.navigationBar setTranslucent:NO];//不透明
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f],
                             NSKernAttributeName:@(4.0),
                             NSForegroundColorAttributeName:CC_Red_Drak_A};//字体大小 间距 颜色
    //0
    if (@available(iOS 13.0, *)) { //iOS 15 之后 因为 api 是从13出的
        UINavigationBarAppearance *appearance = UINavigationBarAppearance.new;
        appearance.backgroundColor = CC_Brown_C;//导航栏颜色
        appearance.titleTextAttributes = attDic;//标题颜色
        
        navc.navigationBar.standardAppearance = appearance;
        navc.navigationBar.scrollEdgeAppearance = appearance;
    }else{
        // iOS 15 之前
        // 如果设置了背景图片为空图片,必须要禁用穿透效果,才能看到 barTintColor, self.navigationBar.translucent = NO
        navc.navigationBar.barTintColor = CC_Brown_C;//  navigationBar.subviews[0] ;//导航栏颜色
        navc.navigationBar.titleTextAttributes = attDic;//标题颜色
    }
    //1导航栏控件颜色
    navc.navigationBar.tintColor = CC_Red_Drak_A;
    
    
    
    
//    //2[导航栏透明 -- 隐藏分隔线](设置后 之前的背景色和文本色会变)
//    // 法二 背景色置空 + 阴影图片置空
//    // 在 iOS 15 适配了导航栏时需要显式标明 shadowColor(在 shadowImage 为 nil 时，shadowColor 生效)，故虽已经隐藏了分割线，但导航栏下方仍会出现类似分割线的阴影
//    // 解决方案：需手动标明 shadowColor 为 clearColor 或 nil
//    [navc.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [navc.navigationBar setShadowImage:[UIImage new]];
//    if (@available(iOS 13.0, *)) { // iOS15 后加入这段代码 因为 api 是从13出的
//        UINavigationBarAppearance *appearance = UINavigationBarAppearance.new;
//        appearance.shadowColor = UIColor.clearColor;
//        navc.navigationBar.standardAppearance = appearance;
//        navc.navigationBar.scrollEdgeAppearance = appearance;
//    }else{
//        // 法一 navigationContentView 透明
//        // 参考：《UINavgationBar全透明一行代码实现/ 任意颜色》
//        // 但在 iOS 15 适配了导航栏后，设置alpha的方法会使适配无效
//        navc.navigationBar.subviews[0].alpha = 0;
//    }
}
- (void)navBackColorClearn{//透明
    [self.navigationController.navigationBar setTranslucent:YES];
}

#pragma mark ====
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController API_AVAILABLE(ios(3.0)){
    self.oldSelectIndex = tabBarController.selectedIndex;
    // 记录之前选择的selectedIndex
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    DLog(@"点击切换tabbbar - %ld",tabBarController.selectedIndex );
    if (tabBarController.selectedIndex == TabBarSubVc_Num_ShowHomePage) {
    }
}
 
@end
