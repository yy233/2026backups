//
//  LoginView.m
//  test
//
//  Created by 余莹 on 2020/11/9.
//

#import "LoginView.h"
@interface LoginView () <UITextFieldDelegate>

@end

@implementation LoginView
 
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topBackGroundView];
        [self.topBackGroundView addSubview:self.removeSelfBtn];
        [self.topBackGroundView addSubview:self.topTitleLabel];
        [self.topBackGroundView addSubview:self.topDetailTitleLabel];
    
        [self addSubview:self.centerPhoneTextBackGroundView];
//        [self.centerPhoneTextBackGroundView addSubview:self.phoneBeforeLabel];
        [self.centerPhoneTextBackGroundView addSubview:self.phoneBeforeBtn];
        [self.centerPhoneTextBackGroundView addSubview:self.phoneTextField];
        [self.centerPhoneTextBackGroundView addSubview:self.centerPhoneTextLineView];
        
        [self addSubview:self.centerPasswordTextBackGroundView];
        [self.centerPasswordTextBackGroundView addSubview:self.passWordBeforeImg];
        [self.centerPasswordTextBackGroundView addSubview:self.passWordTextField];
        [self.centerPasswordTextBackGroundView addSubview:self.passWordAfterBtn];
        [self.centerPasswordTextBackGroundView addSubview:self.centerPasswordTextLineView];
        
        [self addSubview:self.loginBtn];
        [self addSubview:self.forgotPasswordBtn];
        [self addSubview:self.messageAuthenticationBtn];
        [self addSubview:self.registBtn];
        
        [self addSubview:self.privacypolicyLabel];
        [self addSubview:self.privacypolicyChooseBtn];
      
        [self addSubview:self.bottomBackGroundView];
        [self.bottomBackGroundView addSubview:self.bottomTitleLabel];
        [self.bottomBackGroundView addSubview:self.appleLoginBtn];
        [self.bottomBackGroundView addSubview:self.zfbLoginBtn];
        [self.bottomBackGroundView addSubview:self.wxLoginBtn];

      
    }
    return self;
}
-(void)setIsLoginView:(BOOL)isLoginView{
    _isLoginView = isLoginView;
    [self setUI];
}
#pragma mark ==
- (void)loginViewShowOrHidenPassWordTextFieldText:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _passWordTextField.secureTextEntry = NO;
    }else{
        _passWordTextField.secureTextEntry = YES;
    }
}
#pragma mark ==
- (void)setUI{
    /**
     暂时取消复用 仅仅用于loginview
     */
    if (_isLoginView==YES) {
        [self topUI];
        [self centerUI];
        [self bottomUI];
//        _loginBtn.tag = LOGIN_BTN_TAG;
    }else{
//        [self topUI];
//        [self centerUI];
//        _forgotPasswordBtn.hidden = YES;
//        _registBtn.hidden = YES;
//        _messageAuthenticationBtn.hidden = YES;
//        _topTitleLabel.text = @"验证码登录/注册";
//        _topDetailTitleLabel.text = @"未注册用户将自动创建账号";
//        [_loginBtn setTitle:@"注册" forState:UIControlStateNormal];
//        _loginBtn.tag = REGIST_YSE_BTN_TAG;
    }
  
    [self setTextLabel];
}
#pragma mark === textField数据
- (void)cleanAccountAndPasswordTextFiled{
    self.phoneTextField.text = @"";
    self.phoneStr = @"";
    self.passWordTextField.text = @"";
    self.passWordStr = @"";
}
- (void)setTextLabel{
    [[ShareUserInfo sharedUserInfo] getDefaultsLoginUserInfo];
    if ([ShareUserInfo sharedUserInfo].account.length != 0) {
        self.phoneTextField.text = [ShareUserInfo sharedUserInfo].account;
        self.phoneStr = [ShareUserInfo sharedUserInfo].account;
    }
    if ([ShareUserInfo sharedUserInfo].password.length != 0) {
        self.passWordTextField.text = [ShareUserInfo sharedUserInfo].password;
        self.passWordStr = [ShareUserInfo sharedUserInfo].password;
    }//没有数据
    
    if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"account"])) {
        self.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
        self.phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    }
    if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"password"])) {
        self.passWordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        self.passWordStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    }
}


#pragma mark ==== textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"%@",textField);
}

//这是ios7的一个小bug  输入汉字 进行联想的时候 不走 shouldChangeCharactersInRange方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTextField) {
        self.passWordTextField.text = @"";
        return [ValidateUtil isMatchPhoneNumberFormat:textField range:range string:string];
    }else   if (textField == self.passWordTextField) {
       // return  [ValidateUtil isMatchPasswordFormat:textField range:range string:string];
        return YES;
    }else{
        return YES;
    }
}
 
-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField == self.phoneTextField) {
        _phoneStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (textField == self.passWordTextField) {
        _passWordStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

//在这里处理文字变化的监控 中文去掉
- (void)textFieldDidChanged:(UITextField *)textField
{
    if (textField == self.passWordTextField) {
        DLog(@"%@",textField);
        if (textField.markedTextRange == nil) {
        }
        UITextRange *selectedRange = textField.markedTextRange;
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) { // 没有高亮选择的字
            textField.text = [self filterCharactor:textField.text withRegex:@"[\u4e00-\u9fa5]{0,}$"];//@"[^\u4e00-\u9fa5]"];
        }else{
        }
        _passWordStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}
//根据正则，过滤特殊字符 @"[\u4e00-\u9fa5]{0,}$" 过滤中文
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}
 
#pragma mark ===
- (void)topUI{
    //top
    [_topBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackGroundView.superview.mas_top).offset(status_height);
        make.width.equalTo(_topBackGroundView.superview.mas_width).offset(-50);
        make.centerX.equalTo(_topBackGroundView.superview.mas_centerX);
        make.height.offset(200);
    }];
    [_removeSelfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackGroundView.mas_top).offset(40);
        make.left.equalTo(_topBackGroundView.mas_left);
        make.width.offset(40);
        make.height.offset(24);
    }];
    [_topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_removeSelfBtn.mas_bottom).offset(30);
        make.left.equalTo(_topBackGroundView.mas_left);
        make.right.equalTo(_topBackGroundView.mas_right);
        make.height.offset(30);
    }];
    [_topDetailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTitleLabel.mas_bottom).offset(15);
        make.left.equalTo(_topBackGroundView.mas_left);
        make.right.equalTo(_topBackGroundView.mas_right);
        make.height.offset(12);
    }];
    [self resgistBtnMas];//注册btn 变位置了
}
- (void)resgistBtnMas{
    [_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_removeSelfBtn.mas_centerY);
        make.right.equalTo(_topBackGroundView.mas_right);
        make.width.offset(70);
        make.height.offset(36);
    }];
}
- (void)centerUI{
    _messageAuthenticationBtn.backgroundColor = [UIColor blueColor];
    _messageAuthenticationBtn.hidden = YES;
    //center-1
    [_centerPhoneTextBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackGroundView.mas_bottom).offset(10);
        make.width.equalTo(_topBackGroundView.mas_width);
        make.centerX.equalTo(_topBackGroundView.mas_centerX);
        make.height.offset(70);
    }];
    [_phoneBeforeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerPhoneTextBackGroundView.mas_centerY);
        make.left.equalTo(_centerPhoneTextBackGroundView.mas_left);
        make.width.offset(45);//
        make.height.offset(40);
    }];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerPhoneTextBackGroundView.mas_centerY);
        make.left.equalTo(_phoneBeforeBtn.mas_right).offset(5);
        make.right.equalTo(_centerPhoneTextBackGroundView.mas_right);
        make.height.offset(40);
    }];
    [_centerPhoneTextLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerPhoneTextBackGroundView.mas_bottom);
        make.width.equalTo(_centerPhoneTextBackGroundView.mas_width);
        make.height.offset(1);
        make.centerX.equalTo(_centerPhoneTextBackGroundView);
    }];
    
    //center-2
    [_centerPasswordTextBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerPhoneTextBackGroundView.mas_bottom).offset(1);
        make.width.equalTo(_centerPhoneTextBackGroundView.mas_width);
        make.centerX.equalTo(_centerPhoneTextBackGroundView.mas_centerX);
        make.height.offset(70);
    }];

    [_passWordBeforeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerPasswordTextBackGroundView.mas_centerY);
        make.left.equalTo(_centerPasswordTextBackGroundView.mas_left);
        make.centerX.equalTo(_phoneBeforeBtn.mas_centerX);
        make.height.offset(20);
    }];
    [_passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerPasswordTextBackGroundView.mas_centerY);
        make.left.equalTo(_phoneTextField.mas_left);
        make.right.equalTo(_centerPasswordTextBackGroundView.mas_right).offset(-40);//40w
        make.height.offset(40);
    }];
    [_passWordAfterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerPasswordTextBackGroundView.mas_centerY);
        make.right.equalTo(_centerPasswordTextBackGroundView.mas_right);
        make.height.offset(40);//
        make.width.offset(40);
    }];
    [_centerPasswordTextLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerPasswordTextBackGroundView.mas_bottom);
        make.width.equalTo(_centerPasswordTextBackGroundView.mas_width);
        make.height.offset(1);
        make.centerX.equalTo(_centerPasswordTextLineView);
    }];
    if (kScreenH>800) {
        //login
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_centerPasswordTextBackGroundView.mas_bottom).offset(60);
            make.centerX.equalTo(_centerPasswordTextBackGroundView.mas_centerX);
            make.height.offset(50);
            make.width.equalTo(_loginBtn.superview.mas_width).multipliedBy(0.8);
        }];
        //forget 更改

        [_forgotPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_loginBtn.mas_bottom).offset(30);
            make.right.equalTo(_loginBtn.mas_right);
            make.height.offset(25);
        }];
     
    }else{
        //login
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_centerPasswordTextBackGroundView.mas_bottom).offset(37);
            make.centerX.equalTo(_centerPasswordTextBackGroundView.mas_centerX);
            make.height.offset(50);
            make.width.equalTo(_loginBtn.superview.mas_width).multipliedBy(0.8);
        }];
        //forget 更改

        [_forgotPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_loginBtn.mas_bottom).offset(20);
            make.right.equalTo(_loginBtn.mas_right);
            make.height.offset(25);
        }];
    
    }
  
    //短信验证码登录 更改隐藏
    [_messageAuthenticationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_forgotPasswordBtn.mas_centerY);
        make.left.equalTo(_forgotPasswordBtn.mas_right);
        make.height.offset(25);
    }];
}

- (void)bottomUI{
    [self bottomUIWithPrivacy];//隐私协议
    [_bottomBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_forgotPasswordBtn.mas_bottom).offset(20);
        make.centerX.equalTo(_bottomBackGroundView.superview.mas_centerX);
        make.width.equalTo(_bottomBackGroundView.superview.mas_width).multipliedBy(0.7);
        make.bottom.equalTo(_privacypolicyLabel.mas_top).offset(-20);
        make.height.mas_lessThanOrEqualTo(_bottomBackGroundView.superview).multipliedBy(0.2);//高度的屏幕做限制 会让topbackv拉伸适应
    }];
    [_bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomBackGroundView.mas_left);
        make.right.equalTo(_bottomBackGroundView.mas_right);
        make.height.offset(15);
        make.bottom.equalTo(_bottomBackGroundView.mas_bottom).offset(-10);
    }];

    [self thridLoginIconShowUI];
}

- (void)bottomUIWithPrivacy{
    [_privacypolicyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_privacypolicyLabel.superview.mas_bottom).offset(-20);
        make.centerX.equalTo(_privacypolicyLabel.superview.mas_centerX);
        make.height.offset(35);
        make.width.equalTo(_privacypolicyLabel.superview.mas_width).multipliedBy(0.8);
    }];
    [_privacypolicyChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_privacypolicyLabel);
    }];
}

- (void)thridLoginIconShowUI{
    //三个
//    [_zfbLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_bottomBackGroundView.mas_centerX);
//        make.centerY.equalTo(_bottomBackGroundView.mas_centerY).offset(-20);
//        make.width.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
//        make.height.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
//    }];
//    [_wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_bottomBackGroundView.mas_left);
//        make.height.equalTo(_zfbLoginBtn.mas_height);
//        make.width.equalTo(_zfbLoginBtn.mas_width);
//        make.centerY.equalTo(_zfbLoginBtn.mas_centerY);
//    }];
//    [_qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_bottomBackGroundView.mas_right);
//        make.height.equalTo(_zfbLoginBtn.mas_height);
//        make.width.equalTo(_zfbLoginBtn.mas_width);
//        make.centerY.equalTo(_zfbLoginBtn.mas_centerY);
//    }];
     //支付宝微信 两个
//    if ([WXApi isWXAppInstalled]){
//         //安装了微信的处理
//        [_zfbLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_bottomBackGroundView.mas_centerX).offset(self.bounds.size.width*0.7/4);
//            make.centerY.equalTo(_bottomBackGroundView.mas_centerY).offset(-20);
//            make.width.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
//            make.height.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
//        }];
//        [_wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_bottomBackGroundView.mas_centerX).offset(-self.bounds.size.width*0.7/4);
//            make.height.equalTo(_zfbLoginBtn.mas_height);
//            make.width.equalTo(_zfbLoginBtn.mas_width);
//            make.centerY.equalTo(_zfbLoginBtn.mas_centerY);
//        }];
//     } else {
//         //没有安装微信的处理
//         //支付宝 1个
//        [_zfbLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_bottomBackGroundView.mas_centerX);
//            make.centerY.equalTo(_bottomBackGroundView.mas_centerY);
//            make.width.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.3);
//            make.height.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.3);
//        }];
//     }
    //        [_zfbLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.centerX.equalTo(_bottomBackGroundView.mas_centerX);
    //            make.centerY.equalTo(_bottomBackGroundView.mas_centerY);
    //            make.width.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.3);
    //            make.height.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.3);
    //        }];
    self.bottomTitleLabel.hidden = YES;
}

//- (void)showOrNotShowWxDeal:(BOOL)isShowView{
//    self.bottomTitleLabel.hidden = NO;
//    if (isShowView) {
//        //安装了微信的处理
//       [_zfbLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.centerX.equalTo(_bottomBackGroundView.mas_centerX).multipliedBy(0.5);
//           make.centerY.equalTo(_bottomBackGroundView.mas_centerY).offset(-20);
//           make.width.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
//           make.height.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
//       }];
//       [_wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.centerX.equalTo(_bottomBackGroundView.mas_centerX).multipliedBy(1.5);
//           make.height.equalTo(_zfbLoginBtn.mas_height);
//           make.width.equalTo(_zfbLoginBtn.mas_width);
//           make.centerY.equalTo(_zfbLoginBtn.mas_centerY);
//       }];
//        _wxLoginBtn.hidden = NO;
//    }else{
//      //  支付宝 1个
//       [_zfbLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.centerX.equalTo(_bottomBackGroundView.mas_centerX);
//           make.centerY.equalTo(_bottomBackGroundView.mas_centerY).offset(-10);
//           make.width.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
//           make.height.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
//       }];
//        _wxLoginBtn.hidden = YES;
//    }
//}

 
#pragma mark == 按钮数量处理 改背景处理
- (void)showOrNotShowDeal:(BOOL)isShowView{
    if (isShowView) {
        self.bottomBackGroundView.hidden = NO;
        [self showOrNotShowSubBtnDeal:isShowView];
    }else{
        self.bottomBackGroundView.hidden = YES;
    }
}
#pragma mark == 按钮数量处理
- (void)showOrNotShowSubBtnDeal:(BOOL)isShowView{
    self.bottomTitleLabel.hidden = NO;
    if (isShowView){
        //isShowView = [WXApi isWXAppInstalled] ? YES :NO;//普通版本 微信安装后再显示
    }
    if (isShowView) {//3个
        
        [_appleLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomBackGroundView.mas_centerX).multipliedBy(0.33);
            make.centerY.equalTo(_bottomBackGroundView.mas_centerY).offset(-20);
            make.width.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
            make.height.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
        }];
        [_zfbLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomBackGroundView.mas_centerX).multipliedBy(1);
            make.height.equalTo(_appleLoginBtn.mas_height);
            make.width.equalTo(_appleLoginBtn.mas_width);
            make.centerY.equalTo(_appleLoginBtn.mas_centerY);
        }];
        [_wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomBackGroundView.mas_centerX).multipliedBy(1.67);
            make.height.equalTo(_appleLoginBtn.mas_height);
            make.width.equalTo(_appleLoginBtn.mas_width);
            make.centerY.equalTo(_appleLoginBtn.mas_centerY);
        }];
       
          _wxLoginBtn.hidden = NO;
      
    }else{ //两个

        [_appleLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomBackGroundView.mas_centerX).multipliedBy(0.5);
            make.centerY.equalTo(_bottomBackGroundView.mas_centerY).offset(-20);
            make.width.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
            make.height.equalTo(_bottomBackGroundView.mas_width).multipliedBy(0.2);
        }];
        [_zfbLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomBackGroundView.mas_centerX).multipliedBy(1.5);
            make.height.equalTo(_appleLoginBtn.mas_height);
            make.width.equalTo(_appleLoginBtn.mas_width);
            make.centerY.equalTo(_appleLoginBtn.mas_centerY);
        }];
         _wxLoginBtn.hidden = YES;
    }
}
#pragma mark ===== action
- (void)selfSubBtnTouchAction:(UIButton *)sender{
    if (sender.tag == LOGIN_BTN_TAG) {
        if (_phoneStr.length==0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_phone_number)

            return;
        }
        if (_passWordStr.length==0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_password_number)
            return;
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(loginViewbtnTouchAction:)]) {
            [_delegate loginViewbtnTouchAction:sender];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(loginViewbtnTouchAction:)]) {
            [_delegate loginViewbtnTouchAction:sender];
        }
    }
  
}

#pragma mark ===== getter
- (UIView *)topBackGroundView{
    if (!_topBackGroundView) {
        _topBackGroundView = [[UIView alloc]init];
    }
    return _topBackGroundView;
}
- (UIButton *)removeSelfBtn{
    if (!_removeSelfBtn) {
        _removeSelfBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeSelfBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"login_close_slices"] forState:UIControlStateNormal];
        _removeSelfBtn.tag = REMOVE_SELF_BTN_TAG;
        [_removeSelfBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeSelfBtn;
}
- (UILabel *)topTitleLabel{
    if (!_topTitleLabel) {
        _topTitleLabel = [[UILabel alloc]init];
        _topTitleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _topTitleLabel.font = [UIFont boldSystemFontOfSize:32];
        _topTitleLabel.text = @"帐号密码登录";
    }
    return _topTitleLabel;
}
- (UILabel *)topDetailTitleLabel{
    if (!_topDetailTitleLabel) {
        _topDetailTitleLabel = [[UILabel alloc]init];
        _topDetailTitleLabel.textColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty;
        _topDetailTitleLabel.font = [UIFont systemFontOfSize:13];
        _topDetailTitleLabel.text = @"请使用帐号登录";
 
    }
    return _topDetailTitleLabel;
}
- (UIView *)centerPhoneTextBackGroundView{
    if (!_centerPhoneTextBackGroundView) {
        _centerPhoneTextBackGroundView = [[UIView alloc]init];
    }
    return  _centerPhoneTextBackGroundView;
}
//phoneBeforeLabel 弃用
- (UILabel *)phoneBeforeLabel{
    if (!_phoneBeforeLabel) {
        _phoneBeforeLabel = [[UILabel alloc]init];
        _phoneBeforeLabel.text = @"+86 "; //[ThemeImg loginModuleThemeImageWithBaseName:@"skip"]
        _phoneBeforeLabel.font = [UIFont systemFontOfSize:16];
        _phoneBeforeLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
    }
    return _phoneBeforeLabel;
}
- (UIButton *)phoneBeforeBtn{
    if (!_phoneBeforeBtn) {
        _phoneBeforeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneBeforeBtn setTitle:@"+86" forState:UIControlStateNormal];
        _phoneBeforeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_phoneBeforeBtn setTitleColor:[ThemeManager shareManager].loginModuleTextColor forState:UIControlStateNormal];
        [_phoneBeforeBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"skip"] forState:UIControlStateNormal];
        _phoneBeforeBtn.frame = CGRectMake(0, 0, 45, 40);
        [_phoneBeforeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_phoneBeforeBtn.imageView.bounds.size.width-5, 0, _phoneBeforeBtn.imageView.bounds.size.width)];
        [_phoneBeforeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _phoneBeforeBtn.titleLabel.bounds.size.width+5, 0, -_phoneBeforeBtn.titleLabel.bounds.size.width)];//5间隔
     }
    return _phoneBeforeBtn;
}
- (UITextField*)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.font = [UIFont systemFontOfSize:16];
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.delegate = self;
        [_phoneTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        _phoneTextField.textColor = [ThemeManager shareManager].loginModuleTextColor;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
        _phoneTextField.attributedPlaceholder = placeholderString;
        UIButton *clearBtn = [_phoneTextField valueForKey:@"_clearButton"];
        [clearBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"textFieldClean"] forState:UIControlStateNormal];
 
    }
    return _phoneTextField;
}

- (UIView *)centerPhoneTextLineView{
    if (!_centerPhoneTextLineView) {
        _centerPhoneTextLineView = [[UIView alloc]init];
        _centerPhoneTextLineView.backgroundColor = Color_TextFieldBottomLine;
    }
    return _centerPhoneTextLineView;
}

- (UIView *)centerPasswordTextBackGroundView{
    if (!_centerPasswordTextBackGroundView) {
        _centerPasswordTextBackGroundView = [[UIView alloc]init];
    }
    return _centerPasswordTextBackGroundView;
}
- (UITextField*)passWordTextField{
    if (!_passWordTextField) {
        _passWordTextField = [[UITextField alloc]init];
        _passWordTextField.font = [UIFont systemFontOfSize:16];
        _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordTextField.delegate = self;
        [_passWordTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        _passWordTextField.textColor = [ThemeManager shareManager].loginModuleTextColor;
         NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入登录密码" attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
        _passWordTextField.attributedPlaceholder = placeholderString;
        _passWordTextField.secureTextEntry = YES;
        UIButton *clearBtn = [_passWordTextField valueForKey:@"_clearButton"];
        [clearBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"textFieldClean"] forState:UIControlStateNormal];
    }
    return _passWordTextField;
}
- (UIImageView *)passWordBeforeImg{
    if (!_passWordBeforeImg) {
        _passWordBeforeImg = [[UIImageView alloc]init];
        _passWordBeforeImg.image = [ThemeImg loginModuleThemeImageWithBaseName:@"suo"];
        _passWordBeforeImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _passWordBeforeImg;
}
- (UIButton *)passWordAfterBtn{
    if (!_passWordAfterBtn) {
        _passWordAfterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passWordAfterBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"hide"] forState:UIControlStateNormal];
        [_passWordAfterBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"show"] forState:UIControlStateSelected];
        [_passWordAfterBtn addTarget:self action:@selector(loginViewShowOrHidenPassWordTextFieldText:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passWordAfterBtn;
}
- (UIView *)centerPasswordTextLineView{
    if (!_centerPasswordTextLineView) {
        _centerPasswordTextLineView = [[UIView alloc]init];
        _centerPasswordTextLineView.backgroundColor = Color_TextFieldBottomLine;
     }
    return _centerPasswordTextLineView;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.titleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _loginBtn.layer.cornerRadius = 25;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        _loginBtn.tag = LOGIN_BTN_TAG;
        [_loginBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.backgroundColor = LoginViewBtnGradientColor(Screen_W*0.8, 50);
    }
    return _loginBtn;
}

- (UIButton *)forgotPasswordBtn{
    if (!_forgotPasswordBtn) {
        _forgotPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgotPasswordBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        _forgotPasswordBtn.tag = FORGET_PASSWORD_TAG;
        _forgotPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_forgotPasswordBtn setTitleColor:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty forState:UIControlStateNormal];
        [_forgotPasswordBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPasswordBtn;
}
- (UIButton *)messageAuthenticationBtn{
    if (!_messageAuthenticationBtn) {
        _messageAuthenticationBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageAuthenticationBtn setTitle:@"短信验证码登录" forState:UIControlStateNormal];
        [_messageAuthenticationBtn setTitleColor:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty forState:UIControlStateNormal];
        _messageAuthenticationBtn.tag = LOGIN_SUBBTN_GO_USE_CODE_LOGIN_VC_BTN_TAG;//短信验证码登录
        _messageAuthenticationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_messageAuthenticationBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageAuthenticationBtn;
}

- (UIButton *)registBtn{
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_registBtn setTitleColor:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty forState:UIControlStateNormal];
        _registBtn.tag = LOGIN_SUBBTN_GO_REGIST_VC_BTN_TAG;
        [_registBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        _registBtn.layer.cornerRadius = 18;
        _registBtn.backgroundColor = Y_RGBA(20, 44, 89, 0.9);
    }
    return _registBtn; 
}
#pragma mark =====
- (UIView *)bottomBackGroundView{
    if (!_bottomBackGroundView) {
        _bottomBackGroundView = [[UIView alloc]init];
    }
    return _bottomBackGroundView;
}
- (UILabel *)bottomTitleLabel{
    if (!_bottomTitleLabel) {
        _bottomTitleLabel = [[UILabel alloc]init];
        _bottomTitleLabel.text = @"————  第三方登录  ————";
        _bottomTitleLabel.textColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty;
        _bottomTitleLabel.font = [UIFont systemFontOfSize:14];
        _bottomTitleLabel.numberOfLines = 1;
        _bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomTitleLabel;
}
- (UIButton *)wxLoginBtn{
    if (!_wxLoginBtn) {
        _wxLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wxLoginBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"weixin"] forState:UIControlStateNormal];
        _wxLoginBtn.tag = WXLOGIN_BTN_TAG;
        [_wxLoginBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wxLoginBtn;
}
- (UIButton *)zfbLoginBtn{
    if (!_zfbLoginBtn) {
        _zfbLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zfbLoginBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"zhifubao"] forState:UIControlStateNormal];
        _zfbLoginBtn.tag = ZFBLOGIN_BTN_TAG;
        [_zfbLoginBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zfbLoginBtn;
}
- (UIButton *)appleLoginBtn{
    if (!_appleLoginBtn) {
        _appleLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_appleLoginBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"Apple"] forState:UIControlStateNormal];
        _appleLoginBtn.tag = APPLELOGIN_BTN_TAG;
        [_appleLoginBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appleLoginBtn; 
}

//- (ASAuthorizationAppleIDButton *)appleLoginBtn{
//        if (!_appleLoginBtn) {
//            _appleLoginBtn = [[ASAuthorizationAppleIDButton alloc]initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleWhite];
////            [_appleLoginBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"Apple"] forState:UIControlStateNormal];
//            _appleLoginBtn.tag = APPLELOGIN_BTN_TAG;
//            [_appleLoginBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
//    return _appleLoginBtn;
//}
- (UILabel *)privacypolicyLabel{
    if (!_privacypolicyLabel) {
        _privacypolicyLabel = [[UILabel alloc]init];
        _privacypolicyLabel.text = @"登录/注册即为已经阅读并同意《隐私政策》";
        _privacypolicyLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _privacypolicyLabel.font = [UIFont systemFontOfSize:11];
        _privacypolicyLabel.numberOfLines = 2;
        _privacypolicyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _privacypolicyLabel;
}
- (UIButton *)privacypolicyChooseBtn{
    if (!_privacypolicyChooseBtn) {
        _privacypolicyChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_privacypolicyChooseBtn setTitle:@"" forState:UIControlStateNormal];
        _privacypolicyChooseBtn.tag = Privacypolicy_CHOOSE_BTN_TAG;
        [_privacypolicyChooseBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privacypolicyChooseBtn;
}
#pragma mark === str
- (NSString*)phoneStr{
    if (!_phoneStr) {
        _phoneStr = @"";
    }
    return _phoneStr;
}
- (NSString *)passWordStr{
    if (!_passWordStr) {
        _passWordStr = @"";
    }
    return _passWordStr;
}
@end
