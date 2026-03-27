//
//  BindingPhoneView.m
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import "BindingPhoneView.h"
@interface BindingPhoneView() <UITextFieldDelegate>
@property (nonatomic,strong) UIView *topBackGroundView;
@property (nonatomic,strong) UILabel  *topTitleLabel;
@property (nonatomic,strong) UILabel  *topDetailTitleLabel;

@property (nonatomic,strong) UIView *centerPhoneTextBackGroundView;
@property (nonatomic,strong) UILabel *phoneBeforeLabel;
@property (nonatomic,strong) UIButton *phoneBeforeBtn;//换
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UIView *centerPhoneTextLineView;

@end

@implementation BindingPhoneView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topBackGroundView];
        [self.topBackGroundView addSubview:self.removeSelfBtn];
        [self.topBackGroundView addSubview:self.topTitleLabel];
        [self.topBackGroundView addSubview:self.topDetailTitleLabel];
        
        [self addSubview:self.centerPhoneTextBackGroundView];
        [self.centerPhoneTextBackGroundView addSubview:self.phoneBeforeBtn];
        [self.centerPhoneTextBackGroundView addSubview:self.phoneTextField];
        [self.centerPhoneTextBackGroundView addSubview:self.centerPhoneTextLineView];
        
        [self addSubview:self.okBtn];
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
    if (textField == self.phoneTextField) {
        return [ValidateUtil isMatchPhoneNumberFormat:textField range:range string:string];
    }
    return YES;
}
-(void)textFieldDidChangeSelection:(UITextField *)textField{
    _phoneStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark ===
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
    
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerPhoneTextBackGroundView.mas_bottom).offset(20);
        make.centerX.equalTo(_centerPhoneTextBackGroundView.mas_centerX);
        make.height.offset(50);
        make.width.equalTo(_okBtn.superview.mas_width).multipliedBy(0.8);
    }];
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
        _topTitleLabel.font = [UIFont boldSystemFontOfSize:32];
        _topTitleLabel.text = @"绑定手机号";
    }
    return _topTitleLabel;
}
- (UILabel *)topDetailTitleLabel{
    if (!_topDetailTitleLabel) {
        _topDetailTitleLabel = [[UILabel alloc]init];
        _topDetailTitleLabel.textColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty;
        _topDetailTitleLabel.font = [UIFont systemFontOfSize:13];
//        _topDetailTitleLabel.text = @"为了您的账号安全，请完成手机号绑定";
        _topDetailTitleLabel.text = @"为了识别您的身份，请完成手机号绑定";

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
        _phoneTextField.delegate = self;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.textColor = [ThemeManager shareManager].loginModuleTextColor;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
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

- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn.backgroundColor = [UIColor blueColor];
        _okBtn.titleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _okBtn.layer.cornerRadius = 25;
        _okBtn.layer.masksToBounds = YES;
        [_okBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _okBtn.backgroundColor = LoginViewBtnGradientColor(Screen_W*0.8, 50);
    }
    return _okBtn;
}
 
- (NSString*)phoneStr{
    if (!_phoneStr) {
        _phoneStr = @"";
    }
    return _phoneStr;
}

@end
