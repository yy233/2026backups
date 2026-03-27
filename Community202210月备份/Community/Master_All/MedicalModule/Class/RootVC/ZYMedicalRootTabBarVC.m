//
//  ZYMedicalRootTabBarVC.m
//  Community
//
//  Created by ZY on 2021/11/30.
//

#import "ZYMedicalRootTabBarVC.h"
#import "ZYPensionMainVC.h"
#import "ZYHealthDataVC.h"
#import "ZYMyPensionVC.h"
#import "ZYCustomPlusButton.h"

@interface ZYMedicalRootTabBarVC ()

@end

@implementation ZYMedicalRootTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 / 255.0 green:174 / 255.0 blue:175 / 255.0 alpha:1]} forState:UIControlStateSelected];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    BOOL isHavePension = NO;
    for (UIViewController *tempVc in self.navigationController.viewControllers) {
        if ([tempVc isKindOfClass:[ZYPensionMainVC class]] || [tempVc isKindOfClass:[ZYHealthDataVC class]] || [tempVc isKindOfClass:[ZYMyPensionVC class]]) {
            isHavePension = YES;
        }
    }
    if (!isHavePension) {
        [[UITabBar appearance] setBackgroundColor:[ZYThemeManager shareManager].contentViewBackgroundThemeColor];
        [[UITabBar appearance] setBarTintColor:[ZYThemeManager shareManager].contentViewBackgroundThemeColor];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor zy_colorWithHexString:@"#237CFA"]} forState:UIControlStateSelected];
    }
}

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    [ZYCustomPlusButton registerPlusButton];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MedicalControllers" ofType:@"plist"];
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *VCs = [NSMutableArray array];
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSDictionary *plistDict in plistArray) {
        NSString *className = plistDict[@"className"];
        NSString *title = plistDict[@"title"];
        NSString *iconNameNormal = plistDict[@"iconNameNormal"];
        NSString *iconNameHighlight = plistDict[@"iconNameHighlight"];
        // 通过类名获取类
        Class class = NSClassFromString(className);
        // 通过类创建对象
        UIViewController *vc = [[class alloc] init];
        // 创建导航栏视图控制器
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
        // 设置导航栏为不透明
        naviVC.navigationBar.translucent = NO;
        // 隐藏导航栏
        [naviVC setNavigationBarHidden:YES animated:YES];
        // 将导航栏视图控制器添加到数组中
        [VCs addObject:naviVC];
        NSDictionary *tabBarItemAttribute = @{CYLTabBarItemTitle : title, CYLTabBarItemImage : iconNameNormal, CYLTabBarItemSelectedImage : iconNameHighlight};
        [attributes addObject:tabBarItemAttribute];
    }
    self = [ZYMedicalRootTabBarVC tabBarControllerWithViewControllers:[VCs copy] tabBarItemsAttributes:[attributes copy]];

    return self;
}

@end
