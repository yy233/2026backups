//
//  ZYChatRootTabBarVc.m
//  Community
//
//  Created by ZY on 2021/4/19.
//

#import "ZYChatRootTabBarVc.h"

@interface ZYChatRootTabBarVc ()

@end

@implementation ZYChatRootTabBarVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViewControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UITabBar appearance] setBackgroundColor:[ZYThemeManager shareManager].contentViewBackgroundThemeColor];
    [[UITabBar appearance] setBarTintColor:[ZYThemeManager shareManager].contentViewBackgroundThemeColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor zy_colorWithHexString:@"#237CFA"]} forState:UIControlStateSelected];
}

#pragma mark - 创建子视图控制器
- (void)createViewControllers{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ChatControllers" ofType:@"plist"];
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *VCs = [NSMutableArray array];
    for (NSDictionary *plistDict in plistArray) {
        NSString *className = plistDict[@"className"];
        NSString *title = plistDict[@"title"];
        NSString *iconNameNormal = plistDict[@"iconNameNormal"];
        NSString *iconNameHighlight = plistDict[@"iconNameHighlight"];
        // 通过类名获取类
        Class class = NSClassFromString(className);
        // 通过类创建对象
        UIViewController *vc = [[class alloc] init];
        // 定制tabBarItem
        UIImage *normalImage = [UIImage imageNamed:iconNameNormal];
        UIImage *highlightImage = [UIImage imageNamed:iconNameHighlight];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[highlightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        // 创建导航栏视图控制器
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
        // 设置导航栏为不透明
        naviVC.navigationBar.translucent = NO;
        // 隐藏导航栏
        [naviVC setNavigationBarHidden:YES animated:YES];
        // 将导航栏视图控制器添加到数组中
        [VCs addObject:naviVC];
        //tabbar底部文本指空
        naviVC.tabBarItem.title = nil;
        naviVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        //
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
        backBtn.title = @"";
        naviVC.navigationItem.backBarButtonItem = backBtn;
        naviVC.navigationBarHidden = YES;//此导航不显示
    }
    // 把数组中的导航栏视图控制器付给标签栏视图控制器
    self.viewControllers = VCs;
    // 设置标签栏为不透明
    self.tabBar.translucent = NO;
    
    // 设置tabbar选中时字体的颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:18 / 255.0 green:145 / 255.0 blue:213 / 255.0 alpha:1]} forState:UIControlStateSelected];
    
}

@end
