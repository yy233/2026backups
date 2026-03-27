//
//  NickNameEditVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "NickNameEditVC.h"

@interface NickNameEditVC ()
@property(nonatomic, strong) UIView *backView;
@property(nonatomic, strong) UILabel *nickL;

@property(nonatomic, strong) UILabel *remakL;

@property(nonatomic, strong) UITextField *textF;

@property(nonatomic, strong) UIButton *btn;

@property(nonatomic, strong) UIView *lineV;

@property(nonatomic, strong) UIView *lineV1;

@end

@implementation NickNameEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    [self initView];
    self.textF.text = self.nickName;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}

- (void)initView{
    [self.view addSubview:self.backView];
    //
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.offset(0.5);
    }];
    
    [self.nickL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.mas_equalTo(self.lineV.mas_bottom).offset(10);
        make.height.offset(50);
        make.width.offset(80);
    }];
    
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickL.mas_right).offset(0);
        make.centerY.mas_equalTo(self.nickL);
        make.height.offset(50);
        make.right.offset(-10);
    }];
    
    [self.lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(0.5);
        make.top.mas_equalTo(self.nickL.mas_bottom);
    }];
    
    [self.remakL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.mas_equalTo(self.lineV1.mas_bottom).offset(10);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerX.mas_equalTo(self.view);
        make.height.offset(44);
        make.top.mas_equalTo(self.remakL.mas_bottom).offset(25);
    }];
    //
    self.nickL.textColor = [ThemeManager shareManager].mainTextColor;
    self.textF.textColor = [ThemeManager shareManager].mainTextColor;
    
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入昵称" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3]}];
    self.textF.attributedPlaceholder =  placeholderString;
    self.remakL.textColor = [ThemeManager shareManager].mainTextColor;
    self.lineV.hidden = YES;
    self.lineV1.backgroundColor = [ThemeManager shareManager].themeLineColor;
    self.view.backgroundColor = [ThemeManager shareManager].themeBackGroundColor;
    //
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView.superview).offset(10);
        make.right.equalTo(_backView.superview).offset(-10);
        make.top.equalTo(_backView.superview).offset(10);
        make.bottom.equalTo(_remakL).offset(10);
    }];
}


#pragma mark - 懒加载
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
- (UILabel *)nickL{
    if (!_nickL) {
        _nickL = [[UILabel alloc] init];
        _nickL.text = @"用户昵称：";
        _nickL.font = FontSize_Vip_Nomail(15);
        _nickL.textColor = [Tool getColorWithHexString:@"#000000"];
        _nickL.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_nickL];
    }
    return _nickL;
}

- (UILabel *)remakL{
    if (!_remakL) {
        _remakL = [[UILabel alloc] init];
        _remakL.text = @"请输入2-16个字符，可使用英文、汉字、数字";
        _remakL.font = FontSize_Vip_Nomail(12);
        _remakL.textColor = [Tool getColorWithHexString:@"#000000"];
        _remakL.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_remakL];
    }
    return _remakL;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.view addSubview:_lineV];
    }
    return _lineV;
}

- (UIView *)lineV1{
    if (!_lineV1) {
        _lineV1 = [[UIView alloc] init];
        _lineV1.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.view addSubview:_lineV1];
    }
    return _lineV1;
}


- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc] init];
        _textF.placeholder = @"请输入昵称";
        _textF.font = FontSize_Vip_Nomail(15);
        _textF.textColor = [Tool getColorWithHexString:@"#333333"];
        _textF.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_textF];
    }
    return _textF;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"确认" forState:UIControlStateNormal];
        _btn.titleLabel.font = FontSize_Vip_Nomail(15);
        [_btn setTitleColor:[Tool getColorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_btn setBackgroundColor:[Tool getColorWithHexString:@"#2672F9"]];
        [_btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        _btn.layer.cornerRadius = 3.5;
        _btn.clipsToBounds = YES;
        _btn.tag = 0;
        [self.view addSubview:_btn];
    }
    return _btn;
}

#pragma mark - 按钮点击

- (void)btnClicked{
    if (self.textF.text.length<2) {
        Y_SVP_SHOW_ERR_MES(@"昵称格式不正确");
        return;
    }
    WEAKSELF
    [PersonInfoViewModel changePersonNickNameWithStr:self.textF.text withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            [ShareUserInfo sharedUserInfo].userInfo.nickname = self.textF.text;
            Y_NSNotificationCenter_PostNotice_NilObject_Name(PersonInfo_Change_Notice);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"昵称修改成功");
                [weakSelf popVC];
            });
        }
    }];
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
