//
//  LoginView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame{
   
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.loginBkView];
        [_loginBkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_loginBkView.superview);
        }];
        
//        @property (nonatomic,strong) UIImageView *headerImgv;
//        @property (nonatomic,strong) UILabel *logoLabel;
        [self addSubview:self.headerImgv];
        [self addSubview:self.logoLabel];
        [self addSubview:self.oneLoginBtn];
        [self addSubview:self.twoLoginBtn];
        [self addSubview:self.agreeBtn];
        [self addSubview:self.agreeL];
        
        [self subViesUI];
    }
    return self;
}
- (void)subViesUI{
    [_oneLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_oneLoginBtn.superview).multipliedBy(0.8);
        make.height.offset(50.0);
        make.centerX.centerY.equalTo(_oneLoginBtn.superview);
    }];
    
    [_twoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(_oneLoginBtn);
        make.top.equalTo(_oneLoginBtn.mas_bottom).offset(20);
    }];
    
    
    [_headerImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerImgv.superview);
        make.height.width.offset(70);
        make.centerY.equalTo(_headerImgv.superview).multipliedBy(0.5);
    }];
    [_logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(_logoLabel.superview);
        make.height.offset(40);
        make.top.equalTo(_headerImgv.mas_bottom).offset(30);
    }];
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_twoLoginBtn.mas_bottom).offset(30);
        make.left.equalTo(_twoLoginBtn.mas_left).offset(15);
        make.width.height.offset(16);
    }];
    [_agreeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_agreeBtn.mas_right).offset(10);
        make.centerY.equalTo(_agreeBtn);
        make.right.equalTo(_twoLoginBtn.mas_right);
//        make.height.offset();
    }];
    
}
- (UIImageView *)loginBkView{
    if(!_loginBkView){
        _loginBkView = [[UIImageView alloc]init];
        _loginBkView.image = [UIImage imageNamed:@"loginBk"];
        _loginBkView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _loginBkView;
}

- (UIImageView *)headerImgv{
    if(!_headerImgv){
        _headerImgv = [[UIImageView alloc]init];
        _headerImgv.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _headerImgv.contentMode = UIViewContentModeScaleAspectFill;
        _headerImgv.layer.cornerRadius = 8;
    }
    return _headerImgv;
}

- (UIButton *)oneLoginBtn{
    if(!_oneLoginBtn){
        _oneLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneLoginBtn setTitle:@"本地钱包登陆" forState:UIControlStateNormal];
        [_oneLoginBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_oneLoginBtn addTarget:self action:@selector(oneLoginAction) forControlEvents:UIControlEventTouchUpInside];
        _oneLoginBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _oneLoginBtn.layer.cornerRadius = 25.0;
        
    }
    return _oneLoginBtn;
}
- (UIButton *)twoLoginBtn{
    if(!_twoLoginBtn){
        _twoLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twoLoginBtn setTitle:@"外部钱包登录" forState:UIControlStateNormal];
        [_twoLoginBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_twoLoginBtn addTarget:self action:@selector(twoLoginAction) forControlEvents:UIControlEventTouchUpInside];
        _twoLoginBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _twoLoginBtn.layer.cornerRadius = 25.0;
        
    }
    return _twoLoginBtn;
}


- (UILabel *)logoLabel{
    if(!_logoLabel){
        _logoLabel = [[UILabel alloc]init];
        _logoLabel.textColor = [UIColor whiteColor];
        _logoLabel.font = [UIFont systemFontOfSize:30.0];
        _logoLabel.textAlignment = NSTextAlignmentCenter;
        _logoLabel.text = @"FreeperChat";
    }
    return _logoLabel;
}

- (UIButton *)agreeBtn{
    if(!_agreeBtn){
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"round_white"] selectedImg:[UIImage imageNamed:@"round_white"]];
        [_agreeBtn addTarget:self action:@selector(agreeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}

- (UILabel *)agreeL{
    if(!_agreeL){
        _agreeL = [[UILabel alloc]init];
        _agreeL.textColor = [UIColor whiteColor];
        _agreeL.font = [UIFont systemFontOfSize:15.0];
        //_agreeL.textAlignment = NSTextAlignmentCenter;
        _agreeL.text = @"本人已阅读并同意 用户协议 和 隐私协议";
        _agreeL.numberOfLines = 2;
    }
    return _agreeL;
}


#pragma mark==
- (void)oneLoginAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchLoginWithType:)]) {
        [_delegate touchLoginWithType:Login_Type_local];
    }
}

- (void)twoLoginAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchLoginWithType:)]) {
        [_delegate touchLoginWithType:Login_Type_outside];
    }
}

- (void)agreeBtnAction:(UIButton *)agreeB{
    self.agreeBtn.selected = !self.agreeBtn.selected;
}
@end
