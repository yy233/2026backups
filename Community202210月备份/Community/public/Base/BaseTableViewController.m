//
//  BaseTableViewController.m
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import "BaseTableViewController.h"
#define MainBackgroundColor  Y_RGBA(0, 21, 52, 1)

@interface BaseTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarWithBackNoTitle];//返回按钮
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [ThemeManager shareManager].mainContentLineColor; //分割线
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    [self initNoticeThemeIsChange];
    [self initData];
    [self emptyInfoInit];//空占位图文
    //去掉will 直接掉基础颜色20011013
    [self setupNavigationBarStyleWithMainColor];
    [self vcSelfBackgroundColorOfThemeColorVcBack];
}
- (void)vcSelfBackgroundColorOfThemeColorVcBack{
    self.tableView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        //BaseTableViewController 改后没有调用backviewcolor
        [self vcSelfBackgroundColorOfThemeColorVcBack];
    });
 }


//- (void)setupNavigationBarWhiteStyle {
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[UIColor blackColor]
//    }];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor whiteColor]]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[UIColor blackColor]
//    }];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
////    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setTranslucent:NO];
//}

- (void)setupNavigationBarWhiteStyle {
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]
    };
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]
    }];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor whiteColor];;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor: [UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    }
    
}

//- (void)setupNavigationBarTransparentStyle {
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[UIColor whiteColor]
//    }];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTranslucent:YES];
//}

- (void)setupNavigationBarTransparentStyle {
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor clearColor];
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor: [UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    }
    
    
}

//主题色 深色不变 浅色主题时 nav非纯白
//- (void)setupNavigationBarStyleWithMainColor{  //更改透明为主题色
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor
//    }];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].themeColorVCBackViewColor] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
//    [self.navigationController.navigationBar setTranslucent:NO];
////    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forBarMetrics:UIBarMetricsDefault];//大面积色
////    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor brownColor]]];//返回按钮img？
////    [self.navigationController.navigationBar setBarTintColor:[UIColor purpleColor]];//无
////    [self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];////返回按钮img？
////    [self.navigationController.navigationBar setBackgroundColor:[ThemeManager shareManager].themeColorVCBackViewColor];//小背景色
//
//}
- (void)setupNavigationBarStyleWithMainColor{  //更改透明为主题色 //主题色 深色不变 浅色主题时 nav为非白色
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].themeColorVCBackViewColor] forBarMetrics:UIBarMetricsDefault];
    }
}

//主题色 深色不变 浅色主题时 nav为白色
//- (void)setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw{
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor
//    }];
//    if ([ThemeManager shareManager].type==ThemeType_Drak) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].themeColorVCBackViewColor] forBarMetrics:UIBarMetricsDefault];
//    }else{
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//    }
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
//    [self.navigationController.navigationBar setTranslucent:NO];
//
//}

- (void)setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw{
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor
    };
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    UIColor *backColor = nil;
    if ([ThemeManager shareManager].type==ThemeType_Drak) {
        backColor = [ThemeManager shareManager].themeColorVCBackViewColor;
    }else{
        backColor = [UIColor whiteColor];
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:backColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = backColor;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor: backColor] forBarMetrics:UIBarMetricsDefault];
    }
   
}

//- (void)setupNavigationBarBlackStyle {
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[UIColor whiteColor]
//    }];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MainBackgroundColor] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:MainBackgroundColor]];
//    [self.navigationController.navigationBar setBackgroundColor:MainBackgroundColor];
//    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTranslucent:NO];
//}

- (void)setupNavigationBarBlackStyle {
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MainBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:MainBackgroundColor]];
    [self.navigationController.navigationBar setBackgroundColor:MainBackgroundColor];
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = MainBackgroundColor;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor: MainBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    }
   
}

#pragma mark == 主题色 notice

- (void)initNoticeThemeIsChange{
    Y_NSNotificationCenter_Creat_NameAction(NOTICE_NAME_ThemeISChanged, themeIsChange:)
}
- (void)themeIsChange:(NSNotification*)notice{
    NSLog(@"----BaseTableView VC---themeIsChange----");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        [self setupNavigationBarStyleWithMainColor];
        [self.tableView reloadData];//刷新cell
    });
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(NOTICE_NAME_ThemeISChanged)
}
#pragma mark ==
- (void)initData{
    
}
- (void)setupNavigationBarWithBackNoTitle{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

#pragma mark === getter
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark ==
- (void)pushVc:(id)vc{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}
- (void)popVC{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


//- (void)setupNavigationBarWhiteTextColorWithBackViewCustomColor:(UIColor *)customColor{
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage  imageWithColor:customColor] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor: [UIColor whiteColor]];
//    [self.navigationController.navigationBar setTranslucent:NO];
//}

- (void)setupNavigationBarWhiteTextColorWithBackViewCustomColor:(UIColor *)customColor{
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                             NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage  imageWithColor:customColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor: [UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = customColor;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor: customColor] forBarMetrics:UIBarMetricsDefault];
    }
   
}

- (void)reloadRowNum:(NSInteger)rowNum{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark ==  无数据占位 协议
- (void)emptyInfoInit{
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}
#pragma mark - 文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *emptyTitle = @"暂无数据";
    NSDictionary *attributs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor
    };
    return [[NSAttributedString alloc]initWithString:emptyTitle attributes:attributs];
}
#pragma mark - 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"Nomal_ZeroWidthIcon"];//Nomal_ZeroWidthIcon
}
#pragma mark - 中心位置
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.tableView.tableHeaderView.height * 0.5;
}
// 是否允许滚动 ｜有数据能正常下拉刷新 空数据时 无法下拉动作 设置yes即可正常
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

#pragma mark -  无数据占位 end
@end
