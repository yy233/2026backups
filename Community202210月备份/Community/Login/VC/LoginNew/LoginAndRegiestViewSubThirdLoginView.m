//
//  LoginAndRegiestViewSubThirdLoginView.m
//  Community
//
//  Created by 余莹 on 2022/5/13.
//

#import "LoginAndRegiestViewSubThirdLoginView.h"
#import "LoginAndRegiestNewHeader.h"


@implementation LoginAndRegiestViewSubThirdLoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.thridBackGroundView];
        [self.thridBackGroundView addSubview:self.thridTitleLabel];
        [self.thridBackGroundView addSubview:self.appleLoginBtn];
        [self.thridBackGroundView addSubview:self.zfbLoginBtn];
        [self.thridBackGroundView addSubview:self.wxLoginBtn];
        [self  setThisUI];
    }
    return self;
}

- (void)setThisUI{
    CGFloat h_backV = 90;
    [_thridBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thridBackGroundView).offset(0);
        make.centerX.equalTo(_thridBackGroundView.superview.mas_centerX);
        make.width.equalTo(_thridBackGroundView.superview.mas_width).multipliedBy(0.7);
        make.height.offset(h_backV);//高度的屏幕做限制 会让topbackv拉伸适应
    }];
    [_thridTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_thridBackGroundView.mas_left);
        make.right.equalTo(_thridBackGroundView.mas_right);
        make.height.offset(15);
        make.top.equalTo(_thridBackGroundView).offset(0);
    }];
    //
    [_appleLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_thridBackGroundView.mas_centerX).multipliedBy(0.33);
        make.top.equalTo(_thridTitleLabel.mas_bottom).offset(10);
        make.width.equalTo(_thridBackGroundView.mas_width).multipliedBy(0.2);
        make.height.equalTo(_thridBackGroundView.mas_width).multipliedBy(0.2);
    }];
    [_zfbLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_thridBackGroundView.mas_centerX).multipliedBy(1);
        make.height.equalTo(_appleLoginBtn.mas_height);
        make.width.equalTo(_appleLoginBtn.mas_width);
        make.centerY.equalTo(_appleLoginBtn.mas_centerY);
    }];
    [_wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_thridBackGroundView.mas_centerX).multipliedBy(1.67);
        make.height.equalTo(_appleLoginBtn.mas_height);
        make.width.equalTo(_appleLoginBtn.mas_width);
        make.centerY.equalTo(_appleLoginBtn.mas_centerY);
    }];
   
}
#pragma mark =====
- (UIView *)thridBackGroundView{
    if (!_thridBackGroundView) {
        _thridBackGroundView = [[UIView alloc]init];
    }
    return _thridBackGroundView;
}
- (UILabel *)thridTitleLabel{
    if (!_thridTitleLabel) {
        _thridTitleLabel = [[UILabel alloc]init];
        _thridTitleLabel.text = @"————  第三方登录  ————";
        _thridTitleLabel.textColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty;
        _thridTitleLabel.font = [UIFont systemFontOfSize:14];
        _thridTitleLabel.numberOfLines = 1;
        _thridTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _thridTitleLabel;
}
- (UIButton *)wxLoginBtn{
    if (!_wxLoginBtn) {
        _wxLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wxLoginBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"weixin"] forState:UIControlStateNormal];
        _wxLoginBtn.tag = Tag_LoginAndRegiest_WxLogin + Tag_LoginAndRegiest_Base;
    }
    return _wxLoginBtn;
}
- (UIButton *)zfbLoginBtn{
    if (!_zfbLoginBtn) {
        _zfbLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zfbLoginBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"zhifubao"] forState:UIControlStateNormal];
        _zfbLoginBtn.tag = Tag_LoginAndRegiest_ZfbLogin + Tag_LoginAndRegiest_Base;
    }
    return _zfbLoginBtn;
}
- (UIButton *)appleLoginBtn{
    if (!_appleLoginBtn) {
        _appleLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_appleLoginBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"Apple"] forState:UIControlStateNormal];
        _appleLoginBtn.tag = Tag_LoginAndRegiest_AppleLogin + Tag_LoginAndRegiest_Base;
    }
    return _appleLoginBtn;
}
@end
