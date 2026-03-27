//
//  PassWordSetView.m
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import "FirstPassWordSetView.h"
@interface FirstPassWordSetView () <UITextFieldDelegate>

@property (nonatomic,strong) UIView *centerPhoneTextBackGroundView;
@property (nonatomic,strong) UIImageView *phoneBefreImg;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UIView *centerPhoneTextLineView;

@property (nonatomic,strong) UIView *centerPasswordTextBackGroundView;
@property (nonatomic,strong) UITextField *passWordTextField;
@property (nonatomic,strong) UIImageView *passWordBeforeImg;
@property (nonatomic,strong) UIButton *passWordAfterBtn;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIView *centerPasswordTextLineView;
@property (nonatomic,strong) UILabel *centerBottomLabel;

@property (nonatomic,strong) UIButton *forgotPasswordBtn;
@property (nonatomic,strong) UIButton *messageAuthenticationBtn;
@property (nonatomic,strong) UIButton *registBtn;

@property (nonatomic,strong) UIButton *prvacyBtn;



@end

@implementation FirstPassWordSetView


-(instancetype)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];
   if (self) {
       [self addSubview:self.topBackGroundView];
       [self.topBackGroundView addSubview:self.removeSelfBtn];
       [self.topBackGroundView addSubview:self.topTitleLabel];
       [self.topBackGroundView addSubview:self.topDetailTitleLabel];
   
       [self addSubview:self.centerPhoneTextBackGroundView];
       [self.centerPhoneTextBackGroundView addSubview:self.phoneBefreImg];
       [self.centerPhoneTextBackGroundView addSubview:self.centerBottomLabel];
       [self.centerPhoneTextBackGroundView addSubview:self.phoneTextField];
       [self.centerPhoneTextBackGroundView addSubview:self.centerPhoneTextLineView];
       
       [self addSubview:self.centerPasswordTextBackGroundView];
       [self.centerPasswordTextBackGroundView addSubview:self.passWordBeforeImg];
       [self.centerPasswordTextBackGroundView addSubview:self.passWordTextField];
       [self.centerPasswordTextBackGroundView addSubview:self.passWordAfterBtn];
       [self.centerPasswordTextBackGroundView addSubview:self.centerPasswordTextLineView];
       [self addSubview:self.loginBtn];
       [self addSubview:self.prvacyBtn];
       [self setUI];
   }
   return self;
}
  
- (void)setUI{
    [self topUI];
    [self centerUI];
    [self bottomUI];
    _prvacyBtn.hidden = YES;//隐私协议
}

#pragma mark ====
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField == self.phoneTextField) {
//        return [ValidateUtil isMatchPasswordFormat:textField range:range string:string];
//    }
//    if (textField == self.passWordTextField) {
//        return [ValidateUtil isMatchPasswordFormat:textField range:range string:string];
//    }
    return YES;
}
-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField == self.phoneTextField) {
        _passwordOneStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (textField == self.passWordTextField) {
        _passwordTwoStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

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
}
- (void)centerUI{
    //center-1
    [_centerPhoneTextBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackGroundView.mas_bottom).offset(10);
        make.width.equalTo(_topBackGroundView.mas_width);
        make.centerX.equalTo(_topBackGroundView.mas_centerX);
        make.height.offset(70);
    }];
    [_phoneBefreImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerPhoneTextBackGroundView.mas_centerY);
        make.left.equalTo(_centerPhoneTextBackGroundView.mas_left);
        make.width.offset(40);
        make.height.offset(20);
    }];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerPhoneTextBackGroundView.mas_centerY);
        make.left.equalTo(_phoneBefreImg.mas_right);
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
        make.width.offset(40);
        make.height.offset(20);
    }];
    [_passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerPasswordTextBackGroundView.mas_centerY);
        make.left.equalTo(_phoneTextField.mas_left);
        make.right.equalTo(_centerPasswordTextBackGroundView.mas_right).offset(-40);
        make.height.offset(40);
    }];
     
    [_centerPasswordTextLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerPasswordTextBackGroundView.mas_bottom);
        make.width.equalTo(_centerPasswordTextBackGroundView.mas_width);
        make.height.offset(1);
        make.centerX.equalTo(_centerPasswordTextLineView);
    }];
    [_centerBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerPasswordTextLineView.mas_bottom).offset(15);
        make.width.equalTo(_centerPasswordTextLineView.mas_width);
        make.height.offset(15);
        make.centerX.equalTo(_centerPasswordTextLineView);
    }];
    
    //login
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerBottomLabel.mas_bottom).offset(20);
        make.centerX.equalTo(_centerPasswordTextBackGroundView.mas_centerX);
        make.height.offset(50);
        make.width.equalTo(_loginBtn.superview.mas_width).multipliedBy(0.8);
    }];
    
    //forget
    [_forgotPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(10);
        make.width.equalTo(_loginBtn.mas_width).multipliedBy(0.3);
        make.height.equalTo(_loginBtn.mas_height).multipliedBy(0.5);
        make.left.equalTo(_loginBtn.mas_left);
    }];
    
    //regist
    [_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(10);
        make.width.equalTo(_loginBtn.mas_width).multipliedBy(0.3);
        make.height.equalTo(_loginBtn.mas_height).multipliedBy(0.5);
        make.left.equalTo(_forgotPasswordBtn.mas_right);
    }];
}

- (void)bottomUI{
    [_prvacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_prvacyBtn.superview.mas_bottom).offset(-20);
        make.centerX.equalTo(_prvacyBtn.superview.mas_centerX);
        make.height.offset(35);
        make.width.equalTo(_prvacyBtn.superview.mas_width).multipliedBy(0.8);
    }];
}
#pragma mark ===== action
- (void)selfSubBtnTouchAction:(UIButton *)sender{
    
    if (sender.tag == REGIST_SET_PASSWORD_FINISH_BTN_TAG) {
        if (![self.phoneTextField.text isEqualToString:self.passWordTextField.text]) {
            Y_SVP_SHOW_ERR_MES(PASSWORD_ERR_IS_DIFFERENT_STR)
            return;
        }
        
//        if (![ValidateUtil isMachPasswordJudgeBeforeSendingAgainWithString:self.phoneTextField.text]) {
//            Y_SVP_SHOW_ERR_MES(PASSWORD_ERR_FORMAT_STR)
//            return;
//        }
//        if (![ValidateUtil isMachPasswordJudgeBeforeSendingAgainWithString:self.passWordTextField.text]) {
//            Y_SVP_SHOW_ERR_MES(PASSWORD_ERR_FORMAT_STR)
//            return;
//        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(firstPasswordSetViewSubBtnAction:)]) {
        [_delegate firstPasswordSetViewSubBtnAction:sender];
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
        _topTitleLabel.text = @"设置登录密码";
    }
    return _topTitleLabel;
}
- (UILabel *)topDetailTitleLabel{
    if (!_topDetailTitleLabel) {
        _topDetailTitleLabel = [[UILabel alloc]init];
        _topDetailTitleLabel.textColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty;
        _topDetailTitleLabel.font = [UIFont systemFontOfSize:13];
        _topDetailTitleLabel.text = @"设定后可通过密码方式登录";
        
    }
    return _topDetailTitleLabel;
}
- (UIView *)centerPhoneTextBackGroundView{
    if (!_centerPhoneTextBackGroundView) {
        _centerPhoneTextBackGroundView = [[UIView alloc]init];
    }
    return  _centerPhoneTextBackGroundView;
}
- (UIImageView *)phoneBefreImg{
    if (!_phoneBefreImg) {
        _phoneBefreImg = [[UIImageView alloc]init];
        _phoneBefreImg.image = [ThemeImg loginModuleThemeImageWithBaseName:@"suo"];
        _phoneBefreImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _phoneBefreImg;
}

- (UITextField*)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.delegate = self;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.textColor = [ThemeManager shareManager].loginModuleTextColor;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入登录密码" attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
        _phoneTextField.attributedPlaceholder = placeholderString;
        [_phoneTextField loginModuleTextFieldCleanBtnImgChange];
        _phoneTextField.secureTextEntry = YES;

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
        _passWordTextField.delegate = self;
        _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordTextField.textColor = [ThemeManager shareManager].loginModuleTextColor;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请再次输入密码" attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
        _passWordTextField.attributedPlaceholder = placeholderString;
        [_passWordTextField loginModuleTextFieldCleanBtnImgChange];
        _passWordTextField.secureTextEntry = YES;//1022 放开密文

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
- (UILabel *)centerBottomLabel{
    if (!_centerBottomLabel) {
        _centerBottomLabel = [[UILabel alloc]init];
//        _centerBottomLabel.text = @"8-30位字符，数字和符号至少包含两种";
//        _centerBottomLabel.text = @"6-12位字符，需要包含“大小写字母、数字、标点符号”至少两种";
        _centerBottomLabel.text = @"6-12个字符，至少包含大写字母或小写字母或数字两种";
        _centerBottomLabel.font = [UIFont systemFontOfSize:13];
        _centerBottomLabel.textColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty;
        _centerBottomLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _centerBottomLabel;
}
- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = [UIColor blueColor];
        _loginBtn.titleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _loginBtn.layer.cornerRadius = 25;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setTitle:@"完成" forState:UIControlStateNormal];
        _loginBtn.tag = REGIST_SET_PASSWORD_FINISH_BTN_TAG;
        [_loginBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.backgroundColor = LoginViewBtnGradientColor(Screen_W*0.8, 50);
    }
    return _loginBtn;
}
- (UIButton *)prvacyBtn{
    if (!_prvacyBtn) {
        _prvacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_prvacyBtn setTitle:@"登录/注册即为已经阅读并同意《隐私政策》" forState:UIControlStateNormal];
        [_prvacyBtn setTitleColor:[ThemeManager shareManager].loginModuleTextColor forState:UIControlStateNormal];
        _prvacyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _prvacyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _prvacyBtn.titleLabel.numberOfLines = 2;
        _prvacyBtn.tag = RESET_PASSWORD_PRARVACY_BTN_TAG;
        [_prvacyBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _prvacyBtn;
}

#pragma mark === str
- (NSString*)passwordOneStr{
    if (!_passwordOneStr) {
        _passwordOneStr = @"";
    }
    return _passwordOneStr;
}
- (NSString *)passwordTwoStr{
    if (!_passwordTwoStr) {
        _passwordTwoStr = @"";
    }
    return _passwordTwoStr;
}
@end
