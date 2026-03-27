//
//  ZYCommunityFairIssueSuccessVc.m
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import "ZYCommunityFairIssueSuccessVc.h"
#import "ZYCommunityFairIssueVc.h"
#import "ZYCommunityFairIssueSuccessView.h"

@interface ZYCommunityFairIssueSuccessVc () <ZYCommunityFairIssueSuccessViewDelegate>

@property (nonatomic, strong) ZYCommunityFairIssueSuccessView *successView;

@end

@implementation ZYCommunityFairIssueSuccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *vcsArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ZYCommunityFairIssueVc class]]) {
            [vcsArr removeObject:vc];
        }
    }
    self.navigationController.viewControllers = [vcsArr copy];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.successView];
    [_successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_successView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYCommunityFairIssueSuccessView *)successView {
    if (!_successView) {
        _successView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairIssueSuccessView" owner:nil options:nil].lastObject;
        _successView.delegate = self;
    }
    
    return _successView;
}

#pragma mark - ZYCommunityFairIssueSuccessViewDelegate
- (void)okButtonEvent {
    [self popVC];
}

@end
