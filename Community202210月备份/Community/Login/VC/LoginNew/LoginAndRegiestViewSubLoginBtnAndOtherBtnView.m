//
//  LoginAndRegiestViewSubLoginBtnAndOtherBtnView.m
//  Community
//
//  Created by 余莹 on 2022/5/13.
//

#import "LoginAndRegiestViewSubLoginBtnAndOtherBtnView.h"
#import "LoginAndRegiestNewHeader.h"

@implementation LoginAndRegiestViewSubLoginBtnAndOtherBtnView
- (void)setThisViewShowType:(LoginAndRegiestVC_Show_Type)type{
    
    if (type == LoginAndRegiestVC_Show_Type_PasswordLogin) {
        [self.changeLoginTypeBtn newAnBtnWithTextStr:@"验证码登录"];
        self.forgotPasswordBtn.hidden = NO;
        
    }else{
        [_changeLoginTypeBtn newAnBtnWithTextStr:@"密码登录"];
        self.forgotPasswordBtn.hidden = YES;
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 130);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.loginBtn];
        [self addSubview:self.forgotPasswordBtn];
        [self addSubview:self.changeLoginTypeBtn];
        [self setBtnsUI];
    }
    return self;
}
 
- (void)setBtnsUI{
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_loginBtn.superview).offset(-2*26);
        make.centerX.equalTo(_loginBtn.superview);
        make.top.equalTo(_loginBtn.superview).offset(35);
        make.height.offset(50.0);
    }];
    [_forgotPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_loginBtn.mas_right);
        make.height.offset(20);
        make.width.offset(58);
        make.top.equalTo(_loginBtn.mas_bottom).offset(20);
    }];
    [_changeLoginTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_loginBtn.mas_left);
        make.height.offset(20);
        make.top.equalTo(_loginBtn.mas_bottom).offset(20);
    }];
}


#pragma mark ==

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn newAnBtnWithTextStr:@"登录"];
        [_loginBtn newAnBtnWithTextColor: [ThemeManager shareManager].loginModuleTextColor ];
        [_loginBtn newAnBtnWithFont: [UIFont boldSystemFontOfSize:18.0]];
        _loginBtn.layer.cornerRadius = 25.0;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.backgroundColor = LoginViewBtnGradientColor(Screen_W-(2*26), 50);
        _loginBtn.tag = Tag_LoginAndRegiest_MainLoginBtn + Tag_LoginAndRegiest_Base;
    }
    return _loginBtn;
}

- (UIButton *)forgotPasswordBtn{
    if (!_forgotPasswordBtn) {
        _forgotPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgotPasswordBtn newAnBtnWithTextStr:@"忘记密码"];
        [_forgotPasswordBtn newAnBtnWithTextColor: [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty ];
        [_forgotPasswordBtn newAnBtnWithFont: [UIFont systemFontOfSize:14]];
        _forgotPasswordBtn.tag = Tag_LoginAndRegiest_ForgetPasswordBtn + Tag_LoginAndRegiest_Base;
    }
    return _forgotPasswordBtn;
}

- (UIButton *)changeLoginTypeBtn{
    if (!_changeLoginTypeBtn) {
        _changeLoginTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeLoginTypeBtn newAnBtnWithTextStr:@""];
        [_changeLoginTypeBtn newAnBtnWithTextColor: [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty ];
        [_changeLoginTypeBtn newAnBtnWithFont: [UIFont systemFontOfSize:14]];
        _changeLoginTypeBtn.tag = Tag_LoginAndRegiest_ChangeLoginTypeBtn + Tag_LoginAndRegiest_Base;
    }
    return _changeLoginTypeBtn;
}
@end
