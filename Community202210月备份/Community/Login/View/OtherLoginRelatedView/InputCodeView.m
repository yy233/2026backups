//
//  InputCodeView.m
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import "InputCodeView.h" 

@interface InputCodeView() <UITextFieldDelegate>
 
@property (nonatomic,strong) UIView *topBackGroundView;
@property (nonatomic,strong) UILabel  *topTitleLabel;
@property (nonatomic,strong) UIView *centerPhoneTextBackGroundView;

@end

@implementation InputCodeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topBackGroundView];
        [self.topBackGroundView addSubview:self.removeSelfBtn];
        [self.topBackGroundView addSubview:self.topTitleLabel];
        [self.topBackGroundView addSubview:self.topDetailTitleLabel];
        
        [self addSubview:self.centerPhoneTextBackGroundView];
        [self.centerPhoneTextBackGroundView addSubview:self.codeView];
        
        [self addSubview:self.okBtn];
        [self addSubview:self.onceCgainGetCodeBtn];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self topUI];
    [self centerUI];
}

#pragma mark ====
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.codeView.textField) {
        return [ValidateUtil isMatchCodeFormat:textField range:range string:string];
    }
    return YES;
}
 
- (void)topUI{
    //top
    [_topBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackGroundView.superview.mas_top).offset(kStatusBarHeight);
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
        make.height.offset(60);
    }];
    [_codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerPhoneTextBackGroundView.mas_top);
        make.centerX.equalTo(_centerPhoneTextBackGroundView.mas_centerX);
        make.centerY.equalTo(_centerPhoneTextBackGroundView.mas_centerY);
        make.width.equalTo(_centerPhoneTextBackGroundView.mas_width).multipliedBy(0.6);
        make.height.offset(60);
    }];
    //login
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerPhoneTextBackGroundView.mas_bottom).offset(20);
        make.centerX.equalTo(_centerPhoneTextBackGroundView.mas_centerX);
        make.height.offset(50);
        make.width.equalTo(_okBtn.superview.mas_width).multipliedBy(0.8);
    }];
    
    [_onceCgainGetCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_okBtn);
    }];
    _okBtn.hidden = YES;
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
    }
    return _removeSelfBtn;
}
- (UILabel *)topTitleLabel{
    if (!_topTitleLabel) {
        _topTitleLabel = [[UILabel alloc]init];
        _topTitleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _topTitleLabel.font = [UIFont systemFontOfSize:20];
        _topTitleLabel.text = @"请输入验证码";
    }
    return _topTitleLabel;
}
- (UILabel *)topDetailTitleLabel{
    if (!_topDetailTitleLabel) {
        _topDetailTitleLabel = [[UILabel alloc]init];
        _topDetailTitleLabel.textColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty;
        _topDetailTitleLabel.font = [UIFont systemFontOfSize:13];
        _topDetailTitleLabel.text = @"验证码已发送到";
 
    }
    return _topDetailTitleLabel;
}
- (UIView *)centerPhoneTextBackGroundView{
    if (!_centerPhoneTextBackGroundView) {
        _centerPhoneTextBackGroundView = [[UIView alloc]init];
    }
    return  _centerPhoneTextBackGroundView;
}

- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn.backgroundColor = [UIColor blueColor];
        _okBtn.titleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _okBtn.layer.cornerRadius = 25;
        _okBtn.layer.masksToBounds = YES;
        [_okBtn setTitle:@"确认" forState:UIControlStateNormal];
//        [_okBtn setTitle:@"重新获取验证码" forState:UIControlStateSelected];//
        _okBtn.backgroundColor = LoginViewBtnGradientColor(Screen_W*0.8, 50);
    }
    return _okBtn;
}
- (UIButton *)onceCgainGetCodeBtn{
    if (!_onceCgainGetCodeBtn) {
        _onceCgainGetCodeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _onceCgainGetCodeBtn.backgroundColor = [UIColor blueColor];
        _onceCgainGetCodeBtn.titleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _onceCgainGetCodeBtn.layer.cornerRadius = 25;
        _onceCgainGetCodeBtn.layer.masksToBounds = YES;
        [_onceCgainGetCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        _onceCgainGetCodeBtn.backgroundColor = LoginViewBtnGradientColor(Screen_W*0.8, 50);
    }
    return _onceCgainGetCodeBtn;
}

- (SMSCodeInputView *)codeView{
    if (!_codeView) {
        _codeView = [[SMSCodeInputView alloc]init];
    }
    return _codeView;
}


@end
