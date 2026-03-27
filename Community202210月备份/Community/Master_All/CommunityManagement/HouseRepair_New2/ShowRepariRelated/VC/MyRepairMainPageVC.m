//
//  MyRepairMainPageVC.m
//  Community
//
//  Created by 余莹 on 2022/4/11.
// 我的报事报修

#import "MyRepairMainPageVC.h"

#import "MyRepairPageBaseListVC.h"
#import "UIFont+YH.h"
@interface HouseRepairMainPageVC ()

@end

@implementation MyRepairMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的报事";
    [self setupNavigationBarWithBackItemNoTitle];
   // [self setupNavigationBarWhiteStyle];
    [self changeNavBackColorWithDDndWIsGW];
    self.view.backgroundColor  = [ThemeManager shareManager].themeColorVCBackViewColor;
    NSArray *childVcTitleArr = @[@"全部",@"待处理",@"处理中",@"已完成"];
    NSArray *childVcTypeNumArr = @[
        @(MyRepair_PageList_Show_Type_All),
        @(MyRepair_PageList_Show_Type_Will),
        @(MyRepair_PageList_Show_Type_Ing),
        @(MyRepair_PageList_Show_Type_End)];
     for (int i = 0; i < childVcTitleArr.count; i ++) {
         MyRepairPageBaseListVC *vc = [[MyRepairPageBaseListVC alloc] init];
        vc.nowListType = [childVcTypeNumArr[i] integerValue];
        [self yh_addChildController:vc title:childVcTitleArr[i]];
    }
    
    //标签栏上标题字体 间距 布局 指示器 等设置
    self.frameForMenuView = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60);
    
    self.segmentControl.config.layoutType = YHSegmentLayoutType_Left;//标题布局方式
    self.segmentControl.config.progressAnimation = YHSegmentAnimation_None;//动画类型
    self.segmentControl.config.miniItemWidth = ((Screen_W-32-10*childVcTitleArr.count)/childVcTitleArr.count);
    self.segmentControl.config.spaceItemInside = 10;
    //
    self.segmentControl.backgroundColor = [ThemeManager shareManager].themeBackGroundColor;
    self.segmentControl.config.colorNormal = [ThemeManager shareManager].mainTextColor;
    self.segmentControl.config.colorSelected = Color_Blue;
    self.segmentControl.config.fontSelected = [UIFont yh_pfmOfSize:14];
    self.segmentControl.config.fontNormal = [UIFont yh_pfOfSize:14];

    //
    [self yh_reloadController];
}
#pragma mark == nav
- (void)setupNavigationBarWithBackItemNoTitle{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBarHidden = NO;
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
    [self changeNavBackColorWithDDndWIsGW];

}

//深色 重蓝色 ，浅色 非白偏灰色 （就是原本baseNav）
- (void)changeNavBackColorWithDDndWIsGW{
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{
            NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
            NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor
        }];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].themeColorVCBackViewColor] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
        [self.navigationController.navigationBar setTranslucent:NO];
}

@end
