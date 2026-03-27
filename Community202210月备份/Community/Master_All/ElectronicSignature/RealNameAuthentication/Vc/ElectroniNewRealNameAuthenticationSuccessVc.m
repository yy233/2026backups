//
//  ElectroniNewRealNameAuthenticationSuccessVc.m
//  Community
//
//  Created by 余莹 on 2021/3/9.
//

#import "ElectroniNewRealNameAuthenticationSuccessVc.h"
#import "ElectroniNewRealNameAuthenticationSuccessView.h"
@interface ElectroniNewRealNameAuthenticationSuccessVc ()
@property (nonatomic,strong) ElectroniNewRealNameAuthenticationSuccessView *selfView;
@end

@implementation ElectroniNewRealNameAuthenticationSuccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:Color_38BlueColor];
    self.title = @"实名认证";
}
- (void)initView{
    [self.view addSubview:self.selfView];
}
- (ElectroniNewRealNameAuthenticationSuccessView *)selfView{
    if (!_selfView) {
        _selfView = [[ElectroniNewRealNameAuthenticationSuccessView alloc]initWithFrame:self.view.frame];
        [_selfView.footerView.footerBtn addTarget:self action:@selector(footerSuccessAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selfView;
}
#pragma mark == 实名认证成功
- (void)footerSuccessAction{
//    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    for (UIViewController *vc in [self.navigationController viewControllers]) {
        if ([vc isKindOfClass:[ElectronicSignatureVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
        if ([vc isKindOfClass:[CommunityManagementMainVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
        if ([vc isKindOfClass:[PersonCenterVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
@end
