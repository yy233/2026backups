//
//  EIntergralMallVcHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "EIntergralMallVcHeaderView.h"
#define  Color_NavBack    Y_ColorWith16FromRGB(0x25283B)
@implementation EIntergralMallVcHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0,0, Screen_W, 200);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topBackV];
        [self.topBackV addSubview:self.eNumL];
        [self.topBackV addSubview:self.eMingXiBtn];
        [self addSubview:self.bottomBackV];
        [self.bottomBackV addSubview:self.eMallBtn];
        [self.bottomBackV addSubview:self.eOrderBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_topBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topBackV.superview);
        make.height.equalTo(_topBackV.superview).multipliedBy(0.6);
    }];
    [_bottomBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomBackV.superview).offset(16);
        make.right.equalTo(_bottomBackV.superview).offset(-16);
        make.bottom.equalTo(_bottomBackV.superview).offset(-10);
        make.height.equalTo(_topBackV.superview).multipliedBy(0.5);
    }];
    [self topUI];
    [self bottomUI];
}
- (void)topUI{
    [_eNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_eNumL.superview);
        make.height.offset(40);
    }];
    [_eMingXiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_eNumL.mas_bottom).offset(10);
        make.centerX.equalTo(_eNumL.superview);
        make.width.offset(60);
    }];
}
- (void)bottomUI{
    [_eMallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_eMallBtn.superview);
        make.left.equalTo(_eMallBtn.superview);
        make.right.equalTo(_eMallBtn.superview.mas_centerX);
    }];
    [_eOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_eMallBtn.superview);
        make.right.equalTo(_eMallBtn.superview);
        make.left.equalTo(_eMallBtn.superview.mas_centerX);
    }];
}

#pragma mark ==
- (UIView *)topBackV{
    if (!_topBackV) {
        _topBackV = [[UIView alloc]init];
        _topBackV.backgroundColor = Color_NavBack;
    }
    return _topBackV;
}
- (UILabel *)eNumL{
    if (!_eNumL) {
        _eNumL = [[UILabel alloc]init];
        _eNumL.textColor = [UIColor whiteColor];
        _eNumL.font  = FontSize_MoneyWallet_Bold(33);
        _eNumL.textAlignment = NSTextAlignmentCenter;
    }
    return _eNumL;
}
- (UIButton *)eMingXiBtn{
    if (!_eMingXiBtn) {
        _eMingXiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eMingXiBtn newAnBtnWithTextStr:@"E币明细"];
        [_eMingXiBtn newAnBtnWithTextColor:Color_245Gray];
        [_eMingXiBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(12)];
        [_eMingXiBtn newAnBtnWithImg:[UIImage imageNamed:@"skip"]];//rightSkip_white
        [_eMingXiBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [_eMingXiBtn addTarget:self action:@selector(eMingXiBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eMingXiBtn;
}
//
- (UIView *)bottomBackV{
    if (!_bottomBackV) {
        _bottomBackV = [[UIView alloc]init];
        _bottomBackV.layer.cornerRadius = 7.5;
        _bottomBackV.layer.masksToBounds = YES;
        _bottomBackV.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBackV;
}
- (UIButton *)eMallBtn{
    if (!_eMallBtn) {
        _eMallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eMallBtn newAnBtnWithTextColor:[UIColor blackColor]];
        [_eMallBtn newAnBtnWithTextStr:@"E币商城"];
        [_eMallBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(14)];
        [_eMallBtn newAnBtnWithImg:[UIImage imageNamed:@"Ecoin_ShoppingMall"]];
        [_eMallBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [_eMallBtn addTarget:self action:@selector(eMallBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eMallBtn;
}
- (UIButton *)eOrderBtn{
    if (!_eOrderBtn) {
        _eOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eOrderBtn newAnBtnWithTextColor:[UIColor blackColor]];
        [_eOrderBtn newAnBtnWithTextStr:@"我的订单"];
        [_eOrderBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(14)];
        [_eOrderBtn newAnBtnWithImg:[UIImage imageNamed:@"Ecoin_order"]];
        [_eOrderBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [_eOrderBtn addTarget:self action:@selector(eOrderBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eOrderBtn;
}
#pragma mark ==
- (void)eMingXiBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(headerViewTouchMingXiAction)]) {
        [_delegate headerViewTouchMingXiAction];
    }
}
- (void)eMallBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(headerViewTouchEMallAction)]) {
        [_delegate headerViewTouchEMallAction];
    }
}
- (void)eOrderBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(headerViewTouchEOrderAction)]) {
        [_delegate headerViewTouchEOrderAction];
    }
}
@end
