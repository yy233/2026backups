//
//  BaseTableViewControllerNotNoticeWithUI.m
//  Community
//
//  Created by 余莹 on 2021/1/26.
//

#import "BaseTableViewControllerNotNoticeWithUI.h"

@interface BaseTableViewControllerNotNoticeWithUI () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation BaseTableViewControllerNotNoticeWithUI

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    [self setupNavigationBarWithBackItemNoTitle];
    [self emptyInfoInit];
   
}
#pragma mark == nav
- (void)setupNavigationBarWithBackItemHaveTitleWithStr:(NSString *)titleStr{
    if (isNil(titleStr) || titleStr.length == 0) {
        return;
    }
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = titleStr;
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBarHidden = NO;
}
- (void)setupNavigationBarWithBackItemNoTitle{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
}
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
//
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


//- (void)setupNavigationBarStyleWithMainColor{  //更改透明为主题色
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor};
//    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].themeColorVCBackViewColor] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
//    [self.navigationController.navigationBar setTranslucent:NO];
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


//- (void)setupNavigationBarTransparentStyle {
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
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



//- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomColor:(UIColor *)customColor{
//    self.navigationItem.leftBarButtonItem.tintColor = itemsTintColor;
//    self.navigationItem.rightBarButtonItem.tintColor = itemsTintColor;
//    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:titleTextColor};//
//        [self.navigationController.navigationBar setTintColor: titleTextColor];//?
//    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage  imageWithColor:customColor] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//
//    [self.navigationController.navigationBar setTranslucent:NO];
//}

- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomColor:(UIColor *)customColor{
    self.navigationItem.leftBarButtonItem.tintColor = itemsTintColor;
    self.navigationItem.rightBarButtonItem.tintColor = itemsTintColor;
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                             NSForegroundColorAttributeName:titleTextColor};//
        [self.navigationController.navigationBar setTintColor: titleTextColor];//?
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage  imageWithColor:customColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
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

#pragma mark == 渐变色的nav

//color + size
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomBeginColor:(UIColor *)customBeginColor andBackViewCustomEndColor:(UIColor *)customEndColor andSize:(CGSize)custimSize{
    UIColor *beginColor = customBeginColor;
    UIColor *endColor = customEndColor;
    CGSize size = custimSize;
    UIImage *cImg = [UIImage gradientColorImageFromColors:@[beginColor,endColor] gradientType:GradientTypeLeftToRight imgSize:size];
    [self setupNavigationBarTextColor:[UIColor whiteColor] andBarItemsColor:[UIColor whiteColor] andBackViewCustomImg:cImg];

}
//img
//- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomImg:(UIImage *)cImg{
//    self.navigationItem.leftBarButtonItem.tintColor = itemsTintColor;
//    self.navigationItem.rightBarButtonItem.tintColor = itemsTintColor;
//    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:titleTextColor};//
//        [self.navigationController.navigationBar setTintColor: titleTextColor];//?
//    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
//    //渐变色
//    [self.navigationController.navigationBar setBackgroundImage:cImg forBarMetrics:UIBarMetricsDefault];
//    //
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//
//    [self.navigationController.navigationBar setTranslucent:NO];
//}

- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomImg:(UIImage *)cImg{
    self.navigationItem.leftBarButtonItem.tintColor = itemsTintColor;
    self.navigationItem.rightBarButtonItem.tintColor = itemsTintColor;
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:titleTextColor};//
        [self.navigationController.navigationBar setTintColor: titleTextColor];//?
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
   //渐变色
    [self.navigationController.navigationBar setBackgroundImage:cImg forBarMetrics:UIBarMetricsDefault];
    //
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];

    [self.navigationController.navigationBar setTranslucent:NO];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor colorWithPatternImage:cImg];//图片做背景色
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:cImg forBarMetrics:UIBarMetricsDefault];
    }

}

//聊天的nav渐变色
- (void)setupsetupNavigationBarWithChatVcStyle{
    UIColor *beginColor = Y_ColorWith16FromRGB(0x567BF3);
    UIColor *endColor = Y_ColorWith16FromRGB(0x3B8FFD);
    CGSize size = CGSizeMake(Screen_W, KNavBarHeight);
    UIImage *cImg = [UIImage gradientColorImageFromColors:@[beginColor,endColor] gradientType:GradientTypeLeftToRight imgSize:size];
    [self setupNavigationBarTextColor:[UIColor whiteColor] andBarItemsColor:[UIColor whiteColor] andBackViewCustomImg:cImg];
}
#pragma mark ==
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

@end
