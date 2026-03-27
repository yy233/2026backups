//
//  LoginViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/10.
//

#import "LoginViewController.h"
#import "LoginView.h" 
#import "MainTabbarControll.h"

@interface LoginViewController () <LoginViewDelegate>
@property (nonatomic,strong) LoginView *loginView;
@end

@implementation LoginViewController


- (LoginView *)loginView{
    if(!_loginView ){
        _loginView = [[LoginView alloc]initWithFrame:self.view.frame];
        _loginView.delegate = self;
    }
    return _loginView;
}


//登录点击 去主页
- (void)touchLoginWithType:(Login_Type)type{
    if(type == Login_Type_local){//内
        
    }else{//外
        
    }
    //登录点击 去主页
    self.view.window.rootViewController = [[MainTabbarControll alloc]init];

}
#pragma mark ==
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self.view addSubview:self.loginView];
    NSLog(@"%s",__FUNCTION__);
    
    NSLog(@"   -----------  %@",NSLocalizedStringFromTable(@"Login",@"LocalizablelocalLaugeChatVcs",nil));
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    NSLog(@"%s",__FUNCTION__);
}

@end
