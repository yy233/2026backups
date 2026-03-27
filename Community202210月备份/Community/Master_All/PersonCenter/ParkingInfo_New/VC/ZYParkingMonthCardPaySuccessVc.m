//
//  ZYParkingMonthCardPaySuccessVc.m
//  Community
//
//  Created by ZY on 2022/5/9.
//

#import "ZYParkingMonthCardPaySuccessVc.h"
#import "ZYParkingMonthCardRenewalVc.h"
#import "ZYParkingAddMonthCardVc.h"
#import "ZYParkingMonthCardPayDetailVc.h"
#import "ZYParkingMonthCardPaySuccessView.h"

@interface ZYParkingMonthCardPaySuccessVc () <ZYParkingMonthCardPaySuccessViewDelegate>

@property (nonatomic, strong) ZYParkingMonthCardPaySuccessView *successView;

@end

@implementation ZYParkingMonthCardPaySuccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付结果";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].viewBackgroundThemeColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *vcsArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ZYParkingMonthCardRenewalVc class]]) {
            [vcsArr removeObject:vc];
        }
        if ([vc isKindOfClass:[ZYParkingAddMonthCardVc class]]) {
            [vcsArr removeObject:vc];
        }
        if ([vc isKindOfClass:[ZYParkingMonthCardPayDetailVc class]]) {
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
- (ZYParkingMonthCardPaySuccessView *)successView {
    if (!_successView) {
        _successView = [[NSBundle mainBundle] loadNibNamed:@"ZYParkingMonthCardPaySuccessView" owner:nil options:nil].lastObject;
        _successView.delegate = self;
    }
    
    return _successView;
}

#pragma mark - ZYParkingMonthCardPaySuccessViewDelegate
- (void)okButtonEvent {
    [self popVC];
}

@end
