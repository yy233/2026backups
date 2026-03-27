//
//  LoginVC.m
//
//
//  Created by 余莹 on 2020/11/9.
//

#import "LoginVC.h"
#import "LoginViewWithMoreLoginFunction.h"
#import "RegistVCLast.h"
@interface LoginVC ()<LoginViewTouchBtnDelegate>
@property (nonatomic,strong) LoginViewWithMoreLoginFunction *loginView;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    [self initNotice];

   
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationName_ResetPassword_Finish object:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [ThemeManager shareManager].type = ThemeType_Drak;//【登录注册相关页默认暗黑风格 tabbar之后会使用存储的风格】
    [self isAutoLogin];//自动登录
    //版本接口 （处理三方登录显示的数据）
    WEAKSELF
    [VersionShowOrHiddenTool getVersionInfoBoolWithBool:^(BOOL succes, BOOL isShowBool) {
        if (succes) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.loginView showOrNotShowDeal:isShowBool];
            });
        }
    }];

}

#pragma mark ==
- (void)initView{
    [self.view addSubview:self.loginView];
//    self.loginView.removeSelfBtn.hidden = YES;//游客隐藏
    WEAKSELF
    self.loginView.gotoPrivacyAgreementVcBlock = ^(PrivacyAgreementVCLate * _Nonnull vc) {//协议跳转
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:vc animated:YES];
        });
    };
   
}
- (void)initNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isResetPasswordFinishNotice) name:NotificationName_ResetPassword_Finish object:nil];
}
- (void)isResetPasswordFinishNotice{
        if (isNotNil(self.loginView)) {
            //重置密码的情况刷新
            [self.loginView cleanAccountAndPasswordTextFiled];
        }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)loginViewbtnTouchAction:(UIButton *)sender{
    NSLog(@"登录页面btn");
    [self.view endEditing:YES];
    //
    if(sender.tag == LOGIN_SUBBTN_GO_REGIST_VC_BTN_TAG){//注册
     // RegistVC *registVc =  [[RegistVC alloc]init];//1130 注册 更换UI 更改接口 成一个界面
        RegistVCLast *registVc =  [[RegistVCLast alloc]init];
      [self.navigationController pushViewController:registVc animated:YES];
    }else if(sender.tag == LOGIN_SUBBTN_GO_USE_CODE_LOGIN_VC_BTN_TAG){//短信验证码登录
        RegistVC *registVc =  [[RegistVC alloc]init];
        registVc.isUseCodeLoginBool = YES;
        [self.navigationController pushViewController:registVc animated:YES];
    }else if(sender.tag == Privacypolicy_CHOOSE_BTN_TAG){//隐私政策 未使用本tag
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Privacy;
        privacyVc.isLoginVcPushInToBool = YES;
        [self.navigationController pushViewController:privacyVc animated:YES];
    }else if(sender.tag == FORGET_PASSWORD_TAG){
//        ResetPasswordVC *resetPassw = [[ResetPasswordVC alloc]init];//重置密码
        ResetPasswordVCLast  *resetPassw = [[ResetPasswordVCLast alloc]init];//重置密码 1210改界面+接口
        [self.navigationController pushViewController:resetPassw animated:YES];
    }else if(sender.tag == WXLOGIN_BTN_TAG){
        if (!self.loginView.agreeBtn.selected) {
            Y_SVP_SHOW_INFO_MES(@"请同意协议！");
            return;
        }
        WEAKSELF
        [[WechatLoginManager shareManager] wxLoginBtnIsTap];
        [WechatLoginManager shareManager].userInfoblock = ^(WeChatLoginUserModel * model, Third_LoginOrRegist_Type type) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf getWxThirdInfoWithModel:model withType:type];
            });
        };
       
    }else if(sender.tag == ZFBLOGIN_BTN_TAG){
        if (!self.loginView.agreeBtn.selected) {
            Y_SVP_SHOW_INFO_MES(@"请同意协议！");
            return;
        }
        WEAKSELF
        [[ZFBLoginManager shareManager] ZfbLoginBtnIsTap];
        [ZFBLoginManager shareManager].userInfoBlock = ^(ZFBLoginModel * model, Third_LoginOrRegist_Type type) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf getZFBThirdInfoWithModel:model withType:type];
            });
        };
        
    }else if(sender.tag == APPLELOGIN_BTN_TAG){//改成爱破登录
        if (!self.loginView.agreeBtn.selected) {
            Y_SVP_SHOW_INFO_MES(@"请同意协议！");
            return;
        }
        NSLog(@"\n APPLELOGIN_BTN_TAG  ");
        WEAKSELF
   
        [[AppleLoginManager shareManager] appleLoginBtnIsTap];
        [AppleLoginManager shareManager].userInfoBlock = ^(AppleLoginModel *model, Third_LoginOrRegist_Type type) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf getAppleThirdInfoWithModel:model withType:type];
            });
        };
        
    }else if(sender.tag == REMOVE_SELF_BTN_TAG){
        
        if (self.isPopVcType) {
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"loginvc dismiss");
            }];
        }else{
            NSLog(@"REMOVE_SELF_BTN_TAG");//游客方式进入
          
            NSString *token = Tourists_LoginTokenStr;
            NSDictionary *userInfo =         @{
                @"avatarUrl" : @"",
                @"city": @"",
                @"detailAddress" : @"",
                @"imId" : @"",
                @"isBindMobile" : @0,
                @"isRealAuth": @0,
                @"mobile" : @"",
                @"nickname": @"",
                @"province" :@"",
                @"realName" : @"",
                @"sex" : @0,
                @"uid" : @"",
            };
            [ShareUserInfo sharedUserInfo].token = Tourists_LoginTokenStr;
            [ShareUserInfo sharedUserInfo].commuityInfo = [[CommunityModel alloc]init];
            [ShareUserInfo sharedUserInfo].commuityInfo.ID=1;//游客账号登录
            [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel = [[CommitRightAllDataModel alloc]init];//游客身份权限空数据
            [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel = 5;//游客5
            [self saveTokenAndUserInfo:@{@"token":token,@"userInfo":userInfo}];
            [IsLoginTool share].save_Login_Type = IS_Login_Tourists;
            //游客 登录时 清空原有的账号登录的一部分 仅仅密码清掉
            if (self.loginView.passWordTextField.text.length>0) {
                [self saveAccountAndPassWordWithExpiredTimeStr:@"" AccountStr:self.loginView.phoneTextField.text  withPasswordStr:@""];
            }
            self.view.window.rootViewController = [[TabBarController alloc] init];
            
        }
       
        
        
    }else if(sender.tag == LOGIN_BTN_TAG_CODE_GetCode){//验证码登录_验证码请求按钮
        [self codeGetNumAction];
    }else if(sender.tag == LOGIN_BTN_TAG_CODE_LOGIN){//验证码登录登录
        if (!self.loginView.agreeBtn.selected) {
            Y_SVP_SHOW_INFO_MES(@"请同意协议！");
            return;
        }
        [self codeLoginBtnAction];
        
    }else if(sender.tag == LOGIN_BTN_TAG){//登录
        if (!self.loginView.agreeBtn.selected) {
            Y_SVP_SHOW_INFO_MES(@"请同意协议！");
            return;
        }
        [self loginBtnAction];

    }else{
    }
}

#pragma mark ==  有数据的状态下 ｜｜ 自动登录
- (void)isAutoLogin{
    //退出时 过期时间置空 不会做自动登录
    //普通展示状态
    NSString *accountStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    NSString  *exporedTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:kLogin_ExpiredTime_Key];
    BOOL ifCanLogin = NO;
    NSString *exT = [ToolOfTimeChangeFormat getTimeStrWithString:exporedTimeStr];
    NSString *nowT = [ToolOfTimeChangeFormat currentTimeStr];
    
    //登录账户号码相同 token非过期时间 则自动登录
    if (([exT integerValue] > [nowT integerValue]) && [self.loginView.phoneStr isEqualToString:accountStr] && self.loginView.passWordStr.length>0) {
        ifCanLogin = YES;
    }
    if (ifCanLogin) {
        [self loginBtnAction];
    }
    
}
#pragma mark ==================  账号登录
- (void)loginBtnAction{

    //test
//    [IsLoginTool share].save_Login_Type = IS_Login_Nomal;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.view.window.rootViewController = [[TabBarController alloc] init];
//    });
//    return;
//    //test---

    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.loginView.phoneStr forKey:@"account"];
    [params setValue:self.loginView.passWordStr forKey:@"password"];
    [SVProgressHUD showWithStatus:@"登录中..."];
    [SVProgressHUD dismissWithDelay:15];//超时时使用
    [[ToolOfNetWork sharedTools] YrequestPostURL:URL_USER_LOGIN withParams:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        NSLog(@"loginBtnAction === %@ %@",responsObject,error);
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self saveTokenAndUserInfo:Y_ResponsObject_dataDic];
                NSString *expiredTimeStr = @"";
                NSDictionary *dic = Y_ResponsObject_dataDic;
                if ([[Y_ResponsObject_dataDic allKeys]containsObject:kLogin_ExpiredTime_Key]) {//token的有效期
                    expiredTimeStr = [NSString stringWithFormat:@"%@",[Y_ResponsObject_dataDic objectForKey:kLogin_ExpiredTime_Key]];
                }
                
                [self saveAccountAndPassWordWithExpiredTimeStr:expiredTimeStr AccountStr:self.loginView.phoneStr  withPasswordStr:self.loginView.passWordStr];
                [IsLoginTool share].save_Login_Type = IS_Login_Nomal;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.view.window.rootViewController = [[TabBarController alloc] init];
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark ================== 验证码登录
- (void)codeLoginBtnAction{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.loginView.phoneStr forKey:@"account"];
    [params setValue:self.loginView.codeStr forKey:@"code"];
    [SVProgressHUD showWithStatus:@"Loading"];
    [SVProgressHUD dismissWithDelay:15];//超时时使用
    
    [[ToolOfNetWork sharedTools] YrequestPostURL:URL_USER_LOGIN withParams:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        NSLog(@"code loginBtnAction === %@ %@",responsObject,error);
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self saveTokenAndUserInfo:Y_ResponsObject_dataDic];
                NSString *expiredTimeStr = @"";
                if ([[Y_ResponsObject_dataDic allKeys]containsObject:kLogin_ExpiredTime_Key]) {//token的有效期
                    expiredTimeStr = [NSString stringWithFormat:@"%@",[Y_ResponsObject_dataDic objectForKey:kLogin_ExpiredTime_Key]];
                }
                [self saveAccountAndPassWordWithExpiredTimeStr:expiredTimeStr AccountStr:self.loginView.phoneStr  withPasswordStr:@""];//密码清掉
//                [self saveAccountWithAccountStr:self.loginView.phoneStr];
                [IsLoginTool share].save_Login_Type = IS_Login_Nomal;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.view.window.rootViewController = [[TabBarController alloc] init];
                });
               
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
- (void)codeGetNumAction{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.loginView.phoneStr forKey:@"account"];
    [params setValue:@(CodeRequestType_Login) forKey:@"type"];
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_USER_SEND_CODE withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self.loginView countdown];//验证码时间
                Y_SVP_SHOW_SUCCESS_MESSAGE
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark ========= 总save ShareUserInfo
- (void)saveTokenAndUserInfo:(NSDictionary *)resultsDic{
    if ([[resultsDic allKeys]containsObject:kLogin_ExpiredTime_Key]) {//token的有效期
        [[NSUserDefaults standardUserDefaults] setValue:[resultsDic objectForKey:kLogin_ExpiredTime_Key] forKey:kLogin_ExpiredTime_Key];
        [ShareUserInfo sharedUserInfo].expiredTime = [resultsDic objectForKey:kLogin_ExpiredTime_Key];
    }
    if ([[resultsDic allKeys]containsObject:@"token"]) {
        [[NSUserDefaults standardUserDefaults] setValue:[resultsDic objectForKey:@"token"] forKey:@"token"];
        [ShareUserInfo sharedUserInfo].token = [resultsDic objectForKey:@"token"];
    }
    if ([[resultsDic allKeys]containsObject:@"userInfo"]) {
        UserModel *userModel = [UserModel mj_objectWithKeyValues:[resultsDic objectForKey:@"userInfo"]];
        [ShareUserInfo sharedUserInfo].userInfo = userModel;
        [[ShareUserInfo sharedUserInfo] saveDefaultsLoginUserInfo:userModel];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)saveAccountAndPassWordWithExpiredTimeStr:(NSString *)exporedTimeStr AccountStr:(NSString *)accountStr withPasswordStr:(NSString *)passwordStr{
    [[NSUserDefaults standardUserDefaults] setValue:exporedTimeStr forKey:kLogin_ExpiredTime_Key];
    [[NSUserDefaults standardUserDefaults] setValue:accountStr forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] setValue:passwordStr forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ShareUserInfo sharedUserInfo].expiredTime = exporedTimeStr;
    [ShareUserInfo sharedUserInfo].account = accountStr;
    [ShareUserInfo sharedUserInfo].password = passwordStr;
}
- (void)saveAccountWithAccountStr:(NSString *)accountStr{
    [[NSUserDefaults standardUserDefaults] setValue:accountStr forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ShareUserInfo sharedUserInfo].account = accountStr;
}

#pragma mark ==================  苹果三方登录回调后
- (void)getAppleThirdInfoWithModel:(AppleLoginModel *)model  withType:(Third_LoginOrRegist_Type)appleThirdType{
    switch (appleThirdType) {
        case Third_LoginOrRegist_Type_Login:
        {
            //Login
            [self thirdLoginAppleModel:model];
        }
            break;
        case Third_LoginOrRegist_Type_Regist:
        {
            //1214 存储三方登录的注册绑定用的token+过期时间 用于后续绑定手机号的接口
            [self saveTokenAndUserInfo:@{kLogin_ExpiredTime_Key:model.expiredTime}];
            [self saveTokenAndUserInfo:@{@"token":model.token}];
            [self pushBindVcWithAppleModel:model];
            /** //1214 强绑定 不做不绑定手机的允许跳转  暂时隐藏苹果不绑定手机相关
             [self thirdLoginAppNotPhoneBindModel:model];// IS_Login_UnboundPhone;//没有绑定手机
             */
        }
            break;
        case Third_LoginOrRegist_Type_Err:
        {
            //err
        }
            break;
            
        default:
            break;
    }
}
- (void)pushBindVcWithAppleModel:(AppleLoginModel *)model{
    DLog(@"pushBindVcWithApple");
    //苹果不做绑定手机操作 做类似游客的处理 pop的非登录页而是绑定手机页 1214苹果三方登录注册状态 做绑定跳转
    dispatch_async(dispatch_get_main_queue(), ^{
        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
        bindVc.appleUserModel = model;
        [self.navigationController pushViewController:bindVc animated:YES];
    });
     
}

- (void)thirdLoginAppleModel:(AppleLoginModel *)model{
    [self saveTokenAndUserInfo:@{@"token":model.token}];
    [self saveTokenAndUserInfo:@{@"userInfo":[model.userInfo mj_keyValues]}]; 
  //登录类型
    if (model.userInfo.mobile.length<=0) {
        [IsLoginTool share].save_Login_Type = IS_Login_UnboundPhone;//没有绑定手机
        [IsLoginTool share].appleLoginSaveThridIdWillUseToBindPhone = [TextShowWithModelStr textShowWithModelStr:model.thirdPlatformId];
    }else{
        [IsLoginTool share].save_Login_Type = IS_Login_Nomal;
    }
    //三方登录时 清空原有的账号登录的一部分 仅仅密码清掉
    if (self.loginView.passWordTextField.text.length>0) {
        [self saveAccountAndPassWordWithExpiredTimeStr: [TextShowWithModelStr textShowWithModelStr:model.expiredTime] AccountStr:self.loginView.phoneTextField.text  withPasswordStr:@""];
    }
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.window.rootViewController = [[TabBarController alloc] init];
    });
}
- (void)thirdLoginAppNotPhoneBindModel:(AppleLoginModel *)model{
    [self thirdLoginAppleModel:model];
}

#pragma  mark ================== 微信登录注册相关

- (void)getWxThirdInfoWithModel:(WeChatLoginUserModel *)model  withType:(Third_LoginOrRegist_Type)wxThirdType{
    switch (wxThirdType) {
        case Third_LoginOrRegist_Type_Login:
        {
            //Login
            [self thirdLoginWxModel:model];
        }
            break;
        case Third_LoginOrRegist_Type_Regist:
        {
            //1214 存储三方登录的注册绑定用的token+过期时间 用于后续绑定手机号的接口
            [self saveTokenAndUserInfo:@{kLogin_ExpiredTime_Key:model.expiredTime}];
            [self saveTokenAndUserInfo:@{@"token":model.token}];
            [self pushBindVcWithWxModel:model];
        }
            break;
        case Third_LoginOrRegist_Type_Err:
        {
            //err
        }
            break;
            
        default:
            break;
    }
}
- (void)pushBindVcWithWxModel:(WeChatLoginUserModel *)model{
    dispatch_async(dispatch_get_main_queue(), ^{
        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
        bindVc.wxUsermodel = model;
        [self.navigationController pushViewController:bindVc animated:YES];
    });
       
}
- (void)thirdLoginWxModel:(WeChatLoginUserModel *)model{
    [self saveTokenAndUserInfo:@{@"token":model.token}];
    [self saveTokenAndUserInfo:@{@"userInfo": [model.userInfo mj_keyValues]}];
  
    [IsLoginTool share].save_Login_Type = IS_Login_Nomal;
    //三方登录时 清空原有的账号登录的一部分 仅仅密码清掉
    if (self.loginView.passWordTextField.text.length>0) {
        [self saveAccountAndPassWordWithExpiredTimeStr:[TextShowWithModelStr textShowWithModelStr:model.expiredTime] AccountStr:self.loginView.phoneTextField.text  withPasswordStr:@""];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.window.rootViewController = [[TabBarController alloc] init];
    });
}
#pragma mark ================== 支付宝登录注册相关

- (void)getZFBThirdInfoWithModel:(ZFBLoginModel *)model  withType:(Third_LoginOrRegist_Type)zfbThirdType{
    switch (zfbThirdType) {
        case Third_LoginOrRegist_Type_Login:
        {
            //Login
            [self thirdLoginZFBModel:model];
        }
            break;
        case Third_LoginOrRegist_Type_Regist:
        {
            //1214 存储三方登录的注册绑定用的token+过期时间 用于后续绑定手机号的接口
            [self saveTokenAndUserInfo:@{kLogin_ExpiredTime_Key:model.expiredTime}];
            [self saveTokenAndUserInfo:@{@"token":model.token}];
            [self pushBindVcWithZFBModel:model];
        }
            break;
        case Third_LoginOrRegist_Type_Err:
        {
            //err
        }
            break;
            
        default:
            break;
    }
}
- (void)pushBindVcWithZFBModel:(ZFBLoginModel *)model{
    dispatch_async(dispatch_get_main_queue(), ^{
        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
        bindVc.zfbUserModel = model;
        [self.navigationController pushViewController:bindVc animated:YES];
    });
   
}
- (void)thirdLoginZFBModel:(ZFBLoginModel *)model{
    [self saveTokenAndUserInfo:@{@"token":model.token}];
    [self saveTokenAndUserInfo:@{@"userInfo": [model.userInfo mj_keyValues]}];
 
    [IsLoginTool share].save_Login_Type = IS_Login_Nomal;
    //三方登录时 清空原有的账号登录的一部分 仅仅密码清掉
    if (self.loginView.passWordTextField.text.length>0) {
        [self saveAccountAndPassWordWithExpiredTimeStr:[TextShowWithModelStr textShowWithModelStr:model.expiredTime] AccountStr:self.loginView.phoneTextField.text  withPasswordStr:@""];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.window.rootViewController = [[TabBarController alloc] init];
    });
}

#pragma mark ===
- (LoginViewWithMoreLoginFunction *)loginView{
    if (!_loginView) {
        _loginView = [[LoginViewWithMoreLoginFunction alloc]initWithFrame:self.view.frame];
        _loginView.delegate = self;
        _loginView.isLoginView = YES;
    }
    return _loginView;
}

@end
