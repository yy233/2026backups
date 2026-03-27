//
//  PayPasswordSetVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "PayPasswordSetVC.h"
#import "PayPasswordSecondStepVC.h"
#import "LoginPasswordSetVC.h"
//
#import "SafetyCenterViewModel.h"
@interface PayPasswordSetVC ()

@property(nonatomic, strong) UILabel *telL;

@property(nonatomic, strong) UIView *codeBgView;

@property(nonatomic, strong) UITextField *textF;

@property(nonatomic, strong) UIButton *codeBtn;

@property(nonatomic, strong) UIButton *nextBtn;

@end

@implementation PayPasswordSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == Set_Password_Type_Login) {
        if ([ShareUserInfo sharedUserInfo].userInfo.isBindPassword) {
            self.title = @"修改登录密码";
        }else {
            self.title = @"设置登录密码";
        }
    }else if (self.type == Set_Password_Type_Pay) {
        if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
            self.title = @"修改支付密码";
        }else {
            self.title = @"设置支付密码";
        };
    }
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}

- (void)initView{
    
    [self.telL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
    }];
    
    [self.codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.telL.mas_bottom).offset(15);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(50);
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.codeBgView).offset(-15);
        make.width.offset(80);
        make.height.offset(27);
        make.centerY.mas_equalTo(self.codeBgView);
    }];
    
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.codeBgView);
        make.left.mas_equalTo(self.codeBgView).offset(15);
        make.right.equalTo(_codeBtn.mas_left).offset(-10);
        make.height.offset(40);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.mas_equalTo(self.codeBgView.mas_bottom).offset(30);
        make.height.offset(45);
        make.right.offset(-15);
    }];
    
    self.telL.textColor = [ThemeManager shareManager].mainTextColor;
    self.textF.textColor = [ThemeManager shareManager].mainTextColor;
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3]}];
    self.textF.attributedPlaceholder =  placeholderString;
    self.codeBgView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    
}

#pragma mark - 懒加载

- (UILabel *)telL{
    if (!_telL) {
        _telL = [[UILabel alloc] init];
        NSString *phoneStr = [NSString stringWithFormat:@"%@",[ShareUserInfo sharedUserInfo].userInfo.mobile];
        if(phoneStr.length>7){
            _telL.text =  [NSString stringWithFormat:@"请验证手机号 %@",[phoneStr replaceStringWithAsteriskStartLocation:3 length:4]];
        }
        _telL.font = FontSize_Vip_Nomail(14);
        _telL.textColor = [Tool getColorWithHexString:@"#999999"];
        _telL.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_telL];
    }
    return _telL;
}

- (UIView *)codeBgView{
    if (!_codeBgView) {
        _codeBgView = [[UIView alloc] init];
        _codeBgView.backgroundColor = [Tool getColorWithHexString:@"#FFFFFF"];
        _codeBgView.layer.cornerRadius = 5;
        _codeBgView.clipsToBounds = YES;
        [self.view addSubview:_codeBgView];
    }
    return _codeBgView;
}

- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc] init];
        _textF.placeholder = @"请输入验证码";
        _textF.font = FontSize_Vip_Nomail(15);
        _textF.keyboardType = UIKeyboardTypeNumberPad;
        [_textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_textF];
    }
    return _textF;
}

- (UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = FontSize_Vip_Nomail(12);
        [_codeBtn setBackgroundColor:[Tool getColorWithHexString:@"#2672F9"]];
        [_codeBtn setImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(btnSendCodeClicked) forControlEvents:UIControlEventTouchUpInside];
        _codeBtn.layer.cornerRadius = 3.5;
        _codeBtn.layer.borderWidth = 0.5;
        _codeBtn.layer.borderColor = [Tool getColorWithHexString:@"#2672F9"].CGColor;
        _codeBtn.layer.cornerRadius = 5;
        _codeBtn.clipsToBounds = YES;
        _codeBtn.tag = 1;
        [self.view addSubview:_codeBtn];
    }
    return _codeBtn;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = FontSize_Vip_Nomail(15);
        [_nextBtn setTitleColor:[Tool getColorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:[Tool getColorWithHexString:@"#EEEEEE"]];
        [_nextBtn setImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.layer.cornerRadius = 3.5;
        _nextBtn.clipsToBounds = YES;
        _nextBtn.tag = 1;
        _nextBtn.userInteractionEnabled = NO;//初始时不可点击
        [self.view addSubview:_nextBtn];
    }
    return _nextBtn;
}

#pragma mark - 按钮点击
//验证码 发送
- (void)btnSendCodeClicked{
    NSString *phoneStr = [ShareUserInfo sharedUserInfo].userInfo.mobile;
    WEAKSELF
    [SafetyCenterViewModel changePayPasswordToSendCodeWithTheNewPhoneNumStr:phoneStr withDicBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            [weakSelf countdown];
        }
    }];
}
//下一页
- (void)btnClicked: (UIButton *)sender{
//    //验证code 检验
//    NSString *phoneStr = [ShareUserInfo sharedUserInfo].userInfo.mobile;
//    [SafetyCenterViewModel safetyCenterCheckCodeWithCodeNum:_textF.text withPhoneNumStr:phoneStr withDicBlock:^(NSDictionary * dic, BOOL success) {
//        if (success) {
//            if (self.type == Set_Password_Type_Login) {
//                LoginPasswordSetVC *vc = [[LoginPasswordSetVC alloc] init];
//                [self pushVc:vc];
//            }else if (self.type == Set_Password_Type_Pay) {
//                PayPasswordSecondStepVC *vc = [[PayPasswordSecondStepVC alloc] init];
//                [self pushVc:vc];
//            }
//        }
//    }];
   
    if (self.type == Set_Password_Type_Login) {
        LoginPasswordSetVC *vc = [[LoginPasswordSetVC alloc] init];
        vc.verifyCode = self.textF.text;
        [self pushVc:vc];
    }else if (self.type == Set_Password_Type_Pay) {
        PayPasswordSecondStepVC *vc = [[PayPasswordSecondStepVC alloc] init];
        vc.verifyCode = self.textF.text;
        [self pushVc:vc];
    }
}

#pragma mark - 输入框监听

- (void)textFieldDidChange:(UITextField *)textF{
    if (textF.text.length >= 4) {
//        textF.text = [textF.text substringToIndex: textF.text.length];
        [self.nextBtn setBackgroundColor:[Tool getColorWithHexString:@"#2672F9"]];
        [self.nextBtn setTitleColor:[Tool getColorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.nextBtn.userInteractionEnabled = YES;
    }else{
        [self.nextBtn setBackgroundColor:[Tool getColorWithHexString:@"#EEEEEE"]];
        [self.nextBtn setTitleColor:[Tool getColorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.nextBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - 验证码倒计时
- (void)countdown {
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.codeBtn setBackgroundColor:[Tool getColorWithHexString:@"#2672F9"]];
                [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.codeBtn.layer.borderColor = [Tool getColorWithHexString:@"#2672F9"].CGColor;
                self.codeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                [self.codeBtn setBackgroundColor:[UIColor grayColor]];
                [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.codeBtn.layer.borderColor = [UIColor grayColor].CGColor;
                self.codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
