//
//  PhoneChangeSecondStepVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/27.
//

#import "PhoneChangeSecondStepVC.h"

#import "PhoneChangeThirdStepVC.h"
//
#import "SafetyCenterViewModel.h"

@interface PhoneChangeSecondStepVC ()

@property(nonatomic, strong) UILabel *textL;

@property(nonatomic, strong) UILabel *subL;

@property(nonatomic, strong) UITextField *textF;

@property(nonatomic, strong) UIView *lineV;

@property(nonatomic, strong) UIButton *btn;

@end

@implementation PhoneChangeSecondStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换手机号";
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}

- (void)initView{
    [self.textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(37);
        make.top.offset(50);
    }];
    
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textL.mas_left);
        make.top.mas_equalTo(self.textL.mas_bottom).offset(35);
        make.width.offset(40);
    }];
    
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.subL);
        make.left.mas_equalTo(self.subL.mas_right).offset(0);
        make.right.offset(-37);
        make.height.offset(30);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(37);
        make.right.offset(-37);
        make.height.offset(0.5);
        make.top.mas_equalTo(self.textF.mas_bottom).offset(10);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.offset(45);
        make.left.offset(37);
        make.top.mas_equalTo(self.lineV.mas_bottom).offset(30);
    }];
    
    self.textF.textColor = [ThemeManager shareManager].mainTextColor;
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3]}];
    self.textF.attributedPlaceholder =  placeholderString;
    
    self.textL.textColor = [ThemeManager shareManager].mainTextColor;
    self.subL.textColor = [ThemeManager shareManager].mainTextColor;
    self.lineV.backgroundColor = [ThemeManager shareManager].themeLineColor;
}

#pragma mark - 懒加载

- (UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc] init];
        _textL.text = @"请输入您需要绑定的新手机号";
        _textL.font = FontSize_Vip_Nomail(17);
        _textL.numberOfLines = 0;
        _textL.textColor = [Tool getColorWithHexString:@"#333333"];
        _textL.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_textL];
    }
    return _textL;
}

- (UILabel *)subL{
    if (!_subL) {
        _subL = [[UILabel alloc] init];
        _subL.text = @"+86";
        _subL.font = FontSize_Vip_Nomail(14);
        _subL.numberOfLines = 0;
        _subL.textColor = [Tool getColorWithHexString:@"#333333"];
        _subL.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_subL];
    }
    return _subL;
}

- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc] init];
        _textF.placeholder = @"请输入手机号";
        _textF.keyboardType = UIKeyboardTypeNumberPad;
        _textF.font = FontSize_Vip_Nomail(15);
        [_textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_textF];
    }
    return _textF;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.view addSubview:_lineV];
    }
    return _lineV;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _btn.titleLabel.font = FontSize_Vip_Nomail(15);
        [_btn setTitleColor:[Tool getColorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_btn setBackgroundColor:[Tool getColorWithHexString:@"#2672F9"]];
        [_btn setImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btn.layer.cornerRadius = 3.5;
        _btn.clipsToBounds = YES;
        _btn.tag = 0;
        [self.view addSubview:_btn];
    }
    return _btn;
}

#pragma mark - 按钮点击

- (void)btnClicked: (UIButton *)sender{
    [self.view endEditing:YES];
    if (self.textF.text.length > 0) {
        if (![ZYTextValidationTool validatePhone:self.textF.text]) {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"手机格式不正确，请重新填写!" toView:self.view];
            return;
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入手机号!" toView:self.view];
        return;
    }
    WEAKSELF
    [SafetyCenterViewModel changePhoneToSendCodeWithTheNewPhoneNumStr:self.textF.text withDicBlock:^(NSDictionary *dic, BOOL success) {
        STRONGSELF
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                PhoneChangeThirdStepVC *vc = [[PhoneChangeThirdStepVC alloc] init];
                vc.nPhoneStr = strongSelf.textF.text;
                [strongSelf pushVc:vc];
            });
        }
    }];
}

#pragma mark - 输入框监听

- (void)textFieldDidChange: (UITextField *)textF{
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
