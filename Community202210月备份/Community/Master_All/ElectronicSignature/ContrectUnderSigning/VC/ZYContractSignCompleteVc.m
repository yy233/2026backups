//
//  ZYContractSignCompleteVc.m
//  Community
//
//  Created by ZY on 2021/5/26.
//

#import "ZYContractSignCompleteVc.h"
#import "IssueHouseQianYueManagerVC.h"
#import "ZYContractSignCompleteView.h"

@interface ZYContractSignCompleteVc ()

@property (nonatomic, strong) ZYContractSignCompleteView *contractSignCompleteView;

@end

@implementation ZYContractSignCompleteVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发起成功";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.rentSignInfoModel.assetId.length > 0) {
        NSMutableArray *vcs = [NSMutableArray array];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[PersonCenterVcLate class]]) {
                [vcs addObject:vc];
            }
            if ([vc isKindOfClass:[IssueHouseQianYueManagerVC class]]) {
                [vcs addObject:vc];
            }
            if ([vc isKindOfClass:[ZYContractSignCompleteVc class]]) {
                [vcs addObject:vc];
            }
        }
        self.navigationController.viewControllers = [vcs copy];
    }else {
        NSMutableArray *mVc = [NSMutableArray array];
        NSMutableArray *vcArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[ElectronicSignatureVC class]]) {
                [mVc addObject:vc];
            }
            if ([vc isKindOfClass:[ZYContractSignCompleteVc class]]) {
                [mVc addObject:vc];
            }
        }
        self.navigationController.viewControllers = [mVc copy];
    }
}

- (void)setUI {
    [self.view addSubview:self.contractSignCompleteView];
    [_contractSignCompleteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contractSignCompleteView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYContractSignCompleteView *)contractSignCompleteView {
    if (!_contractSignCompleteView) {
        _contractSignCompleteView = [[NSBundle mainBundle] loadNibNamed:@"ZYContractSignCompleteView" owner:nil options:nil].lastObject;
        [_contractSignCompleteView.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _contractSignCompleteView;
}

#pragma mark - 处理点击事件
- (void)okButtonClicked {
    
    [self popVC];
}

@end
