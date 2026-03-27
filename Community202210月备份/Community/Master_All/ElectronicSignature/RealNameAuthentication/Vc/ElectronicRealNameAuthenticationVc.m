//
//  RealNameAuthenticationVc.m
//  Community
//
//  Created by 余莹 on 2021/1/26.
//

#import "ElectronicRealNameAuthenticationVc.h"
#import "ElectroniNewRealNameAuthenticationCardVc.h"
#import "ElectronicNotRealNameAuthenticationView.h"
@interface ElectronicRealNameAuthenticationVc ()
@property (nonatomic,strong) ElectronicNotRealNameAuthenticationView *notAuthenticationView;
@end

@implementation ElectronicRealNameAuthenticationVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
//
#pragma mark ==
- (void)goToAuthenticatBtnAction{
    DLog(@"去认证");
    ElectroniNewRealNameAuthenticationCardVc *newNameAuthenticationVc = [[ElectroniNewRealNameAuthenticationCardVc alloc]init];
    [self pushVc:newNameAuthenticationVc];
}

//
- (void)initView{
    [self.view addSubview:self.notAuthenticationView];
    UIColor *beginColor = Y_RGBA(57, 69, 107, 1);
    UIColor *endColor = Y_RGBA(116, 143, 181, 1);
    CGSize size = CGSizeMake(Screen_W, Screen_H);
    self.view.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
}
//
- (ElectronicNotRealNameAuthenticationView *)notAuthenticationView{
    if (!_notAuthenticationView) {
        _notAuthenticationView  = [[ElectronicNotRealNameAuthenticationView alloc]initWithFrame:CGRectZero];
        [_notAuthenticationView.goToAuthenticatBtn addTarget:self action:@selector(goToAuthenticatBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _notAuthenticationView;
}
@end
 
