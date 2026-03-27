//
//  BaseHaveTableViewViewController.m
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import "BaseHaveTableViewViewController.h"

@interface BaseHaveTableViewViewController () <UITableViewDelegate,UITableViewDataSource>
@end

@implementation BaseHaveTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarWithBackNoTitle];//返回按钮
    [self setupNavigationBarStyleWithMainColor];//导航
    [self initNoticeThemeIsChange];//主题色通知
    [self initView];
    [self initData];
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
//

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


#pragma mark == 主题色
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        [self setupNavigationBarStyleWithMainColor];
    });
 }
- (void)initNoticeThemeIsChange{
    Y_NSNotificationCenter_Creat_NameAction(NOTICE_NAME_ThemeISChanged, themeIsChange:)
}
- (void)themeIsChange:(NSNotification*)notice{
    NSLog(@"----BaseTableView VC---themeIsChange----");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        [self setupNavigationBarStyleWithMainColor];
    });
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(NOTICE_NAME_ThemeISChanged)
}

- (void)setupNavigationBarWithBackNoTitle{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark == view
- (void)initView{
    [self.view addSubview:self.tableView];
}
#pragma mark == data
- (void)initData{
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
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
#pragma mark === getter
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}
- (UITableView *)tableView{
    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(16, 0, Screen_W-32, Screen_H-KNavBarHeight-20) style:UITableViewStyleGrouped];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(16, 0, Screen_W-32, Screen_H-KNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = [ThemeManager shareManager].mainContentLineColor; //分割线
        _tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    }
    return _tableView;
}

@end
