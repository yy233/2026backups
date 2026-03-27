//
//  ZYRentSigningPayCompleteVC.m
//  Community
//
//  Created by ZY on 2021/9/14.
//

#import "ZYRentSigningPayCompleteVC.h"
#import "ZYRentSigningPayVC.h"
#import "ZYRentSigningPayCompleteView.h"
#import "ZYRentSigningPayBottomView.h"

@interface ZYRentSigningPayCompleteVC () <ZYRentSigningPayBottomViewDelegate>

@property (nonatomic, strong) ZYRentSigningPayCompleteView *completeView;

@property (nonatomic, strong) ZYRentSigningPayBottomView *bottomView;

@end

@implementation ZYRentSigningPayCompleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付成功";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isMemberOfClass:[ZYRentSigningPayVC class]]) {
            [vcs removeObject:vc];
        }
    }
    self.navigationController.viewControllers = [vcs copy];
}

- (void)setUI {
    
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(100 + button_bottom_height);
    }];
    
    [self.view addSubview:self.completeView];
    [_completeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_completeView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYRentSigningPayCompleteView *)completeView {
    if (!_completeView) {
        _completeView = [[NSBundle mainBundle] loadNibNamed:@"ZYRentSigningPayCompleteView" owner:nil options:nil].lastObject;
        _completeView.priceLabel.text = [NSString stringWithFormat:@"￥%@", self.totalPay];
    }
    
    return _completeView;
}

- (ZYRentSigningPayBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYRentSigningPayBottomView" owner:nil options:nil].lastObject;
        [_bottomView.okButton setTitle:@"签署密码" forState:UIControlStateNormal];
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

#pragma mark - ZYRentSigningPayBottomViewDelegate
- (void)okButtonEvent {
    
    NSLog(@"签署密码");
    [self popVC];
}

@end
