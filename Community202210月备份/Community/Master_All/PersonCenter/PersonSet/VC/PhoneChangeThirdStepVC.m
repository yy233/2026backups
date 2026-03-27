//
//  PhoneChangeThirdStepVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/27.
//

#import "PhoneChangeThirdStepVC.h"
#import "SafetyCenterViewModel.h"
#import "SocketRocketUtility.h"
@interface PhoneChangeThirdStepVC ()

@property(nonatomic, strong) UILabel *textL;

@property(nonatomic, strong) UITextField *textF;

@property(nonatomic, strong) UIView *lineV;

@property(nonatomic, strong) UIButton *btn;

@end

@implementation PhoneChangeThirdStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换手机号";
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}

- (void)initView{
    [self.textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(37);
        make.top.offset(50);
    }];
    

    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textL.mas_bottom).offset(35);
        make.left.mas_equalTo(self.view).offset(37);
        make.right.offset(-37);
        make.height.offset(30);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(37);
        make.right.offset(-37);
        make.height.offset(0.5);
        make.top.mas_equalTo(self.textF.mas_bottom).offset(10);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.offset(45);
        make.left.offset(37);
        make.top.mas_equalTo(self.lineV.mas_bottom).offset(30);
    }];
    
    self.textF.textColor = [ThemeManager shareManager].mainTextColor;
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3]}];
    self.textF.attributedPlaceholder =  placeholderString;
    
    self.textL.textColor = [ThemeManager shareManager].mainTextColor;
    self.lineV.backgroundColor = [ThemeManager shareManager].themeLineColor;
}

#pragma mark - 懒加载

- (UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc] init];
        _textL.text = @"请输入您收到的验证码";
        _textL.font = FontSize_Vip_Nomail(17);
        _textL.numberOfLines = 0;
        _textL.textColor = [Tool getColorWithHexString:@"#333333"];
        _textL.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_textL];
    }
    return _textL;
}



- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc] init];
        _textF.placeholder = @"请输入验证码";
        _textF.font = FontSize_Vip_Nomail(15);
        [_textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_textF];
    }
    return _textF;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.view addSubview:_lineV];
    }
    return _lineV;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"确认" forState:UIControlStateNormal];
        _btn.titleLabel.font = FontSize_Vip_Nomail(15);
        [_btn setTitleColor:[Tool getColorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_btn setBackgroundColor:[Tool getColorWithHexString:@"#2672F9"]];
        [_btn setImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btn.layer.cornerRadius = 3.5;
        _btn.clipsToBounds = YES;
        _btn.tag = 0;
        [self.view addSubview:_btn];
    }
    return _btn;
}

#pragma mark - 按钮点击

- (void)btnClicked: (UIButton *)sender{
    if (_textF.text.length<0) {
        Y_SVP_SHOW_ERR_MES(@"请输入验证码！");
        return;
    }
    
    
//    Y_SVP_SHOW_MES_IsLoading_15Delay
    //已经登录状态 不做authToken
//    [SafetyCenterViewModel safetyCenterCheckCodeWithCodeNum:_textF.text withPhoneNumStr:self.nPhoneStr withDicBlock:^(NSDictionary * dic, BOOL success) {
//        Y_SVP_DISMISS
//        if (success) {
//            if (![[dic allKeys]containsObject:@"authToken"]) {
//                Y_SVP_SHOW_ERR_MES(@"验证数据有误");
//                return;
//                }
//                NSString *authTokenS = [dic objectForKey:@"authToken"];
//                NSString *msgS = [dic objectForKey:@"msg"];
//                Y_SVP_SHOW_SUCCESS_MES(msgS);
//
//           //新的手机验证通过后的接口
//            Y_SVP_SHOW_MES_IsLoading_15Delay
//            [SafetyCenterViewModel changePhoneToSendLastAuthTokenCheckWithPhoneStr:self.nPhoneStr  withAuthTokenStr:authTokenS withDicBlock:^(NSDictionary * dic, BOOL success) {
//                Y_SVP_DISMISS
//                if (success) {
//                    for (UIViewController *vc in self.navigationController.childViewControllers) {
//                        if ([vc isKindOfClass:NSClassFromString(@"PersonSetVC")]) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [self.navigationController popToViewController:vc animated:YES];
//                            });
//                        }
//                    }
//                }
//            }];
//
//        }
//    }];
//    DLog(@"________________changePhoneToSendLastAuthTokenStr  ");
    /**
     url=http://222.178.212.28:9527/api/v1/proprietor/user/auth/check/code____{
        code = 0;
        data =     {
            authToken = c924574bb8424568b1c24eee99b78916;
            msg = "验证通过，请在1小时内完成操作";
        };
        message = "<null>";
     //////
     {
         "account":15999999999
     }
     authToken+ token
     */
    
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [SafetyCenterViewModel changePhoneToSendLastAuthTokenCheckWithPhoneStr:self.nPhoneStr  withCodeStr:_textF.text  withDicBlock:^(NSDictionary * dic, BOOL success) {
        //登录数据更改
        Y_SVP_DISMISS
        if (success) {
//            Y_SVP_SHOW_SUCCESS_MES(@"更改手机号成功！\n 用户需要重新登录。");
//            if ( [IsLoginTool share].save_Login_Type == IS_Login_Nomal) {//普通账号登录的用户 需要更换登录号码 三方登录的不做账号登录的view预设
//                [self changLoginVcTextWithPhoneStr:self.nPhoneStr];
//            }
//            [self exitAction];
//            //换号码后会登录过期 不popPersonSetVC 直接退出重登
            
//            for (UIViewController *vc in self.navigationController.childViewControllers) {
//                if ([vc isKindOfClass:NSClassFromString(@"PersonSetVC")]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.navigationController popToViewController:vc animated:YES];
//                    });
//                }
//            }
            
            [ZYProgressHUDTool showCustomHUDTextMessage:@"手机号修改成功" toView:self.view.window];
            [self changLoginVcTextWithPhoneStr:self.nPhoneStr];
            [ShareUserInfo sharedUserInfo].userInfo.mobile = self.nPhoneStr;
            [ShareUserInfo sharedUserInfo].userInfo.isBindMobile = YES;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:NSClassFromString(@"SafetyCenterVC")]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
    }];
  
}
- (void)exitAction{
    //登录状态
    [IsLoginTool share].save_Login_Type = IS_Login_NotLogin;
    //聊天连接关闭
    [[SocketRocketUtility instance]SRWebSocketClose];
    //页面
//    LoginVC *loginVC = [[LoginVC alloc]init];
    LoginAndRegiestVC *loginVC = [[LoginAndRegiestVC alloc] init];//20220514新版
    //重置本地存储数据
    [[ShareUserInfo sharedUserInfo] saveDefaultsLoginUserInfo:[UserModel new]];
    [[ShareUserInfo sharedUserInfo] saveDefaultsCityCommnuitInfo:[CommunityModel new]];
    [[ShareUserInfo sharedUserInfo] saveDefaultsPositioningInfo:[ZYPositioningModel new]];
    self.view.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.view.window makeKeyAndVisible];

}
//下次登录的数据
- (void)changLoginVcTextWithPhoneStr:(NSString *)accountStr{
    [[NSUserDefaults standardUserDefaults] setValue:accountStr forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ShareUserInfo sharedUserInfo].account = accountStr;
}
#pragma mark - 输入框监听

- (void)textFieldDidChange: (UITextField *)textF{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
