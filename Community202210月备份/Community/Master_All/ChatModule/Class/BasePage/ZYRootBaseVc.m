//
//  ZYRootBaseVc.m
//  Community
//
//  Created by ZY on 2021/4/20.
//

#import "ZYRootBaseVc.h"

@interface ZYRootBaseVc () <UIViewControllerTransitioningDelegate>

@end

@implementation ZYRootBaseVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *beginColor = Y_RGBA(86, 123, 243, 1);
    UIColor *endColor = Y_RGBA(59, 143, 253, 1);
    self.topView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(kScreenW, 400) direction:IHGradientChangeDirectionLevel startColor:beginColor endColor:endColor];
    
    // 添加返回手势
    self.transitioningDelegate = self;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].windows.lastObject].x / [UIApplication sharedApplication].windows.lastObject.bounds.size.width);
    
    if ((edgePan.edges == UIRectEdgeLeft) && (progress > 0.2)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)backButtonClicked:(UIButton *)sender {
}
#pragma mark ===
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavbackBtnTitleNilAndHidden];
}
#pragma mark == nav
- (void)setNavbackBtnTitleNilAndHidden{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBarHidden = YES;//混的vc 处理返回后的
}

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
}



@end
