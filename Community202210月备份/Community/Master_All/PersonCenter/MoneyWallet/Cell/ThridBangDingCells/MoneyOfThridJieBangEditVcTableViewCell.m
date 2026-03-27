//
//  MoneyOfThridJieBangEditVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/10/13.
//

#import "MoneyOfThridJieBangEditVcTableViewCell.h"

@implementation MoneyOfThridJieBangEditVcTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setPlaceholderString:(NSString *)str{
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]}];
    _textFiled.attributedPlaceholder = placeholderString;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =  [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.textFiled];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleL.superview);
        make.left.equalTo(_titleL.superview).offset(26);
        make.width.offset(60);
    }];
    [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_textFiled.superview);
        make.left.equalTo(_titleL.mas_right);
        make.right.equalTo(_textFiled.superview).offset(-20);
    }];
}

#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    return _titleL;
}
- (UITextField*)textFiled{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc]init];
        _textFiled.font = [UIFont systemFontOfSize:14];
        //_textFiled.keyboardType = UIKeyboardTypePhonePad;
        _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFiled.textColor = [ThemeManager shareManager].mainTextColor;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]}];
        _textFiled.attributedPlaceholder = placeholderString;
    }
    return _textFiled;
}
 
@end



@implementation MoneyOfThridJieBangEditVcTableViewCellHaveCodeRqBtn

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor =  [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]}]; 
        self.textFiled.attributedPlaceholder = placeholderString;
        [self.contentView addSubview:self.codeRqBtn];
        [self setHaveCodeUI];
    }
    return self;
}
- (void)setHaveCodeUI{
    WEAKSELF
    [_codeRqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(80);
        make.centerY.equalTo(_codeRqBtn.superview);
        make.right.equalTo(_codeRqBtn.superview).offset(-20);
    }];
    [weakSelf.textFiled mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.textFiled.superview);
        make.left.equalTo(weakSelf.titleL.mas_right);
        make.right.equalTo(_codeRqBtn.mas_left).offset(-5);
    }];
}
#pragma mark ==
- (UIButton *)codeRqBtn{
    if (!_codeRqBtn) {
        _codeRqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeRqBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeRqBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _codeRqBtn.tag = REGIST_VerificationCode_BTN_TAG;
        [_codeRqBtn addTarget:self action:@selector(selfSubBtnTouchAction) forControlEvents:UIControlEventTouchUpInside];
        _codeRqBtn.backgroundColor = LoginViewBtnGradientColor(80, 30);
        _codeRqBtn.layer.cornerRadius = 15;
        _codeRqBtn.layer.masksToBounds = YES;
        _codeRqBtn.clipsToBounds = YES;
        _codeRqBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _codeRqBtn;
}
- (void)selfSubBtnTouchAction{
    self.touchCodeActionBlock();//vc要有调用copy才不会崩溃
    [self countdown];
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
                self.codeRqBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                [self.codeRqBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                self.codeRqBtn.backgroundColor = LoginViewBtnGradientColor(80, 30);
                self.codeRqBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                 self.codeRqBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                [self.codeRqBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                self.codeRqBtn.backgroundColor = [UIColor grayColor];
                self.codeRqBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
