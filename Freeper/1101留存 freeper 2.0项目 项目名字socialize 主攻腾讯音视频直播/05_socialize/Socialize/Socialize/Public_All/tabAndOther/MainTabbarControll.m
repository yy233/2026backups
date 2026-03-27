//
//  MainTabbarControll.m
//  Socialize
//
//  Created by 余莹 on 2023/5/10.
//

#import "MainTabbarControll.h"
#import "FaXianWebVc.h"
#import "ZhiBoMainVc.h"
#import "FaXianUseNavController.h"

@interface MainTabbarControll ()

@end

@implementation MainTabbarControll

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];

}

- (void)aaaaa{
//    [[UITabBarItem appearance] ]
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    NSLog(@"TabbarCintroll ------  TabbarCintroll   initializeUserInterface ");
    [self nowColorSetWithThemeChange]; 
}
- (void)nowColorSetWithThemeChange{
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_dark]){
        UIColor *dC = [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Drak_Str];
        //背景
        [[UITabBar appearance] setBackgroundColor: dC];
        self.tabBar.barTintColor = dC;
        //文本
        self.tabBar.tintColor = Color_Socialize_GreenColor;
        self.tabBar.unselectedItemTintColor = Color_245Gray;
    }else{
        UIColor *lC = [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Light_Str];
        //背景
        [[UITabBar appearance] setBackgroundColor: lC];
        self.tabBar.barTintColor = lC;
        //文本
        self.tabBar.tintColor = Color_Socialize_GreenColor;
        self.tabBar.unselectedItemTintColor = Color_51BlackColor;

    }
}

- (void)initializeUserInterface{
    ImMainChatListViewController *homeMainVC = [[ImMainChatListViewController alloc]init];
//    RecommendViewController *recomaMainVC = [[RecommendViewController alloc]init];//推荐页更改
    TUiJianWebVc *recomaMainVC = [[TUiJianWebVc alloc]init];
//    MyDapViewController *discoverMainVC = [[MyDapViewController alloc]init];//发现页本地跳转用
    FaXianWebVc *discoverMainVC = [[FaXianWebVc alloc]init];
//    ZhiBoMainVc *discoverMainVC = [[ZhiBoMainVc alloc]init];
    MyViewController *myMainvc = [[MyViewController alloc]init];
    NSArray *vcArr = @[homeMainVC,recomaMainVC,discoverMainVC,myMainvc];
 
    
    
//    NSString *chatS = [TextShowWithModelStr textShowWithModelStr: Y_LocaleTypeFile_NSLocalString(@"聊天")];
//    NSString *tuiJianS = [TextShowWithModelStr textShowWithModelStr: Y_LocaleTypeFile_NSLocalString(@"推荐")];
//    NSString *faXianS = [TextShowWithModelStr textShowWithModelStr: Y_LocaleTypeFile_NSLocalString(@"发现")];
//    NSString *wodeS = [TextShowWithModelStr textShowWithModelStr: Y_LocaleTypeFile_NSLocalString(@"我的")];


    
    NSArray *vcNavTitles = @[
        Y_LocaleTypeFile_NSLocalString(@"聊天"),
        Y_LocaleTypeFile_NSLocalString(@"推荐"),
        Y_LocaleTypeFile_NSLocalString(@"发现"),
        Y_LocaleTypeFile_NSLocalString(@"我的")];

    NSMutableArray * navs = [@[]mutableCopy];
    NSArray *normalImgs = @[@"聊天1",@"推荐1",@"发现1",@"我的1"];
    NSArray *selectImgs = @[@"聊天",@"推荐",@"发现",@"我的"];
    
    [vcArr enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        vc.title = vcNavTitles[idx];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:vcNavTitles[idx] image:[[UIImage imageNamed:normalImgs[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage: [[UIImage imageNamed:selectImgs[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        /* 统一配置导航控制器 */
        
        if(idx == 2){
            FaXianUseNavController *nav = [[FaXianUseNavController alloc]initWithRootViewController:vc];
//            WYNavigationController * nav = [[WYNavigationController alloc]initWithRootViewController:vc];//0811发现页使用系统nav 再发现页 本页 调用nav协议判断隐藏#import "WYNavigationController.h"
            [navs addObject:nav];
            UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
            backBtn.title = @"";
            nav.navigationItem.backBarButtonItem = backBtn;
        }else  if(idx == 3){//YBaseNavController my [vc isKindOfClass:[MyViewController class]]
            YBaseNavController *nav = [[YBaseNavController alloc]initWithRootViewController:vc];
            [navs addObject:nav];
            UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
            backBtn.title = @"";
            nav.navigationItem.backBarButtonItem = backBtn;
            
        }else  if(idx <=3){//全员透明nav
            Y_BaseNavigationViewController_ClearnBk *navC = [[Y_BaseNavigationViewController_ClearnBk alloc]initWithRootViewController:vc];
            [navs addObject:navC];
            UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
            backBtn.title = @"";
            navC.navigationItem.backBarButtonItem = backBtn;
        }else{
            Y_BaseNavigationViewController * nav = [[Y_BaseNavigationViewController alloc]initWithRootViewController:vc];
            [navs addObject:nav];
            UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
            backBtn.title = @"";
            nav.navigationItem.backBarButtonItem = backBtn;
        }
       
    }];
    self.viewControllers = navs;//导航控制器 关联上 标签控制器
    self.selectedIndex = 1;
    
  
}
 


@end
