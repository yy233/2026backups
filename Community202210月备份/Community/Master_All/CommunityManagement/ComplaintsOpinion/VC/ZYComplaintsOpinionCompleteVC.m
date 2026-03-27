//
//  ZYComplaintsOpinionCompleteVC.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYComplaintsOpinionCompleteVC.h"
#import "ZYComplaintsOpinionCompleteView.h"

@interface ZYComplaintsOpinionCompleteVC ()

@property (nonatomic, strong) ZYComplaintsOpinionCompleteView *complaintsOpinionCompleteView;

@end

@implementation ZYComplaintsOpinionCompleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"反馈成功";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *mVc = [NSMutableArray array];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CommunityManagementMainVcLate class]]) {
            [mVc addObject:vc];
        }
        if ([vc isKindOfClass:[ZYComplaintsOpinionCompleteVC class]]) {
            [mVc addObject:vc];
        }
    }
    self.navigationController.viewControllers = [mVc copy];
}

- (void)setUI {
    
    [self.view addSubview:self.complaintsOpinionCompleteView];
    [_complaintsOpinionCompleteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_complaintsOpinionCompleteView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYComplaintsOpinionCompleteView *)complaintsOpinionCompleteView {
    if (!_complaintsOpinionCompleteView) {
        _complaintsOpinionCompleteView = [[NSBundle mainBundle] loadNibNamed:@"ZYComplaintsOpinionCompleteView" owner:nil options:nil].lastObject;
        [_complaintsOpinionCompleteView.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _complaintsOpinionCompleteView;
}

#pragma mark - 点击事件
// 确认
- (void)okButtonClicked {
    
    NSLog(@"确认");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
