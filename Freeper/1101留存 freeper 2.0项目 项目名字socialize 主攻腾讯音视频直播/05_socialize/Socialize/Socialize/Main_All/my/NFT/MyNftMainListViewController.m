//
//  MyNftListViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import "MyNftMainListViewController.h"
#import "MyCreateListViewController.h"
#import "MyAddListViewController.h"
#import "UIFont+YH.h"

@interface MyNftMainListViewController ()

@end

@implementation MyNftMainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    [self setupNavigationBarWithBackItemNoTitle];
   // [self setupNavigationBarWhiteStyle];
   // [self changeNavBackColorWithDDndWIsGW];
    self.view.backgroundColor  = Color_238GrayColor;
    NSArray *childVcTitleArr = @[@"我创建的",@"我加入的"];
   
    [self yh_addChildController:[[MyCreateListViewController alloc]init] title:childVcTitleArr.firstObject];
    [self yh_addChildController:[[MyAddListViewController alloc]init] title:childVcTitleArr.lastObject];
    //标签栏上标题字体 间距 布局 指示器 等设置
    self.frameForMenuView = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60);
    
    self.segmentControl.config.layoutType = YHSegmentLayoutType_Left;//标题布局方式
    self.segmentControl.config.progressAnimation = YHSegmentAnimation_None;//动画类型
    self.segmentControl.config.miniItemWidth = ((Screen_W-32-10*childVcTitleArr.count)/childVcTitleArr.count);
    self.segmentControl.config.spaceItemInside = 10;
    //
//    self.segmentControl.backgroundColor = [ThemeManager shareManager].themeBackGroundColor;
//    self.segmentControl.config.colorNormal = [ThemeManager shareManager].mainTextColor;
//    self.segmentControl.config.colorSelected = Color_Blue;
    
    self.segmentControl.backgroundColor = [UIColor whiteColor];
    self.segmentControl.config.colorNormal = rgba(102, 102, 102, 1);
    self.segmentControl.config.colorSelected = rgba(51, 51, 51, 1);
    self.segmentControl.config.fontSelected = [UIFont yh_pfmOfSize:16];
    self.segmentControl.config.fontNormal = [UIFont yh_pfOfSize:16];

    //
    [self yh_reloadController];
}
#pragma mark == nav
- (void)setupNavigationBarWithBackItemNoTitle{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    [self.navigationItem setBackBarButtonItem:backBtn];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupNavigationBarWhiteStyle {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]
    }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]
    }];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //更改nav显示
    [self setupNavigationBarWhiteStyle];
}

 
@end
