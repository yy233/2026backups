//
//  LoginViewWithTwoLoginFunction.m
//  Community
//
//  Created by 余莹 on 2021/3/24.
//

#import "LoginViewWithMoreLoginFunction.h"

static NSString *NomalText = @"已阅读并同意以下协议：";
static NSString *UserPolicyTitleText = @"《未来物服用户协议》、";
static NSString *PrivacyPolicyTitleText = @"《隐私协议》";
static NSString *UserPolicyKey = @"App_UserPolicy://";
static NSString *PrivacyPolicyKey = @"App_PrivacyPolicy://";

@implementation LoginViewWithMoreLoginFunction

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.topBackGroundView addSubview:self.codeLoginTopTextBtn];
        [self.topBackGroundView addSubview:self.accountLoginTopTextBtn];
        //
        [self.centerPasswordTextBackGroundView addSubview:self.codeTextField];
        [self.centerPasswordTextBackGroundView addSubview:self.codeAfterBtn];
        //
        self.topTitleLabel.text = @"";
        [self setTopBtnsUI];
        [self setCodeUI];
//        [self loginShowTypeChangeToCode:self.codeLoginTopTextBtn];//验证码登录 设置为初使状态
        [self loginShowTypeChangeToAccount:self.accountLoginTopTextBtn];// 设置为初使状态
        
        self.removeSelfBtn.hidden = YES;//0409游客模式隐藏
        [self privacyPolicyChangeUI];
  
        
    }
    return self;
}

//0427_ privacypolicyLabel privacypolicyChooseBtn 隐私协议行
- (void)privacyPolicyChangeUI{
    [self.privacypolicyLabel.superview addSubview:self.agreeBtn];
    [self.privacypolicyLabel.superview addSubview:self.privacypolicyTextView];
    WEAKSELF
    [_privacypolicyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.privacypolicyLabel);
        make.top.equalTo(weakSelf.privacypolicyLabel).offset(-5);
        make.bottom.equalTo(weakSelf.privacypolicyLabel).offset(5);
    }];
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.top.equalTo(weakSelf.privacypolicyLabel);
        make.right.equalTo(weakSelf.privacypolicyLabel.mas_left).offset(0);
    }];
    self.privacypolicyChooseBtn.hidden = YES;
    self.privacypolicyLabel.text = @"";
    self.privacypolicyTextView.text = @"";
    
    
    NSString *showStr = [NSString stringWithFormat:@"%@%@%@",NomalText,UserPolicyTitleText,PrivacyPolicyTitleText];
    self.privacypolicyTextView.attributedText = [self getThisPrivacyPolicyTextStr:showStr];
    if (  [ShareUserInfo sharedUserInfo].isHavaChooseAgreeBtn ) {//登录过 判断用的数据
        self.agreeBtn.selected = YES;
    }else{//无数据
        self.agreeBtn.selected = NO;
    }
}


//---隐私UI
- (UITextView *)privacypolicyTextView{
    if (!_privacypolicyTextView) {
        _privacypolicyTextView = [[UITextView alloc]init];
        _privacypolicyTextView.backgroundColor = [UIColor clearColor];
        _privacypolicyTextView.editable =  NO;
        _privacypolicyTextView.scrollEnabled = NO;
        _privacypolicyTextView.delegate = self; // 指定代理处理点击方法
    }
    return _privacypolicyTextView;
}
- (UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"weigouxuan_icon"] selectedImg:[UIImage imageNamed:@"wlw_gouxuan"]];
        [_agreeBtn addTarget:self action:@selector(agreeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}
- (void)agreeBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

- (NSMutableAttributedString *)getThisPrivacyPolicyTextStr:(NSString *)showAllStr{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:showAllStr];
    NSInteger allStrIndexNum = showAllStr.length;
    NSRange nomalRange = [showAllStr rangeOfString:NomalText];
    NSRange userPolicyRange = [showAllStr rangeOfString:UserPolicyTitleText];
    NSRange privacyPolicyRange = [showAllStr rangeOfString:PrivacyPolicyTitleText];
 
    //字体大小
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, allStrIndexNum)];
    //字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Y_ColorWith16FromRGB(0xFFFFFF) range:nomalRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Y_ColorWith16FromRGB(0x2672F9) range:userPolicyRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Y_ColorWith16FromRGB(0x2672F9) range:privacyPolicyRange];
    //link
    [attributedStr addAttribute:NSLinkAttributeName value:UserPolicyKey range:userPolicyRange];
    [attributedStr addAttribute:NSLinkAttributeName value:PrivacyPolicyKey range:privacyPolicyRange];
    return attributedStr;
}

//从登录页去协议页面
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if (URL.absoluteString == UserPolicyKey) {
        DLog(@"去用户协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_User;
        privacyVc.isLoginVcPushInToBool = YES;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
   
    }else if (URL.absoluteString == PrivacyPolicyKey){
        DLog(@"去隐私协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Privacy;
        privacyVc.isLoginVcPushInToBool = YES;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
    }else{
        return YES;
    }
    return YES;
}
 


#pragma mark ===== action
- (void)selfSubBtnTouchAction:(UIButton *)sender{
    if (sender.tag == LOGIN_BTN_TAG) {
        
        if (self.phoneStr.length==0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_phone_number)
            return;
        }
        if (self.passWordStr.length==0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_password_number)
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginViewbtnTouchAction:)]) {
            [self.delegate loginViewbtnTouchAction:sender];
        }
 
    }else if (sender.tag == LOGIN_BTN_TAG_CODE_LOGIN) {
        
        if (self.phoneStr.length==0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_phone_number)
            return;
        }
        if (self.codeStr.length==0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_code_number)
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginViewbtnTouchAction:)]) {
            [self.delegate loginViewbtnTouchAction:sender];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginViewbtnTouchAction:)]) {
            [self.delegate loginViewbtnTouchAction:sender];
        }
    }
  
}




#pragma mark ==== textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTextField) {
        self.passWordTextField.text = @"";
        return [ValidateUtil isMatchPhoneNumberFormat:textField range:range string:string];
    }
    if (textField == self.passWordTextField) {
//        return  [ValidateUtil isMatchPasswordFormat:textField range:range string:string];
    }
    return YES;
}
 
-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField == self.phoneTextField) {
        self.phoneStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (textField == self.passWordTextField) {
        self.passWordStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (textField == self.codeTextField) {
        self.codeStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

#pragma mark == ShowTypeChange Action
- (void)loginShowTypeChangeToCode:(UIButton *)sender{
    self.loginBtn.tag = LOGIN_BTN_TAG_CODE_LOGIN;
    if (sender.selected==YES) {
        return;
    }
    //__top
    [_codeLoginTopTextBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:24]];
    [_codeLoginTopTextBtn newAnBtnWithTextColor:[UIColor whiteColor]];
    _codeLoginTopTextBtn.selected = YES;
    //
    [_accountLoginTopTextBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:22]];
    [_accountLoginTopTextBtn newAnBtnWithTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
    _accountLoginTopTextBtn.selected = NO;
    //__code password
    _codeTextField.hidden = NO;
    _codeAfterBtn.hidden = NO;
    //
    self.passWordTextField.hidden = YES;
    self.passWordBeforeImg.hidden = YES;
    self.passWordAfterBtn.hidden = YES;
    
  
}
- (void)loginShowTypeChangeToAccount:(UIButton *)sender{
    self.loginBtn.tag = LOGIN_BTN_TAG;
    if (sender.selected==YES) {
        return;
    }
    //__top
    [_codeLoginTopTextBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:22]];
    [_codeLoginTopTextBtn newAnBtnWithTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
    _codeLoginTopTextBtn.selected = NO;
    //
    [_accountLoginTopTextBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:24]];
    [_accountLoginTopTextBtn newAnBtnWithTextColor:[UIColor whiteColor]];
    _accountLoginTopTextBtn.selected = YES;
    //__code password
    _codeTextField.hidden = YES;
    _codeAfterBtn.hidden = YES;
    //
    self.passWordTextField.hidden = NO;
    self.passWordBeforeImg.hidden = NO;
    self.passWordAfterBtn.hidden = NO;
   
    
}
#pragma mark ==  UI
- (void)setTopBtnsUI{
    [_codeLoginTopTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.topTitleLabel);
    }];
    [_accountLoginTopTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_codeLoginTopTextBtn.mas_right).offset(30);
        make.top.bottom.equalTo(self.topTitleLabel);
    }];
}

- (void)setCodeUI{
    [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.passWordTextField);
        make.left.equalTo(self.passWordTextField.superview).offset(5);
        make.right.equalTo(self.passWordTextField.mas_right).offset(-40);
    }];
    [_codeAfterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_codeTextField.mas_right);
        make.centerY.equalTo(_codeTextField.mas_centerY);
        make.height.offset(30);
        make.width.offset(80);
    }];
}
#pragma mark ==
- (UIButton *)codeLoginTopTextBtn{
    if (!_codeLoginTopTextBtn) {
        _codeLoginTopTextBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeLoginTopTextBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:24]];
        [_codeLoginTopTextBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_codeLoginTopTextBtn newAnBtnWithTextStr:@"验证码登录"];
        [_codeLoginTopTextBtn addTarget:self action:@selector(loginShowTypeChangeToCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeLoginTopTextBtn;
}
- (UIButton *)accountLoginTopTextBtn{
    if (!_accountLoginTopTextBtn) {
        _accountLoginTopTextBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accountLoginTopTextBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:24]];
        [_accountLoginTopTextBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_accountLoginTopTextBtn newAnBtnWithTextStr:@"账号登录"];
        [_accountLoginTopTextBtn addTarget:self action:@selector(loginShowTypeChangeToAccount:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accountLoginTopTextBtn;
}

- (UITextField*)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc]init];
        _codeTextField.font = [UIFont systemFontOfSize:16];
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.delegate = self;
        _codeTextField.textColor = [ThemeManager shareManager].loginModuleTextColor;
         NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
        _codeTextField.attributedPlaceholder = placeholderString;
        UIButton *clearBtn = [_codeTextField valueForKey:@"_clearButton"];
        [clearBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"textFieldClean"] forState:UIControlStateNormal];
    }
    return _codeTextField;
}
- (NSString*)codeStr{
    if (!_codeStr) {
        _codeStr = @"";
    }
    return _codeStr;
}
 
- (UIButton *)codeAfterBtn{
    if (!_codeAfterBtn) {
        _codeAfterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeAfterBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeAfterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _codeAfterBtn.tag = LOGIN_BTN_TAG_CODE_GetCode;
        [_codeAfterBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        _codeAfterBtn.backgroundColor = LoginViewBtnGradientColor(80, 24);
        _codeAfterBtn.layer.cornerRadius = 15;
        _codeAfterBtn.layer.masksToBounds = YES;
        _codeAfterBtn.clipsToBounds = YES;
        _codeAfterBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _codeAfterBtn;
}
#pragma mark ——————
//MARK: 倒计时
- (void)countdown {
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.codeAfterBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                [self.codeAfterBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                self.codeAfterBtn.backgroundColor = LoginViewBtnGradientColor(80, 24);
                self.codeAfterBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                 self.codeAfterBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                [self.codeAfterBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                self.codeAfterBtn.backgroundColor = [UIColor grayColor];
                self.codeAfterBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
