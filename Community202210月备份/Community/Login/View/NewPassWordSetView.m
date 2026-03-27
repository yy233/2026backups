//
//  NewPassWordSetView.m
//  Community
//
//  Created by 余莹 on 2020/11/14.
//

#import "NewPassWordSetView.h"

@interface NewPassWordSetView () <UITextFieldDelegate>

@property (nonatomic,strong) UIView *topBackGroundView;
@property (nonatomic,strong) UIButton *removeSelfBtn;
@property (nonatomic,strong) UILabel  *topTitleLabel;
@property (nonatomic,strong) UILabel  *topDetailTitleLabel;

@property (nonatomic,strong) UIView *centerPhoneTextBackGroundView;
@property (nonatomic,strong) UIImageView *phoneBefreImg;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UIView *centerPhoneTextLineView;

@property (nonatomic,strong) UIButton *centerBottomTipBtn;

@property (nonatomic,strong) UIButton *oKBtn;
@property (nonatomic,strong) UIButton *cancelResetBtn;
@property (nonatomic,strong) UIButton *prvacyBtn;

@end

@implementation NewPassWordSetView

-(instancetype)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];
   if (self) {
       [self addSubview:self.topBackGroundView];
       [self.topBackGroundView addSubview:self.removeSelfBtn];
       [self.topBackGroundView addSubview:self.topTitleLabel];
       [self.topBackGroundView addSubview:self.topDetailTitleLabel];
   
       [self addSubview:self.centerPhoneTextBackGroundView];
       [self.centerPhoneTextBackGroundView addSubview:self.phoneBefreImg];
       [self.centerPhoneTextBackGroundView addSubview:self.phoneTextField];
       [self.centerPhoneTextBackGroundView addSubview:self.centerPhoneTextLineView];
       
       [self addSubview:self.centerBottomTipBtn];
       [self addSubview:self.oKBtn];
       [self addSubview:self.cancelResetBtn];
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
    if (textField == self.phoneTextField) {
       // return [ValidateUtil isMatchPasswordFormat:textField range:range string:string];
    }
    return YES;
}
-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField == self.phoneTextField) {
        _passwordOneStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}
#pragma mark == UI
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
        make.width.offset(45);
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
    [_centerBottomTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerPhoneTextLineView.mas_bottom).offset(15);
        make.height.offset(15);
        make.left.equalTo(_centerPhoneTextLineView.mas_left);
        make.width.equalTo(_centerPhoneTextLineView.mas_width);
    }];
    
    //
    [_oKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerBottomTipBtn.mas_bottom).offset(20);
        make.centerX.equalTo(_centerPhoneTextLineView.mas_centerX);
        make.height.offset(50);
        make.width.equalTo(_oKBtn.superview.mas_width).multipliedBy(0.8);
    }];
    [_cancelResetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oKBtn.mas_bottom).offset(10);
        make.centerX.equalTo(_oKBtn.mas_centerX);
        make.width.equalTo(_oKBtn.mas_width).multipliedBy(0.3);
        make.height.equalTo(_oKBtn.mas_height).multipliedBy(0.5);
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
    
    if (sender.tag == RESET_PASSWORD_FINISH_BTN_TAG) {
//        if (![ValidateUtil isMachPasswordJudgeBeforeSendingAgainWithString:self.phoneTextField.text]) {
//            Y_SVP_SHOW_ERR_MES(PASSWORD_ERR_FORMAT_STR)
//            return;
//        }
        if (_delegate && [_delegate respondsToSelector:@selector(newPasswordSetViewSubBtnAction:)]) {
            [_delegate newPasswordSetViewSubBtnAction:sender];
        }
 
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(newPasswordSetViewSubBtnAction:)]) {
            [_delegate newPasswordSetViewSubBtnAction:sender];
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
        _topTitleLabel.text = @"设置登录密码";
    }
    return _topTitleLabel;
}
- (UILabel *)topDetailTitleLabel{
    if (!_topDetailTitleLabel) {
        _topDetailTitleLabel = [[UILabel alloc]init];
        _topDetailTitleLabel.textColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty;
        _topDetailTitleLabel.font = [UIFont systemFontOfSize:13];
//        _topDetailTitleLabel.text = @"设定后可通过密码方式登录";
        _topDetailTitleLabel.text = @"通过重置设置新密码";
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
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];//@"请输入登录密码"
        _phoneTextField.attributedPlaceholder = placeholderString;
        [_phoneTextField loginModuleTextFieldCleanBtnImgChange];
        _phoneTextField.secureTextEntry = YES;//1022 密文

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

- (UIButton *)centerBottomTipBtn{
    if (!_centerBottomTipBtn) {
        _centerBottomTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_centerBottomTipBtn setTitle:@"8-30位字符，数字和符号至少包含两种" forState:UIControlStateNormal];
        [_centerBottomTipBtn setTitle:@"6-12位字符，需要包含“大小写字母、数字、标点符号”至少两种" forState:UIControlStateNormal];
        [_centerBottomTipBtn setTitleColor:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty forState:UIControlStateNormal];
        _centerBottomTipBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _centerBottomTipBtn.titleLabel.numberOfLines = 1;
        _centerBottomTipBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//        _centerBottomTipBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);//tip
    }
    return _centerBottomTipBtn;
}

- (UIButton *)oKBtn{
    if (!_oKBtn) {
        _oKBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _oKBtn.backgroundColor = [UIColor blueColor];
        _oKBtn.titleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _oKBtn.layer.cornerRadius = 25;
        _oKBtn.layer.masksToBounds = YES;
        [_oKBtn setTitle:@"完成" forState:UIControlStateNormal];
        _oKBtn.tag = RESET_PASSWORD_FINISH_BTN_TAG;
        [_oKBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        _oKBtn.backgroundColor = LoginViewBtnGradientColor(Screen_W*0.8, 50);
    }
    return _oKBtn;
}
- (UIButton *)cancelResetBtn{
    if (!_cancelResetBtn) {
        _cancelResetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelResetBtn setTitle:@"取消重置" forState:UIControlStateNormal];
        [_cancelResetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _cancelResetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelResetBtn.titleLabel.numberOfLines = 1;
        _cancelResetBtn.tag = RESET_PASSWORD_CANCEL_BTN_TAG;
        [_cancelResetBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelResetBtn;
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
 
@end
