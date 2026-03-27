//
//  ContrectSignSuccessVc.m
//  Community
//
//  Created by 余莹 on 2021/1/29.
//

#import "ContrectSignSuccessVc.h"
#import "ZYContrectManageVC.h"
#import "ContrectAllListVC.h"
#import "IssueHouseQianYueManagerVC.h"
#import "ZYContrectSignSuccessView.h"

@interface ContrectSignSuccessVc ()

@property (nonatomic, strong) ZYContrectSignSuccessView *successView;

@end

@implementation ContrectSignSuccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签署成功";
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *mVc = [NSMutableArray array];
    NSMutableArray *vcArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in vcArr) {
        if ([vc isKindOfClass:[ElectronicSignatureVC class]]) {
            [mVc addObject:vc];
        }
        if ([vc isKindOfClass:[CommunityManagementMainVcLate class]]) {
            [mVc addObject:vc];
        }
        if ([vc isKindOfClass:[PersonCenterVcLate class]]) {
            [mVc addObject:vc];
        }
        if ([vc isKindOfClass:[ZYContrectManageVC class]]) {
            [mVc addObject:vc];
        }
        if ([vc isKindOfClass:[ContrectAllListVC class]]) {
            [mVc addObject:vc];
        }
        if ([vc isKindOfClass:[IssueHouseQianYueManagerVC class]]) {
            [mVc addObject:vc];
        }
        if ([vc isKindOfClass:[ContrectSignSuccessVc class]]) {
            [mVc addObject:vc];
        }
    }
    self.navigationController.viewControllers = [mVc copy];
}

- (void)initView{
    
    [self.view addSubview:self.successView];
    [_successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_successView.superview);
    }];
}
 
- (void)okButtonClicked {
    
    [self popVC];
}

- (ZYContrectSignSuccessView *)successView {
    if (!_successView) {
        _successView = [[NSBundle mainBundle] loadNibNamed:@"ZYContrectSignSuccessView" owner:nil options:nil].lastObject;
        [_successView.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _successView;
}

@end
