//
//  ElectronicNotRealNameAuthenticationView.m
//  Community
//
//  Created by 余莹 on 2021/1/26.
//

#import "ZYElectronicNotRealNameAuthenticationView.h"
@interface ZYElectronicNotRealNameAuthenticationView ()

@end
@implementation ZYElectronicNotRealNameAuthenticationView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, Screen_H-KNavBarHeight);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.centerImgV];
        [self addSubview:self.titleL];
        [self addSubview:self.detailL];
        [self addSubview:self.goToAuthenticatBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_centerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImgV.superview).offset(30);
        make.centerX.equalTo(_centerImgV.superview.mas_centerX);
        make.width.offset(249);
        make.height.offset(189);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL.superview).insets(UIEdgeInsetsMake(0, 50, 0, 50));
        make.height.offset(30);
        make.top.equalTo(_centerImgV.mas_bottom).offset(30);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_detailL.superview).insets(UIEdgeInsetsMake(0, 50, 0, 50));
        make.height.offset(20);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
    }];
    [_goToAuthenticatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(300);
        make.height.offset(50);
        make.centerX.equalTo(_goToAuthenticatBtn.superview.mas_centerX);
        make.top.equalTo(_detailL.mas_bottom).offset(60);
    }];

}
#pragma mark ==
- (UIImageView *)centerImgV{
    if (!_centerImgV) {
        _centerImgV = [[UIImageView alloc]init];
        _centerImgV.image = [UIImage imageNamed:@"smrz"];
        _centerImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerImgV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"未实名认证";
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _titleL.font = [UIFont boldSystemFontOfSize:27];
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.text = @"为了您的业务发展和合同签，请订尽快认证";
        _detailL.textAlignment = NSTextAlignmentCenter;
        _detailL.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        _detailL.font = [UIFont systemFontOfSize:12];
    }
 
    return _detailL;
}
- (UIButton *)goToAuthenticatBtn{
    if (!_goToAuthenticatBtn) {
        _goToAuthenticatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goToAuthenticatBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_goToAuthenticatBtn setTitle:@"立即去认证" forState:UIControlStateNormal];
        [_goToAuthenticatBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        _goToAuthenticatBtn.layer.cornerRadius = 25;//h 50
        CGSize size = CGSizeMake(300, 50);
        _goToAuthenticatBtn.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
    }
    return _goToAuthenticatBtn;
}
@end
