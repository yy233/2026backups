//
//  SmallShopBaseViewController.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "SmallShopBaseViewController.h"

@interface SmallShopBaseViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SmallShopBaseViewController

#pragma mark == nav
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
- (void)setupNavigationBarWhiteStyle {
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]
    }];
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
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarWithBackItemNoTitle];
    [self setupNavigationBarWhiteStyle];
    self.view.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);

}

 
 
#pragma mark == 如果有tableview  则需要处理空数据时的占位背景图片
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self emptyInfoInit];
}
#pragma mark ==  无数据占位 协议
- (void)emptyInfoInit{
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UITableView class]]) {
            self.tableView  = (UITableView *)subview;
           // NSLog(@"baseVc 内views 有 UITableView ");
            if (isNotNil(self.tableView)) {
                self.tableView.emptyDataSetSource = self;
                self.tableView.emptyDataSetDelegate = self;
                [self.tableView reloadData];//vc的子tableView 初始时若没有刷新 就没有初始有数据且数据row=0时的图片文字。
                NSLog(@"baseVc 内views  UITableView 遵循emptyInfoInit  ");
            }else{
               // NSLog(@"baseVc 内views  UITableView 不遵循emptyInfoInit  ");
            }
        }
    }
   
    
}
#pragma mark - 文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *emptyTitle = @"暂无数据";
    NSDictionary *attributs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName:[UIColor blackColor]
    };
    return [[NSAttributedString alloc]initWithString:emptyTitle attributes:attributs];
}
#pragma mark - 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"Nomal_ZeroWidthIcon"];//Nomal_ZeroWidthIcon
}
#pragma mark - 中心位置
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    if (isNotNil(self.tableView)) {
        return self.tableView.tableHeaderView.height * 0.5;
    }else{
        return 0;
    }
}
// 是否允许滚动 ｜有数据能正常下拉刷新 空数据时 无法下拉动作 设置yes即可正常
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

#pragma mark -  无数据占位 end

@end
