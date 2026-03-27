//
//  ResetPasswordView.m
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import "ResetPasswordView.h"

@interface ResetPasswordView () <UITextFieldDelegate>

@property (nonatomic,strong) UIView *topBackGroundView;
@property (nonatomic,strong) UIButton *returnBtn;
@property (nonatomic,strong) UILabel  *topTitleLabel;
@property (nonatomic,strong) UILabel  *topDetailTitleLabel;

@property (nonatomic,strong) UIView *centerPhoneTextBackGroundView;
@property (nonatomic,strong) UILabel *phoneBeforeLabel;
@property (nonatomic,strong) UIButton *phoneBeforeBtn;//换
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UIView *centerPhoneTextLineView;

@property (nonatomic,strong) UIView *centerPasswordTextBackGroundView;
@property (nonatomic,strong) UITextField *passWordTextField;
@property (nonatomic,strong) UIImageView *passWordBeforeImg;
@property (nonatomic,strong) UIButton *passWordAfterBtn;
@property (nonatomic,strong) UIView *centerPasswordTextLineView;

@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *prvacyBtn;

@end
@implementation ResetPasswordView
 
 
 
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topBackGroundView];
        [self.topBackGroundView addSubview:self.returnBtn];
        [self.topBackGroundView addSubview:self.topTitleLabel];
        [self.topBackGroundView addSubview:self.topDetailTitleLabel];
    
        [self addSubview:self.centerPhoneTextBackGroundView];
        [self.centerPhoneTextBackGroundView addSubview:self.phoneBeforeBtn];
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
#pragma mark ===== action
 
- (void)selfSubBtnTouchAction:(UIButton *)sender{
    if (sender.tag == RESET_PASSWORD_NEXT_BTN_TAG) {
        NSString *phoneStr = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *passwordStr = [_passWordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (phoneStr.length == 0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_phone_number)
            return;
        }
        if (passwordStr.length == 0) {
           //Please_enter_password_number
            Y_SVP_SHOW_ERR_MES(Please_enter_code_number)
            return;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(restPasswordViewSubBtnAction:)]) {
            [_delegate restPasswordViewSubBtnAction:sender];
        }
    }else if(sender.tag == RESET_PASSWORD_CODE_BTN_TAG){
        NSString *phoneStr = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (phoneStr.length == 0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_phone_number)
            return;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(restPasswordViewSubBtnAction:)]) {
            [_delegate restPasswordViewSubBtnAction:sender];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(restPasswordViewSubBtnAction:)]) {
            [_delegate restPasswordViewSubBtnAction:sender];
        }
    }
    
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
                self.passWordAfterBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                [self.passWordAfterBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                self.passWordAfterBtn.backgroundColor = LoginViewBtnGradientColor(80, 24);
                self.passWordAfterBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                 self.passWordAfterBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                [self.passWordAfterBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                self.passWordAfterBtn.backgroundColor = [UIColor grayColor];
                self.passWordAfterBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark ====
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTextField) {
        self.passWordTextField.text = @"";
        return [ValidateUtil isMatchPhoneNumberFormat:textField range:range string:string];
    }
    if (textField == self.passWordTextField) {
        return  [ValidateUtil isMatchCodeFormat:textField range:range string:string];
    }
    return YES;
}
 
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField == self.phoneTextField) {
        _phoneStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (textField == self.passWordTextField) {
        _codeStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}
#pragma mark ===== 
- (void)topUI{
    //top
    [_topBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackGroundView.superview.mas_top).offset(status_height);
        make.width.equalTo(_topBackGroundView.superview.mas_width).offset(-50);
        make.centerX.equalTo(_topBackGroundView.superview.mas_centerX);
        make.height.offset(200);
    }];
    [_returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackGroundView.mas_top).offset(40);
        make.left.equalTo(_topBackGroundView.mas_left);
        make.width.offset(40);
        make.height.offset(24);
    }];
    [_topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_returnBtn.mas_bottom).offset(30);
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
        make.height.offset(20);
        make.centerX.equalTo(_phoneBeforeBtn.mas_centerX);
    }];
    [_passWordAfterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerPasswordTextBackGroundView.mas_centerY);
        make.right.equalTo(_centerPasswordTextBackGroundView.mas_right);
        make.height.offset(24);
        make.width.offset(80);
    }];
    [_passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerPasswordTextBackGroundView.mas_centerY);
        make.left.equalTo(_phoneTextField.mas_left);
        make.right.equalTo(_passWordAfterBtn.mas_left).offset(1);
        make.height.offset(40);
    }];
    [_centerPasswordTextLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerPasswordTextBackGroundView.mas_bottom);
        make.width.equalTo(_centerPasswordTextBackGroundView.mas_width);
        make.height.offset(1);
        make.centerX.equalTo(_centerPasswordTextLineView);
    }];
    
    //login
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerPasswordTextBackGroundView.mas_bottom).offset(20);
        make.centerX.equalTo(_centerPasswordTextBackGroundView.mas_centerX);
        make.height.offset(50);
        make.width.equalTo(_loginBtn.superview.mas_width).multipliedBy(0.8);
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
 
#pragma mark ===== getter
- (UIView *)topBackGroundView{
    if (!_topBackGroundView) {
        _topBackGroundView = [[UIView alloc]init];
    }
    return _topBackGroundView;
}

- (UIButton *)returnBtn{
    if (!_returnBtn) {
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"login_close_slices"] forState:UIControlStateNormal];
        _returnBtn.tag = REMOVE_SELF_BTN_TAG;
        [_returnBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}
- (UILabel *)topTitleLabel{
    if (!_topTitleLabel) {
        _topTitleLabel = [[UILabel alloc]init];
        _topTitleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _topTitleLabel.font = [UIFont boldSystemFontOfSize:32];
        _topTitleLabel.text = @"重置密码";
    }
    return _topTitleLabel;
}
- (UILabel *)topDetailTitleLabel{
    if (!_topDetailTitleLabel) {
        _topDetailTitleLabel = [[UILabel alloc]init];
        _topDetailTitleLabel.textColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty;
        _topDetailTitleLabel.font = [UIFont systemFontOfSize:13];
        _topDetailTitleLabel.text = @"已注册手机可以重置密码";
 
    }
    return _topDetailTitleLabel;
}
- (UIView *)centerPhoneTextBackGroundView{
    if (!_centerPhoneTextBackGroundView) {
        _centerPhoneTextBackGroundView = [[UIView alloc]init];
    }
    return  _centerPhoneTextBackGroundView;
}
- (UILabel *)phoneBeforeLabel{
    if (!_phoneBeforeLabel) {
        _phoneBeforeLabel = [[UILabel alloc]init];
        _phoneBeforeLabel.text = @"+86";
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
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTextField.font = [UIFont systemFontOfSize:16];
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.delegate = self;
        _phoneTextField.textColor = [ThemeManager shareManager].loginModuleTextColor;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入已注册的手机号码" attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
        _phoneTextField.attributedPlaceholder = placeholderString;
        [_phoneTextField loginModuleTextFieldCleanBtnImgChange];

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
        _passWordTextField.keyboardType = UIKeyboardTypePhonePad;
        _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordTextField.delegate = self;
        _passWordTextField.font = [UIFont systemFontOfSize:16];
        _passWordTextField.textColor = [ThemeManager shareManager].loginModuleTextColor;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
        _passWordTextField.attributedPlaceholder = placeholderString;
        [_passWordTextField loginModuleTextFieldCleanBtnImgChange];
     }
    return _passWordTextField;
}
- (UIImageView *)passWordBeforeImg{
    if (!_passWordBeforeImg) {
        _passWordBeforeImg = [[UIImageView alloc]init];
        _passWordBeforeImg.image = [ThemeImg loginModuleThemeImageWithBaseName:@"yanzhengma"];//验证码
        _passWordBeforeImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _passWordBeforeImg;
}
- (UIButton *)passWordAfterBtn{
    if (!_passWordAfterBtn) {
        _passWordAfterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passWordAfterBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_passWordAfterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _passWordAfterBtn.tag = RESET_PASSWORD_CODE_BTN_TAG;
        [_passWordAfterBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        _passWordAfterBtn.backgroundColor = LoginViewBtnGradientColor(80, 24);
        _passWordAfterBtn.layer.cornerRadius = 12;
        _passWordAfterBtn.layer.masksToBounds = YES;
        _passWordAfterBtn.clipsToBounds = YES;
        _passWordAfterBtn.titleLabel.font = [UIFont systemFontOfSize:11];
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
        _loginBtn.backgroundColor = [UIColor blueColor];
        _loginBtn.titleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _loginBtn.layer.cornerRadius = 25;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _loginBtn.tag = RESET_PASSWORD_NEXT_BTN_TAG;
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
        _prvacyBtn.titleLabel.numberOfLines = 2;
        _prvacyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _prvacyBtn.tag = RESET_PASSWORD_PRARVACY_BTN_TAG;
        [_prvacyBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _prvacyBtn;
}
#pragma mark === str
- (NSString*)phoneStr{
    if (!_phoneStr) {
        _phoneStr = @"";
    }
    return _phoneStr;
}
- (NSString *)codeStr{
    if (!_codeStr) {
        _codeStr = @"";
    }
    return _codeStr;
}

@end
