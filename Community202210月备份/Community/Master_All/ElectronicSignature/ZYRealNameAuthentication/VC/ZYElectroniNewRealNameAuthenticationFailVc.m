//
//  ZYElectroniNewRealNameAuthenticationFailVc.m
//  Community
//
//  Created by ZY on 2022/4/29.
//

#import "ZYElectroniNewRealNameAuthenticationFailVc.h"
#import "ZYElectroniNewRealNameAuthenticationFailView.h"

@interface ZYElectroniNewRealNameAuthenticationFailVc () <ZYElectroniNewRealNameAuthenticationFailViewDelegate>

@property (nonatomic,strong) ZYElectroniNewRealNameAuthenticationFailView *failView;

@end

@implementation ZYElectroniNewRealNameAuthenticationFailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:Color_38BlueColor];
}

#pragma mark - 懒加载
- (ZYElectroniNewRealNameAuthenticationFailView *)failView {
    if (!_failView) {
        _failView = [[NSBundle mainBundle] loadNibNamed:@"ZYElectroniNewRealNameAuthenticationFailView" owner:nil options:nil].lastObject;
        _failView.delegate = self;
    }
    
    return _failView;
}

#pragma mark - 设置UI
- (void)initView{
    [self.view addSubview:self.failView];
    [_failView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_failView.superview);
    }];
}

#pragma mark - ZYElectroniNewRealNameAuthenticationFailViewDelegate
- (void)againButtonEvent {
    [self popVC];
}

@end
