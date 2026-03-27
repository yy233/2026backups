//
//  RegistViewLastSubTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/11/30.
//

#import "RegistViewLastSubNomalTableViewCell.h"
#define  NoticeName_Regist_SecnCodeTimeChangeYes                             @"Regist_SecnCodeTimeChangeYes"

@implementation RegistViewLastSubNomalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty;
    }
    return _bottomLineView;
}
- (UIButton *)leftShowBtn{
    if (!_leftShowBtn) {
        _leftShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [_leftShowBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
    return _leftShowBtn;
}
- (void)setTextPStr:(NSString *)pStr{
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:pStr attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
    self.textF.attributedPlaceholder = placeholderString;
}
- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.font = [UIFont systemFontOfSize:16];
        _textF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textF.textColor = [ThemeManager shareManager].loginModuleTextColor;
        [_textF loginModuleTextFieldCleanBtnImgChange];
        //
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
        _textF.attributedPlaceholder = placeholderString;
    }
    return _textF;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.leftShowBtn];
        [self.contentView addSubview:self.textF];
        [self.contentView addSubview:self.bottomLineView];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftShowBtn.superview).offset(26);
        make.right.equalTo(_leftShowBtn.superview).offset(-26);
        make.height.offset(0.5);
        make.bottom.equalTo(_bottomLineView.superview);
    }];
    [_leftShowBtn mas_makeConstraints:^(MASConstraintMaker *make) { 
        make.centerY.equalTo(_leftShowBtn.superview);
        make.width.offset(25);
        make.height.offset(20);
        make.left.equalTo(_bottomLineView);
    }];
    [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textF.superview);
        make.left.equalTo(_bottomLineView).offset(50);
        make.right.equalTo(_bottomLineView).offset(-10);
    }];
     //
    [self setTextPStr:@"请输入密码"];
    [self.leftShowBtn newAnBtnWithImg:[UIImage imageNamed:@"suo"]];
    self.textF.secureTextEntry = YES;
}
@end



@implementation RegistViewLastSubHaveSendCodeBtnTableViewCell
- (UIButton *)rightSendCodeBtn{
    
    if (!_rightSendCodeBtn) {
        _rightSendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightSendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_rightSendCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightSendCodeBtn.tag = REGIST_VerificationCode_BTN_TAG;
        _rightSendCodeBtn.backgroundColor = LoginViewBtnGradientColor(80, 24);
        _rightSendCodeBtn.layer.cornerRadius = 12;
        _rightSendCodeBtn.layer.masksToBounds = YES;
        _rightSendCodeBtn.clipsToBounds = YES;
        _rightSendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _rightSendCodeBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.rightSendCodeBtn];
        [self setUI];
        [self addNoticeWithSendCodeBtnTouchWithTimeChangeYes];
    }
    return self;
}
- (void)setUI{
    WEAKSELF
    [_rightSendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.height.offset(24);
        make.centerY.equalTo(_rightSendCodeBtn.superview);
        make.right.equalTo(weakSelf.bottomLineView);
    }];
    [weakSelf.textF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bottomLineView).offset(-90);
    }];
    //
    [weakSelf setTextPStr:@"请输入验证码"];
    [self.leftShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yanzhengma"]];
    self.textF.keyboardType = UIKeyboardTypePhonePad;
    self.textF.secureTextEntry = NO;

}
- (void)addNoticeWithSendCodeBtnTouchWithTimeChangeYes{
    NSLog(@"NoticeName_Regist_SecnCodeTimeChangeYes add");
    Y_NSNotificationCenter_Creat_NameAction(NoticeName_Regist_SecnCodeTimeChangeYes, countdown);
}
- (void)dealloc{
    NSLog(@"NoticeName_Regist_SecnCodeTimeChangeYes dealloc");
    Y_NSNotificationCenter_RemoveNotice_Name(NoticeName_Regist_SecnCodeTimeChangeYes);

}
 
#pragma mark ——————
//MARK: 倒计时
- (void)countdown {
    NSLog(@"\n countdown \n 倒计时 \n");
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.rightSendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                [self.rightSendCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                self.rightSendCodeBtn.backgroundColor = LoginViewBtnGradientColor(80, 24);
                self.rightSendCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                 self.rightSendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                [self.rightSendCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                self.rightSendCodeBtn.backgroundColor = [UIColor grayColor];
                self.rightSendCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end



@implementation RegistViewLastSubLeftIsPhoneTextBeginTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    //
    [self setTextPStr:@"请输入手机号码"];
    [self.leftShowBtn newAnBtnWithImg:[UIImage imageNamed:@"rightSkip_white"]];
    [self.leftShowBtn newAnBtnWithTextStr:@"+86"];
    [self.leftShowBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(45);
    }];
    self.textF.keyboardType = UIKeyboardTypePhonePad;
    self.textF.secureTextEntry = NO;
 
}
@end


#pragma mark ===
@interface RegistViewLastSubPasswordTextLeftIsSuoBtnAndRightIsEyeBtnTableViewCell ()
@property (nonatomic,strong) UIButton *eyeBtn;
@end


@implementation RegistViewLastSubPasswordTextLeftIsSuoBtnAndRightIsEyeBtnTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.eyeBtn];
        [self setRightUI];
    }
    return self;
}
- (void)setRightUI{
    WEAKSELF
    [_eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(24);
        make.height.offset(24);
        make.centerY.equalTo(_eyeBtn.superview);
        make.right.equalTo(weakSelf.bottomLineView);
    }];
    [weakSelf.textF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bottomLineView).offset(-30);
    }];
}
- (UIButton *)eyeBtn{
    if (!_eyeBtn) {
        _eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eyeBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"hide"] selectedImg:[UIImage imageNamed:@"show"]];
        [_eyeBtn addTarget:self action:@selector(loginViewShowOrHidenPassWordTextFieldText:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _eyeBtn;
}


#pragma mark ==
- (void)loginViewShowOrHidenPassWordTextFieldText:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.textF.secureTextEntry = NO;
    }else{
        self.textF.secureTextEntry = YES;
    }
}
@end


