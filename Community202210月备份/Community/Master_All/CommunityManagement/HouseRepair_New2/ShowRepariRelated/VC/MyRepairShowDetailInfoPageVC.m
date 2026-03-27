//
//  RepairShowDetailInfoPageVC.m
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import "MyRepairShowDetailInfoPageVC.h"
#import "UIFont+YH.h"


#import "MyRepairShowDetailWorkOrderInfoVC.h"
#import "MyRepairShowDetailFollowUpInfoVC.h"


@interface MyRepairShowDetailInfoPageVC ()

@end

@implementation MyRepairShowDetailInfoPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    if (self.model) {
//        self.title = @"报事报修";
//    }else{
//        self.title = self.detailVcTitleStr;
//    }
    self.title = @"报事报修";

    [self setupNavigationBarWithBackItemNoTitle];
   // [self setupNavigationBarWhiteStyle];
    [self changeNavBackColorWithDDndWIsGW];
    self.view.backgroundColor  = [ThemeManager shareManager].themeColorVCBackViewColor;
    NSArray *childVcTitleArr = @[@"工单信息",@"跟进信息"];//work order/Follow up information
    
    MyRepairShowDetailWorkOrderInfoVC *workOrderVc = [[MyRepairShowDetailWorkOrderInfoVC alloc]init];
    workOrderVc.model = self.detailmodel;
    WEAKSELF
    workOrderVc.detailVcCancelOneUpInfo = ^{//取消上报成功 返回列表页 并 刷新列表
        if (isNotNil(weakSelf.detailPopToListWithRefreshBlock)) {
            weakSelf.detailPopToListWithRefreshBlock();
        }
    };
    [self yh_addChildController:workOrderVc title:childVcTitleArr[0]];
    
    MyRepairShowDetailFollowUpInfoVC *followUpVc = [[MyRepairShowDetailFollowUpInfoVC alloc]init];
    followUpVc.model = self.detailmodel; 
    [self yh_addChildController:followUpVc title:childVcTitleArr[1]];
    
    
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
