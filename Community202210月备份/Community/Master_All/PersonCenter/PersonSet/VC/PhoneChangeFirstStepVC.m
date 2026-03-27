//
//  PhoneChangeFirstStepVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "PhoneChangeFirstStepVC.h"
#import "PhoneChangeSecondStepVC.h"
//
#import "SafetyCenterViewModel.h"
@interface PhoneChangeFirstStepVC ()

@property(nonatomic, strong) UIImageView *imageV;

@property(nonatomic, strong) UILabel *textL;

@property(nonatomic, strong) UIButton *btn;

@end

@implementation PhoneChangeFirstStepVC

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
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.offset(50);
        make.width.offset(85);
        make.height.offset(85);
    }];
    
    [self.textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.imageV.mas_bottom).offset(30);
        make.left.offset(53);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.offset(37);
        make.height.offset(45);
        make.bottom.mas_equalTo(self.view).offset(-30);
    }];
    self.textL.textColor = [ThemeManager shareManager].mainTextColor;
    self.view.backgroundColor = [ThemeManager shareManager].themeBackGroundColor;
}

#pragma mark - 懒加载

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
//        _imageV.image = [UIImage imageNamed:@"security"];
        _imageV.image = [UIImage imageNamed:@"testing"];
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 1;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 10000;
        [_imageV.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [self.view addSubview:_imageV];
    }
    return _imageV;
}

- (UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc] init];
        _textL.text = @"您的账户当前处于安全环境，可直接输入更换的新手机号";
//        _textL.text = @"正在检测您的账户环境...";
        _textL.font = FontSize_Vip_Nomail(15);
        _textL.numberOfLines = 0;
        _textL.textColor = [Tool getColorWithHexString:@"#333333"];
        _textL.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_textL];
    }
    return _textL;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"立即更换" forState:UIControlStateNormal];
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
    PhoneChangeSecondStepVC *vc = [[PhoneChangeSecondStepVC alloc] init];
    [self pushVc:vc];
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
