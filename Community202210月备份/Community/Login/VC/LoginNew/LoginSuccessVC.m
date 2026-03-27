//
//  LoginSuccessVC.m
//  Community
//
//  Created by 余莹 on 2022/5/14.
//@"注册成功"

#import "LoginSuccessVC.h"

@interface LoginSuccessVC ()
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *reSultLabel;
@property (nonatomic,strong) UILabel *detailL;
@property (nonatomic,strong) UIButton *finishBtn;
//记录跳转
@property (nonatomic,assign) NSInteger gotoMainVcIndex;
//
@end

@implementation LoginSuccessVC
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.gotoMainVcIndex <=0) {
        self.gotoMainVcIndex += 1;
        [self finishBtnAction];
    }
 
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //2秒即可跳转到主页
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.gotoMainVcIndex <=0) {
            self.gotoMainVcIndex += 1;
            [self finishBtnAction];
        }
    });
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}
- (void)initData{
    _reSultLabel.text = @"注册成功";
    _imgV.image = [UIImage imageNamed:@"Paymentresults_Success_night"];
    _detailL.text = @"即将进入小区";
}
- (void)finishBtnAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        //进入app
        [IsLoginTool share].save_Login_Type = IS_Login_Nomal;//普通有账号且绑定手机的登录类型
        self.view.window.rootViewController = [[TabBarController alloc] init];
    });

}
#pragma mark ===
- (void)initView{
    [self.view addSubview:self.imgV];
    [self.view addSubview:self.reSultLabel];
    [self.view addSubview:self.detailL];
    [self.view addSubview:self.finishBtn];
    self.finishBtn.hidden = YES;
    [self setUI];
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgV.superview.mas_centerX);
        make.centerY.equalTo(_imgV.superview).multipliedBy(0.62);//中间偏上
        make.width.offset(90);
        make.height.offset(90);
    }];
    [_reSultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.mas_bottom).offset(15);
        make.left.equalTo(_reSultLabel.superview.mas_left);
        make.right.equalTo(_reSultLabel.superview.mas_right);
        make.height.offset(20);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_reSultLabel.mas_bottom).offset(10);
        make.left.equalTo(_detailL.superview.mas_left);
        make.right.equalTo(_detailL.superview.mas_right);
        make.height.offset(20);
    }];
    [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_finishBtn.superview.mas_centerX);
        make.width.offset(150);
        make.height.offset(35);
        make.bottom.equalTo(_finishBtn.superview.mas_bottom).offset(-50);
    }];
}
#pragma mark ===
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
    }
    return _imgV;
}

- (UILabel *)reSultLabel{
    if (!_reSultLabel) {
        _reSultLabel = [[UILabel alloc]init];
        _reSultLabel.textColor = [UIColor whiteColor];
        _reSultLabel.font = [UIFont boldSystemFontOfSize:22];
        _reSultLabel.textAlignment = NSTextAlignmentCenter;
      
    }
    return _reSultLabel;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.font = [UIFont systemFontOfSize:14];
        _detailL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        _detailL.numberOfLines = 0;
        _detailL.textAlignment = NSTextAlignmentCenter;
    }
    return _detailL;
}
- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn  addTarget:self action:@selector(finishBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _finishBtn.layer.cornerRadius = 12.5;//35_H
        _finishBtn.layer.borderWidth = 1;
        _finishBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _finishBtn;
}
 
@end
