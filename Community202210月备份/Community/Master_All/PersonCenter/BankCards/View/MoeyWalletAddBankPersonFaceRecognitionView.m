//
//  MoeyWalletAddBankPersonFaceRecognitionView.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "MoeyWalletAddBankPersonFaceRecognitionView.h"

@implementation MoeyWalletAddBankPersonFaceRecognitionView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, Screen_H-KNavBarHeight);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topL];
        [self addSubview:self.tipBtn];
        [self addSubview:self.centerView];
        [self.centerView addSubview:self.centerTipL];
        [self addSubview:self.bottomEgBtn];
        [self addSubview:self.bottomTipShowAgreementBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_topL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topL.superview);
        make.height.offset(40);
    }];
    [_tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tipBtn.superview);
        make.height.offset(20);
        make.top.equalTo(_topL.mas_bottom).offset(10);
    }];
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerView.superview);
        make.top.equalTo(_tipBtn.mas_bottom).offset(20);
        make.width.equalTo(_centerView.superview).multipliedBy(0.6);//w
        make.height.equalTo(_centerView.mas_width);
    }];
    [_centerTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerTipL.superview).offset(30);
        make.left.right.equalTo(_centerTipL.superview);
        make.height.offset(20);
    }];
    //
    [_bottomTipShowAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bottomTipShowAgreementBtn.superview);
        make.bottom.equalTo(_bottomTipShowAgreementBtn.superview).offset(-20);
        make.height.offset(20);
    }];
    [_bottomEgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomEgBtn.superview);
        make.top.equalTo(_centerView.mas_bottom);
        make.bottom.equalTo(_bottomTipShowAgreementBtn.mas_top);
        make.width.offset(80);
    }];
}

#pragma mark ==
- (UILabel *)topL{
    if (!_topL) {
        _topL = [[UILabel alloc]init];
        _topL.font = FontSize_MoneyWallet_Bold(22);
        _topL.textAlignment = NSTextAlignmentCenter;
        _topL.text = @"请手持手机对准镜头";
    }
    _topL.textColor = [ThemeManager shareManager].mainTextColor;
    return _topL;
}
- (UIButton *)tipBtn{
    if (!_tipBtn) {
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(12)];
        [_tipBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0xFF8712)];
        [_tipBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        [_tipBtn newAnBtnWithTextStr:@"使用作弊手段进行验证，将被永久停止服务"];
        //
        UIImage *warnImg = [[UIImage imageNamed:@"warn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_tipBtn setImage:warnImg forState:UIControlStateNormal];
        [_tipBtn.imageView setTintColor:Y_ColorWith16FromRGB(0xFF8712)];
  
    }
    return _tipBtn;
}
//
- (UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc]init]; //0.6w
        _centerView.layer.cornerRadius = Screen_W*0.6*0.5;
        _centerView.layer.masksToBounds = YES;
        _centerView.backgroundColor = [UIColor blackColor];//
    }
    return _centerView;
}
- (UILabel *)centerTipL{
    if (!_centerTipL) {
        _centerTipL = [[UILabel alloc]init];
        _centerTipL.font = FontSize_MoneyWallet_Nomail(14);
        _centerTipL.textAlignment = NSTextAlignmentCenter;
        _centerTipL.text = @"请将正脸置于框内";
    }
    _centerTipL.textColor =  [ThemeManager shareManager].mainTextColor;
    return _centerTipL;
}
//
- (UIButton *)bottomEgBtn{
    if (!_bottomEgBtn) {
        _bottomEgBtn = [ UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomEgBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(15)];
        [_bottomEgBtn newAnBtnWithTextStr:@"拍摄示例"];
        [_bottomEgBtn newAnBtnWithImg:[UIImage imageNamed:@"Facerecognition_Headportrait_white"]];
        [_bottomEgBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleBottom imageTitleSpace:10];
    }
    [_bottomEgBtn newAnBtnWithTextColor:   [ThemeManager shareManager].mainTextColor];
    return _bottomEgBtn;
}
- (UIButton *)bottomTipShowAgreementBtn{
    if (!_bottomTipShowAgreementBtn) {
        _bottomTipShowAgreementBtn = [ UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomTipShowAgreementBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(12)];
        [_bottomTipShowAgreementBtn newAnBtnWithTextColor:[UIColor blackColor]];
        [_bottomTipShowAgreementBtn newAnBtnWithTextStr:@"查看《人脸验证协议》"];
    }
    return _bottomTipShowAgreementBtn;
}
@end
