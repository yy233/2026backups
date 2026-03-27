//
//  ZYPensionTopBaseVC.m
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import "ZYPensionTopBaseVC.h"

@interface ZYPensionTopBaseVC () <UIViewControllerTransitioningDelegate>

@end

@implementation ZYPensionTopBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加返回手势
    self.transitioningDelegate = self;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
    
    [self setupNavigationBarClearTransparentStyle];
}

// 返回
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].windows.lastObject].x / [UIApplication sharedApplication].windows.lastObject.bounds.size.width);
    if ((edgePan.edges == UIRectEdgeLeft) && (progress > 0.2)) {
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
