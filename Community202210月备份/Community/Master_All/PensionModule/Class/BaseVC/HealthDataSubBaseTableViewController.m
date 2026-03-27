//
//  HealthDataSubBaseTableViewController.m
//  Community
//
//  Created by 余莹 on 2021/11/26.
//

#import "HealthDataSubBaseTableViewController.h"

@interface HealthDataSubBaseTableViewController ()

@end

@implementation HealthDataSubBaseTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBarStyleWithColor];
    [self setupNavigationBarWithBackItemNoTitle];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupNavigationBarWithBackItemNoTitle{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (@available(iOS 14.0, *)) {
        self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDarkContent;
}

#pragma mark - navigationBar默认背景色
- (void)setupNavigationBarStyleWithColor {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor whiteColor];
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - SOS navigationBar的颜色
- (void)setupNavigationBarStyleWithSOSColor {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor zy_colorWithHexString:@"#36C8C1"];
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor zy_colorWithHexString:@"#36C8C1"]] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - SOS navigationBar的颜色 大字体
- (void)setupNavigationBarStyleWithSOSBoldTextColor {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:21.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor zy_colorWithHexString:@"#36C8C1"];
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor zy_colorWithHexString:@"#36C8C1"]] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 改变浅色navigationBar背景色
- (void)navigationBarWhiteStyleWithColorChanged:(UIColor *)color {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = color;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 改变深色navigationBar背景色
- (void)navigationBarDarkStyleWithColorChanged:(UIColor *)color {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = color;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 设置navigationBar为透明色
- (void)setupNavigationBarTransparentStyle {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 清除navigationBar的颜色
- (void)setupNavigationBarClearTransparentStyle {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor clearColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 隐藏navigationBar
- (void)hiddenNavigationBar {
   
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)notHiddenNavigationBar {
  
   [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 跳转
- (void)pushVc:(id)vc {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)popVc:(id)vc {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popToViewController:vc animated:YES];
    });
}

- (void)popVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


@end
