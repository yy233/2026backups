//
//  ElectroniNewRealNameAuthenticationSuccessVc.m
//  Community
//
//  Created by 余莹 on 2021/3/9.
//

#import "ZYElectroniNewRealNameAuthenticationSuccessVc.h"
#import "ZYElectroniNewRealNameAuthenticationSuccessView.h"
#import "ZYElectronicRealNameAuthenticationVc.h"
#import "ZYElectroniNewRealNameAuthenticationCardVc.h"
#import "ZYElectroniNewRealNameAuthenticationFaceVc.h"

@interface ZYElectroniNewRealNameAuthenticationSuccessVc ()
@property (nonatomic,strong) ZYElectroniNewRealNameAuthenticationSuccessView *selfView;
@end

@implementation ZYElectroniNewRealNameAuthenticationSuccessVc

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"实名认证";
    [self initView];  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:Color_38BlueColor];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ZYElectronicRealNameAuthenticationVc class]]) {
            [vcs removeObject:vc];
        }
        if ([vc isKindOfClass:[ZYElectroniNewRealNameAuthenticationCardVc class]]) {
            [vcs removeObject:vc];
        }
        if ([vc isKindOfClass:[ZYElectroniNewRealNameAuthenticationCardVcLate class]]) {//只有身份证号和名字的实名第一页录入vc
            [vcs removeObject:vc];
        }
        if ([vc isKindOfClass:[ZYElectroniNewRealNameAuthenticationFaceVc class]]) {
            [vcs removeObject:vc];
        }
    }
    self.navigationController.viewControllers = [vcs copy];
}
- (void)initView{
    [self.view addSubview:self.selfView];
}
- (ZYElectroniNewRealNameAuthenticationSuccessView *)selfView{
    if (!_selfView) {
        _selfView = [[ZYElectroniNewRealNameAuthenticationSuccessView alloc]initWithFrame:self.view.frame];
        [_selfView.footerView.footerBtn addTarget:self action:@selector(footerSuccessAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selfView;
}
#pragma mark == 实名认证成功
- (void)footerSuccessAction{

    [self popVC];
}
@end
