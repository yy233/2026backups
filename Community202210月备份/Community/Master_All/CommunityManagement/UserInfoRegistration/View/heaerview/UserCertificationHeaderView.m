//
//  UserCertificationHeaderView.m
//  Community
//
//  Created by 余莹 on 2020/11/23.
//
#define _BeginColor [UIColor colorWithRed:29/255.0 green:197/255.0 blue:165/255.0 alpha:1.0]
#define _EndColor [UIColor colorWithRed:119/255.0 green:234/255.0 blue:151/255.0 alpha:1.0]
#import "UserCertificationHeaderView.h"
@interface UserCertificationHeaderView ()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *centerTitleLabel;
@property (nonatomic,strong) UIButton *centerImgBtn;
@property (nonatomic,strong) UIButton *bottomRecognizerBtn;




@end
@implementation UserCertificationHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.typeLabel];
        [self.backView addSubview:self.centerTitleLabel];
        [self.backView addSubview:self.centerImgBtn];
        [self.backView addSubview:self.bottomRecognizerBtn];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(10,0, 20, 0));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(15);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(16);
        make.height.offset(20);
        make.width.offset(60);
    }];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel.superview.mas_top).offset(15);
        make.right.equalTo(_typeLabel.superview.mas_right).offset(-16);
        make.height.offset(20);
        make.width.offset(60);
    }];
    [_centerImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImgBtn.superview.mas_top).offset(25);
//        make.height.equalTo(_centerImgBtn.superview.mas_height).multipliedBy(0.4);
        make.height.offset(130);
        make.width.equalTo(_centerImgBtn.mas_height);
        make.centerX.equalTo(_centerImgBtn.superview.mas_centerX);
    }];
    [_centerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImgBtn.mas_bottom).offset(5);
        make.height.offset(20);
        make.width.equalTo(_centerImgBtn.mas_width).offset(50);
        make.centerX.equalTo(_centerTitleLabel.superview.mas_centerX);
    }];
    [_bottomRecognizerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerTitleLabel.mas_bottom).offset(10);
        make.height.offset(40);
        make.width.equalTo(_bottomRecognizerBtn.superview.mas_width).multipliedBy(0.6);
        make.centerX.equalTo(_bottomRecognizerBtn.superview.mas_centerX);
    }];
}

#pragma mark ==
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5;
    }
    return _backView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _titleLabel.text = @"人脸识别";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textColor = [ThemeManager shareManager].mainTexDetailLightBluetColor;
        _typeLabel.text = @"未识别";
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _typeLabel;
}
- (UIButton *)centerImgBtn{
    if (!_centerImgBtn) {
        _centerImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _centerImgBtn.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
//        _centerImgBtn.layer.cornerRadius = ;
        [_centerImgBtn setImage:[UIImage imageNamed:@"Ownercertification_Face_Illustration_night"] forState:UIControlStateNormal];
    }
    return _centerImgBtn;
}
- (UILabel *)centerTitleLabel{
    if (!_centerTitleLabel) {
        _centerTitleLabel = [[UILabel alloc]init];
        _centerTitleLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _centerTitleLabel.text = @"获得更快捷的登录体验";
        _centerTitleLabel.textAlignment = NSTextAlignmentCenter;
        _centerTitleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _centerTitleLabel;
}
- (UIButton *)bottomRecognizerBtn{
    if (!_bottomRecognizerBtn) {
        _bottomRecognizerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomRecognizerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomRecognizerBtn setTitle:@"进入识别" forState:UIControlStateNormal];
        [_bottomRecognizerBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        _bottomRecognizerBtn.layer.cornerRadius = 20;
        _bottomRecognizerBtn.backgroundColor =   Y_Gradient_Color(Screen_W*0.6,40,_BeginColor,_EndColor);
//        [UIColor bm_colorGradientChangeWithSize:CGSizeMake(width, height) direction:IHGradientChangeDirectionLevel startColor:_BeginColor endColor:_EndColor]
        [_bottomRecognizerBtn addTarget:self action:@selector(bottomRecognizerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomRecognizerBtn;
}
- (void)bottomRecognizerBtnAction:(UIButton *)sender{
    Y_SVP_SHOW_ERR_MES(@"暂不支持")
}
@end
