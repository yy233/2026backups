//
//  BaseHidenNavViewController.m
//  Community
//  登录注册模块 使用此类
//  Created by 余莹 on 2020/11/14.
//

#import "BaseHiddenNavViewController.h"

@interface BaseHiddenNavViewController ()
@property (nonatomic,strong) UIImageView *backImgv;
@end

@implementation BaseHiddenNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNoticeThemeIsChange];
    [self setupNavigationBarHiddenStyle];
    [self initBackImg];
}

- (void)setupNavigationBarHiddenStyle{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];//返回按钮
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
#pragma mark == 主题色 notice
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarHiddenStyle];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.backgroundColor = [ThemeManager shareManager].loginModulethemeColorVCBackViewColor;
//        [self setupNavigationBarStyleWithMainColor];
    });
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    //隐藏的导航了 做 显示属性 只有登录相关界面用隐藏
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}
- (void)initNoticeThemeIsChange{
    Y_NSNotificationCenter_Creat_NameAction(NOTICE_NAME_ThemeISChanged, themeIsChange:)
}
- (void)themeIsChange:(NSNotification*)notice{
    NSLog(@"----login  VC---themeIsChange----%@",[self class]);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.backgroundColor = [ThemeManager shareManager].loginModulethemeColorVCBackViewColor;
        self.backImgv.image = [ThemeManager shareManager].loginModulethemeImgVCBackViewImg;
//        [self setupNavigationBarStyleWithMainColor];
    });
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(NOTICE_NAME_ThemeISChanged)
}

#pragma mark === 主题img
- (void)initBackImg{
    [self.view addSubview:self.backImgv];
    [_backImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backImgv.superview);
    }];
    _backImgv.image = [ThemeManager shareManager].loginModulethemeImgVCBackViewImg;
}

#pragma mark ===
- (UIImageView *)backImgv{
    if (!_backImgv) {
        _backImgv = [[UIImageView alloc]init];
        _backImgv.contentMode = UIViewContentModeScaleAspectFill;
        _backImgv.clipsToBounds = YES;
    }
    return _backImgv;
}
@end
