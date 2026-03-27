//
//  LoginPasswordSetVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "LoginPasswordSetVC.h"
//
#import "SafetyCenterViewModel.h"
@interface LoginPasswordSetVC ()
@property(nonatomic, strong) UIView *backView;
@property(nonatomic, strong) UITextField *pwdTF;

@property(nonatomic, strong) UITextField *sureTF;

@property(nonatomic, strong) UIView *lineV;

@property(nonatomic, strong) UIView *lineV1;

@property(nonatomic, strong) UILabel *remarkL;

@property(nonatomic, strong) UIButton *showBtn;

@property(nonatomic, strong) UIButton *sureBtn;

@end

@implementation LoginPasswordSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([ShareUserInfo sharedUserInfo].userInfo.isBindPassword) {
        self.title = @"修改登录密码";
    }else {
        self.title = @"设置登录密码";
    }
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}
//改密码
- (void)sureBtnAction{
    if (![_pwdTF.text isEqualToString:_sureTF.text]) {
        Y_SVP_SHOW_ERR_MES(@"密码不一致!");
        return;
    }
    
    __block NSString *pasW = _pwdTF.text;
    
    //限制2种格式 长度限制
    
    
    
//    [SafetyCenterViewModel changeLoginPasswordToSendPasswordStr:_pwdTF.text withDicBlock:^(NSDictionary * dic, BOOL success) {
//        if (success) {
//            [[NSUserDefaults standardUserDefaults] setValue:pasW forKey:@"password"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [ShareUserInfo sharedUserInfo].password = pasW;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                Y_SVP_SHOW_SUCCESS_MES(@"修改登录密码成功");
//                [self popVC];
//            });
//        }
//    }];
    [SafetyCenterViewModel changeLoginPasswordV2ToSendPasswordStr:self.pwdTF.text andVerifyCode:self.verifyCode withDicBlock:^(NSDictionary *dic, BOOL success) {
        if (success) {
            [[NSUserDefaults standardUserDefaults] setValue:pasW forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ShareUserInfo sharedUserInfo].password = pasW;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *hint;
                if ([ShareUserInfo sharedUserInfo].userInfo.isBindPassword) {
                    hint = @"登录密码修改成功";
                }else {
                    hint = @"登录密码设置成功";
                }
                [ZYProgressHUDTool showCustomHUDTextMessage:hint toView:self.view.window];
                [ShareUserInfo sharedUserInfo].userInfo.isBindPassword = YES;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:NSClassFromString(@"SafetyCenterVC")]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            });
        }
    }];
}
- (void)initView{
    [self.view addSubview:self.backView];
    //
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(10);
        make.height.offset(60);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.mas_equalTo(self.pwdTF.mas_bottom).offset(0);
        make.height.offset(0.5);
    }];
    
    
    [self.sureTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.mas_equalTo(self.lineV.mas_bottom).offset(0);
        make.height.offset(60);
    }];
    
    [self.lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.mas_equalTo(self.sureTF.mas_bottom).offset(0);
        make.height.offset(0.5);
    }];
    
    [self.remarkL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.mas_equalTo(self.lineV1.mas_bottom).offset(15);
    }];
    
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.mas_equalTo(self.remarkL.mas_bottom).offset(0);
        make.height.offset(30);
        make.width.offset(80);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.mas_equalTo(self.showBtn.mas_bottom).offset(25);
        make.height.offset(45);
        make.right.offset(-15);
    }];
    
    //
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView.superview).offset(10);
        make.left.equalTo(_backView.superview).offset(10);
        make.right.equalTo(_backView.superview).offset(-10);
        make.bottom.equalTo(_sureBtn.mas_top).offset(-10);
    }];
    
    //
    _pwdTF.textColor = [ThemeManager shareManager].mainTextColor;
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3]}];
    _pwdTF.attributedPlaceholder =  placeholderString;
    _sureTF.textColor = _pwdTF.textColor;
    NSMutableAttributedString *splaceholderString = [[NSMutableAttributedString alloc] initWithString:@"请确认新密码" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3]}];
    _sureTF.attributedPlaceholder =  splaceholderString;
    
    _lineV.backgroundColor = [ThemeManager shareManager].themeLineColor;
    _lineV1.backgroundColor = [ThemeManager shareManager].themeLineColor;
    
//    _remarkL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    
}

#pragma mark - 懒加载
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UITextField *)pwdTF{
    if (!_pwdTF) {
        _pwdTF = [[UITextField alloc] init];
        _pwdTF.font = FontSize_Vip_Nomail(15);
        _pwdTF.placeholder = @"请输入新密码";
        _pwdTF.tag = 0;
        [_pwdTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _pwdTF.secureTextEntry = YES;
        [self.view addSubview:_pwdTF];
    }
    return _pwdTF;
}


- (UITextField *)sureTF{
    if (!_sureTF) {
        _sureTF = [[UITextField alloc] init];
        _sureTF.font = FontSize_Vip_Nomail(15);
        _sureTF.placeholder = @"请确认新密码";
        _sureTF.tag = 0;
        [_sureTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _sureTF.secureTextEntry = YES;
        [self.view addSubview:_sureTF];
      
    }
    return _sureTF;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.view addSubview:_lineV];
    }
    return _lineV;
}

- (UIView *)lineV1{
    if (!_lineV1) {
        _lineV1 = [[UIView alloc] init];
        _lineV1.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.view addSubview:_lineV1];
    }
    return _lineV1;
}

- (UILabel *)remarkL{
    if (!_remarkL) {
        _remarkL = [[UILabel alloc] init];
        //_remarkL.text = @"必须是6-20个英文字母、数字或符号(除空格)，且字母、数字和标点至少包含两种";
        //_remarkL.text = @"6-12位字符，需要包含“大小写字母、数字、标点符号”至少两种";
        _remarkL.text = @"6-12个字符,至少包含大写字母或小写字母或数字两种!";
        _remarkL.numberOfLines = 0;
        _remarkL.font = FontSize_Vip_Nomail(12);
        _remarkL.textColor = [Tool getColorWithHexString:@"#999999"];
        _remarkL.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_remarkL];
    }
    return _remarkL;
}

- (UIButton *)showBtn{
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setTitle:@"显示密码" forState:UIControlStateNormal];
        _showBtn.titleLabel.font = FontSize_Vip_Nomail(12);
        [_showBtn setTitleColor:[Tool getColorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_showBtn setImage:[UIImage imageNamed:@"default"] forState:UIControlStateNormal];
        [_showBtn setImage:[UIImage imageNamed:@"Login_show_Select"] forState:UIControlStateSelected];
        _showBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [_showBtn addTarget:self action:@selector(showPassBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _showBtn.tag = 0;
        [self.view addSubview:_showBtn];
    }
    return _showBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[Tool getColorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:[Tool getColorWithHexString:@"#EEEEEE"]];
        [_sureBtn setImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.layer.cornerRadius = 3.5;
        _sureBtn.clipsToBounds = YES;
        _sureBtn.tag = 1;
        [self.view addSubview:_sureBtn];
    }
    return _sureBtn;
}

#pragma mark - 按钮监听
- (void)btnClicked: (UIButton *)sender{
    [self sureBtnAction];//确认按钮
}

- (void)showPassBtnClicked:(UIButton *)sender{//显示密码按钮
    sender.selected = !sender.selected;
    self.pwdTF.secureTextEntry = !sender.selected;
    self.sureTF.secureTextEntry = !sender.selected;
}

#pragma mark - 输入框监听

- (void)textFieldDidChange:(UITextField *)textF{
    if (self.pwdTF.text.length > 0 && self.sureTF.text.length > 0) {
        [self.sureBtn setBackgroundColor:[Tool getColorWithHexString:@"#2672F9"]];
        [self.sureBtn setTitleColor:[Tool getColorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.sureBtn.userInteractionEnabled = YES;
    }else{
        [self.sureBtn setBackgroundColor:[Tool getColorWithHexString:@"#EEEEEE"]];
        [self.sureBtn setTitleColor:[Tool getColorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.sureBtn.userInteractionEnabled = NO;
    }
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
