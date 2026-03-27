//
//  RealNameAuthenticationVc.m
//  Community
//
//  Created by 余莹 on 2021/1/26.
//

#import "ZYElectronicRealNameAuthenticationVc.h"
#import "ZYElectroniNewRealNameAuthenticationCardVc.h"
#import "ZYElectronicRealNameAuthenticationTopView.h"
#import "ZYElectronicNotRealNameAuthenticationView.h"
@interface ZYElectronicRealNameAuthenticationVc () <UIGestureRecognizerDelegate>
@property (nonatomic,strong) ZYElectronicRealNameAuthenticationTopView *topView;
@property (nonatomic,strong) ZYElectronicNotRealNameAuthenticationView *notAuthenticationView;
@end

@implementation ZYElectronicRealNameAuthenticationVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self initView];
    if (self.otherShowDetailStr.length != 0) {
        self.notAuthenticationView.detailL.text = self.otherShowDetailStr;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hiddenNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setupNavigationBarClearTransparentStyle];
}

//
#pragma mark ==
- (void)goToAuthenticatBtnAction{
    DLog(@"去认证");
    ZYElectroniNewRealNameAuthenticationCardVc *newNameAuthenticationVc = [[ZYElectroniNewRealNameAuthenticationCardVc alloc]init];
    [self pushVc:newNameAuthenticationVc];
}

//
- (void)initView{
    
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(44 + status_height);
    }];
    
    [self.view addSubview:self.notAuthenticationView];
    [_notAuthenticationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(_notAuthenticationView.superview);
    }];
}
//
- (ZYElectronicRealNameAuthenticationTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYElectronicRealNameAuthenticationTopView" owner:nil options:nil].lastObject;
        [_topView.backButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"ic_navi_return"] forState:UIControlStateNormal];
        [_topView.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}
- (ZYElectronicNotRealNameAuthenticationView *)notAuthenticationView{
    if (!_notAuthenticationView) {
        _notAuthenticationView  = [[ZYElectronicNotRealNameAuthenticationView alloc]initWithFrame:CGRectZero];
        [_notAuthenticationView.goToAuthenticatBtn addTarget:self action:@selector(goToAuthenticatBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _notAuthenticationView;
}
#pragma mark - 点击事件
- (void)backButtonClicked {
    
    [self popVC];
}
@end
 
