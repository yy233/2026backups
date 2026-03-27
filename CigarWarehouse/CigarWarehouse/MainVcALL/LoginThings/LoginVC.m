//
//  LoginVC.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import "LoginVC.h"
#import "LoginView.h"

@interface LoginVC ()
@property (nonatomic,strong) LoginView *loginView;
@end

@implementation LoginVC
//导航隐藏
- (void)setupNavigationBarHiddenStyle{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    //self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];//返回
    self.navigationController.navigationBarHidden = YES;
}
- (void)setupNavigationBarShowStyle{
    self.navigationController.navigationBarHidden = NO;
}

- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc]initWithFrame:self.view.frame];
        [_loginView.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginView;
}
#pragma mark ----
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllBrands];//网络权限触发
    [self.view addSubview:self.loginView];
  

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavigationBarHiddenStyle];
    [[ShareUserInfo share]getDefaultsLoginUserInfo];
}
 

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (([ShareUserInfo share].userInfo.username.length>0) && ([ShareUserInfo share].userInfo.password.length>0)) {//账户密码
        [self.loginView fillLoginInfoAccountStr:[ShareUserInfo share].userInfo.username withPasswordStr:[ShareUserInfo share].userInfo.password];
        if ([ShareUserInfo share].userInfo.token.length>0) {//登出时 token被清空过
            [self loginAction];
        }
    }else  if (([ShareUserInfo share].userInfo.username.length>0)) {//只有账户
        [self.loginView fillLoginInfoAccountStr:[ShareUserInfo share].userInfo.username  withPasswordStr:@""];
    }else{
    }
    
    //test
    /**
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self resetRootVc];
     });
     */
    
}

#pragma mark ====
- (void)loginAction{
    if (self.loginView.loginUseModel.acccount.length<=0) {
        Y_SVP_SHOW_INFO_MES(@"请输入账户！");
        return;
    }
    if (self.loginView.loginUseModel.password.length<=0) {
        Y_SVP_SHOW_INFO_MES(@"请输入密码！");
        return;
    }
    [[LoginThingsTool share]adminDoLoginActionWithDic:@{@"username":self.loginView.loginUseModel.acccount,
                                                       @"password":self.loginView.loginUseModel.password}  withBlock:^(BOOL succ, id  _Nonnull dataThings) {
                                                           
        if (succ) {
            [ShareUserInfo share].userInfo = [[UserModel alloc]init];//清空
            if ([dataThings isKindOfClass:[NSDictionary class]] || [dataThings isKindOfClass:[NSMutableDictionary class]]) {
                [ShareUserInfo share].userInfo = [UserModel mj_objectWithKeyValues:dataThings];
            } else if([dataThings isKindOfClass:[NSString class]]){
                [ShareUserInfo share].userInfo.token = dataThings;
            }else{
            }
            if ([ShareUserInfo share].userInfo.token.length>0) {
                [ShareUserInfo share].userInfo.username = self.loginView.loginUseModel.acccount;
                [ShareUserInfo share].userInfo.password = self.loginView.loginUseModel.password;
                [[ShareUserInfo share]saveDefaultsLoginUserInfo:[ShareUserInfo share].userInfo];
                [self resetRootVc];
            } else {
                Y_SVP_SHOW_ERR_MES(@"登录获取数据有误！");
            }
            
        }else{
            Y_SVP_SHOW_ERR_MES(@"登录失败！");
        }
        
    }];

}

- (void)resetRootVc{
    self.view.window.rootViewController  = [[CigarTabBarController alloc]init];
}


- (void)getAllBrands{
    NSString *u = Y_AllURL_Main(stock_allBrands);
    NSDictionary *p = @{};
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                    parm:p
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull dic) {
    } fail:^(NSError * _Nonnull err) {
    }];
}
@end
