//
//  LoginAndRegiestViewController.m
//  Community
//
//  Created by 余莹 on 2022/5/13.
// 本界面 为新版的登录界面 （未注册的手机号 可自动注册）

#import "LoginAndRegiestVC.h"
#import "LoginAndRegiestMianView.h"

@interface LoginAndRegiestVC () <LoginAndRegiestMianViewDelegate>
@property (nonatomic,strong) LoginAndRegiestMianView *mainView;
@property (nonatomic,assign) LoginAndRegiestVC_Show_Type mainShowType;

@end

@implementation LoginAndRegiestVC
- (LoginAndRegiestMianView *)mainView{
    if (!_mainView) {
        _mainView = [[LoginAndRegiestMianView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
        _mainView.delegate = self;
    }
    return _mainView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainShowType = LoginAndRegiestVC_Show_Type_PasswordLogin;
    [self initSubView];
    [self initThisViewShowType];
    [self initNotice];

 }

- (void)initNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isResetPasswordFinishNotice) name:NotificationName_ResetPassword_Finish object:nil];
}
- (void)isResetPasswordFinishNotice{
        if (isNotNil(self.mainView)) {
            //重置密码的情况刷新|三方登录注册流程内 设置密码
            [self.mainView cleanAccountAndPasswordTextFiled];
        }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];//（animated+直接=bool 才能流畅push和pop）双=或双animated时nav都有闪烁白条
    [ThemeManager shareManager].type = ThemeType_Drak;//【登录注册相关页默认暗黑风格 tabbar之后会使用存储的风格】
    [self initVersionWithThirdShowOrNotShowData];//willApper 处理三方登录的显隐
    NSString *accountStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    if (  [ShareUserInfo sharedUserInfo].isHavaChooseAgreeBtn || accountStr.length > 0 ) {//底部同意协议按钮 判断用的数据 ｜ 使用过app（有账号str数据）的情况默认是点击同意过的
        self.mainView.bottomView.agreeBtn.selected = YES;
    }else{//无数据
        self.mainView.bottomView.agreeBtn.selected = NO;
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self isAutoLogin];//自动登录
}

- (void)initVersionWithThirdShowOrNotShowData{
    
    //版本接口 （处理三方登录显示的数据）
    WEAKSELF
    [VersionShowOrHiddenTool getVersionInfoBoolWithBool:^(BOOL succes, BOOL isShowBool) {
        if (succes) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.mainView setThirdLoginViewIsShow:isShowBool];
            });
        }
    }];
}

- (void)initSubView{
    [self.view addSubview:self.mainView];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mainView.superview);
    }];
    WEAKSELF
    self.mainView.gotoPrivacyAgreementVcBlock = ^(PrivacyAgreementVCLate * _Nonnull vc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:vc animated:YES];
        });
    };
}
- (void)initThisViewShowType{
    [self.mainView setThisViewShowType:self.mainShowType];

}
 
#pragma mark ==  有数据的状态下 ｜｜ 自动登录
- (void)isAutoLogin{
    //退出时 过期时间置空 不会做自动登录
    //普通展示状态
    

    NSString *accountStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    if (isNil(accountStr)) {
        return;
    }
    NSString  *exporedTimeStr = ( [ShareUserInfo sharedUserInfo].expiredTime.length > 0 ? [ShareUserInfo sharedUserInfo].expiredTime : [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:kLogin_ExpiredTime_Key]] );
    BOOL ifCanLogin = NO;
    NSString *exT = [ToolOfTimeChangeFormat getTimeStrWithString:exporedTimeStr];
    NSString *nowT = [ToolOfTimeChangeFormat currentTimeStr];
    
    /**
     //登录账户号码相同 token非过期时间 + 当前界面是密码登录类型 则自动登录--- 旧版
     //新版 未过期 账户数据一样 直接跳转 不调用接口
     
     */
    
    
   //旧版 走接口 只走接口 且智能密码登录数据
    if (([exT integerValue] > [nowT integerValue]) && [self.mainView.phoneStr isEqualToString:accountStr] && ( self.mainView.passWordOneStr.length>0) && (self.mainShowType == LoginAndRegiestVC_Show_Type_PasswordLogin) ) {
        ifCanLogin = YES;
    }
    if (ifCanLogin) {
        [self thisViewTouchSubViewItemWithTag:Tag_LoginAndRegiest_MainLoginBtn + Tag_LoginAndRegiest_Base];
    }
    /**。0521暂时不用新版 用旧版 走登录接口逻辑
    
    //新版 不走接口 直接进主页 (密码登录 验证码登录的两种有账号的数据)
    if (([exT integerValue] > [nowT integerValue]) && [self.mainView.phoneStr isEqualToString:accountStr] ) {
        ifCanLogin = YES;
    }
    if (ifCanLogin) {
        [IsLoginTool share].save_Login_Type = IS_Login_Nomal;
        [ShareUserInfo sharedUserInfo].expiredTime = [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:kLogin_ExpiredTime_Key]];
        [ShareUserInfo sharedUserInfo].token = [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];

        [[ShareUserInfo sharedUserInfo] getDefaultsLoginUserInfo];
        NSLog(@"%@",[ShareUserInfo sharedUserInfo].expiredTime);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.window.rootViewController = [[TabBarController alloc] init];
        });
    }
     */
    
}


#pragma mark ===
- (void)thisViewTouchSubViewItemWithTag:(NSInteger)tag{
   
    [self.view endEditing:YES];
    
    DLog(@"登录页 点击 ==  %ld",tag); 
    
    switch (tag-Tag_LoginAndRegiest_Base) {
        case Tag_LoginAndRegiest_AppleLogin:
        {
            if (!self.mainView.bottomView.agreeBtn.selected) {
                Y_SVP_SHOW_INFO_MES(@"请同意协议！");
                return;
            }
            WEAKSELF

            [[AppleLoginManager shareManager] appleLoginBtnIsTap];
            [AppleLoginManager shareManager].userInfoBlock = ^(AppleLoginModel *model, Third_LoginOrRegist_Type type) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf getAppleThirdInfoWithModel:model withType:type];
                });
            };
        }
            break;
        case Tag_LoginAndRegiest_ZfbLogin:
        {
            if (!self.mainView.bottomView.agreeBtn.selected) {
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
        }
            break;
        case Tag_LoginAndRegiest_WxLogin:
        {
            if (!self.mainView.bottomView.agreeBtn.selected) {
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
        }
            break;
            
            
        case Tag_LoginAndRegiest_ForgetPasswordBtn:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                ResetPasswordVCLast  *resetPassw = [[ResetPasswordVCLast alloc]init];//重置密码 1210改界面+接口
                [self.navigationController pushViewController:resetPassw animated:YES];
            });
            
        }
            break;
        case Tag_LoginAndRegiest_ChangeLoginTypeBtn:
        {
            
            if (self.mainShowType == LoginAndRegiestVC_Show_Type_PasswordLogin) {
                self.mainShowType = LoginAndRegiestVC_Show_Type_CodeLogin;
            }else{
                self.mainShowType = LoginAndRegiestVC_Show_Type_PasswordLogin;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainView setThisViewShowType:self.mainShowType];//更新当前UI 切换登录类型
            });
        }
            break;
        case Tag_LoginAndRegiest_CodeSendBtn://验证码请求按钮
        {
            NSString *phoneStr = self.mainView.phoneStr;
           
            if (phoneStr.length == 0) {
                Y_SVP_SHOW_ERR_MES(Please_enter_phone_number)
                return;
            }
            if (phoneStr.length<=11 && phoneStr.length>8) {
            }else{
                Y_SVP_SHOW_ERR_MES(@"请输入正确的账号");
                return;
            }
            [self codeSenAppleActionWithPhoneStr:phoneStr];
        }
            break;
        case Tag_LoginAndRegiest_MainLoginBtn://主登录按钮
        {
            if (!self.mainView.bottomView.agreeBtn.selected) {
                Y_SVP_SHOW_INFO_MES(@"请同意协议！");
                return;
            }
            
            NSString *phoneStr = self.mainView.phoneStr;
            NSString *passwordStr = self.mainView.passWordOneStr;
            NSString *codeStr = self.mainView.codeStr;
            if (phoneStr.length == 0) {
                Y_SVP_SHOW_ERR_MES(Please_enter_phone_number)
                return;
            }
            if (phoneStr.length<=11 && phoneStr.length>8) {
            }else{
                Y_SVP_SHOW_ERR_MES(@"请输入正确的账号");
                return;
            }
            if (self.mainShowType == LoginAndRegiestVC_Show_Type_PasswordLogin) {
                if (passwordStr.length == 0) {
                    Y_SVP_SHOW_ERR_MES(Please_enter_password_number)
                    return;
                }
                //
                [self doLoginWithPhoneStr:phoneStr withPasswordStr:passwordStr];
            }else{
                if (codeStr.length == 0) {
                    Y_SVP_SHOW_ERR_MES(Please_enter_code_number)
                    return;
                }
                //
                [self doLoginWithPhoneStr:phoneStr withCodeStr:codeStr];
            }
 
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ================================================================================================== 验证码

#pragma mark ===
- (void)codeSenAppleActionWithPhoneStr:(NSString *)phoneStr{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phoneStr forKey:@"account"];
    [params setValue:@(CodeRequestType_Regist) forKey:@"type"];

    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_USER_SEND_CODE withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
               //验证码btn开始倒计时
                Y_NSNotificationCenter_PostNotice_NilObject_Name(NoticeName_Regist_SecnCodeTimeChangeYes);
                Y_SVP_SHOW_SUCCESS_MESSAGE
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark ================================================================================================== 主登录
 
//密码登录注册
- (void)doLoginWithPhoneStr:(NSString *)phoneStr withPasswordStr:(NSString *)passwordStr{
    
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.mainView.phoneStr forKey:@"account"];
    [params setValue:self.mainView.passWordOneStr forKey:@"password"];
    [SVProgressHUD showWithStatus:@"登录中..."];
    [SVProgressHUD dismissWithDelay:15];//超时时使用
    [[ToolOfNetWork sharedTools] YrequestPostURL:URL_USER_LOGIN withParams:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        NSLog(@"loginBtnAction === %@ %@",responsObject,error);
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [weakSelf saveTokenAndUserInfo:Y_ResponsObject_dataDic];
                NSString *expiredTimeStr = @"";
                NSDictionary *dic = Y_ResponsObject_dataDic;
                if ([[Y_ResponsObject_dataDic allKeys]containsObject:kLogin_ExpiredTime_Key]) {//token的有效期
                    expiredTimeStr = [NSString stringWithFormat:@"%@",[Y_ResponsObject_dataDic objectForKey:kLogin_ExpiredTime_Key]];
                }
                [weakSelf saveAccountAndPassWordWithExpiredTimeStr:expiredTimeStr AccountStr:weakSelf.mainView.phoneStr  withPasswordStr:weakSelf.mainView.passWordOneStr];
                [IsLoginTool share].save_Login_Type = IS_Login_Nomal;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.view.window.rootViewController = [[TabBarController alloc] init];
                });
 
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

//验证码登录注册
- (void)doLoginWithPhoneStr:(NSString *)phoneStr withCodeStr:(NSString *)codeStr{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.mainView.phoneStr forKey:@"account"];
    [params setValue:self.mainView.codeStr forKey:@"code"];
    [SVProgressHUD showWithStatus:@"Loading"];
    [SVProgressHUD dismissWithDelay:15];//超时时使用
    
    [[ToolOfNetWork sharedTools] YrequestPostURL:URL_USER_LOGIN withParams:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        NSLog(@"code loginBtnAction === %@ %@",responsObject,error);
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [weakSelf saveTokenAndUserInfo:Y_ResponsObject_dataDic];
                NSString *expiredTimeStr = @"";
                if ([[Y_ResponsObject_dataDic allKeys]containsObject:kLogin_ExpiredTime_Key]) {//token的有效期
                    expiredTimeStr = [NSString stringWithFormat:@"%@",[Y_ResponsObject_dataDic objectForKey:kLogin_ExpiredTime_Key]];
                }
                [weakSelf saveAccountAndPassWordWithExpiredTimeStr:expiredTimeStr AccountStr:weakSelf.mainView.phoneStr  withPasswordStr:@""];//密码清掉
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

#pragma mark ================================================================================================== 三方相关
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
    if (self.mainView.passWordOneStr.length>0) {
        [self saveAccountAndPassWordWithExpiredTimeStr: [TextShowWithModelStr textShowWithModelStr:model.expiredTime] AccountStr:self.mainView.phoneStr  withPasswordStr:@""];
    }
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
    if (self.mainView.passWordOneStr.length>0) {
        [self saveAccountAndPassWordWithExpiredTimeStr: [TextShowWithModelStr textShowWithModelStr:model.expiredTime] AccountStr:self.mainView.phoneStr  withPasswordStr:@""];
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//    });
    self.view.window.rootViewController = [[TabBarController alloc] init];

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
    if (self.mainView.passWordOneStr.length>0) {
        [self saveAccountAndPassWordWithExpiredTimeStr: [TextShowWithModelStr textShowWithModelStr:model.expiredTime] AccountStr:self.mainView.phoneStr  withPasswordStr:@""];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.window.rootViewController = [[TabBarController alloc] init];
    });
 
}

#pragma mark ==================================================================================================

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

@end
