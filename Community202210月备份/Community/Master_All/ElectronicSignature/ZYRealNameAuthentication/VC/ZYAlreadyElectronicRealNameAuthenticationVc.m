//
//  ZYAlreadyElectronicRealNameAuthenticationVc.m
//  Community
//
//  Created by ZY on 2021/4/14.
//

#import "ZYAlreadyElectronicRealNameAuthenticationVc.h"
#import "ZYAlreadyElectronicRealNameAuthenticationView.h"

@interface ZYAlreadyElectronicRealNameAuthenticationVc ()

@property (nonatomic, strong) ZYAlreadyElectronicRealNameAuthenticationView *authenticationView;

@end

@implementation ZYAlreadyElectronicRealNameAuthenticationVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarTransparentStyle];
}

- (void)setUI {
    
    [self.view addSubview:self.authenticationView];
    [_authenticationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_authenticationView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYAlreadyElectronicRealNameAuthenticationView *)authenticationView {
    if (!_authenticationView) {
        _authenticationView = [[NSBundle mainBundle] loadNibNamed:@"ZYAlreadyElectronicRealNameAuthenticationView" owner:nil options:nil].lastObject;
        [_authenticationView.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _authenticationView;
}

#pragma mark - 处理点击事件
- (void)backButtonClicked {
    
    [self popVC];
}

@end
