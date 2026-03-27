//
//  ElectroniRealNameAuthenticationHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/2/24.
//
//共用实名认证的headerview
#import "ElectroniRealNameAuthenticationBaseHeaderView.h"

@implementation ElectroniRealNameAuthenticationBaseHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 110);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.cardBtn];
        [self addSubview:self.faceBtn];
        [self addSubview:self.cardBottomImgV];
        [self addSubview:self.faceBottomImgV];
        [self addSubview:self.centerImgView];
        [self addSubview:self.bottomLineV];
        [self setUI];
        [self setHeaderViewType:ElectroniRealNameAuthenticationHeaderView_Type_Card];
    }
    return self;
}

- (void)setHeaderViewType:(ElectroniRealNameAuthenticationHeaderView_Type)selectedBtnType{
    if (selectedBtnType==ElectroniRealNameAuthenticationHeaderView_Type_Card) {
        self.cardBottomImgV.hidden = NO;
        self.faceBottomImgV.hidden = YES;
        self.cardBtn.selected = NO;
        self.faceBtn.selected = NO;
    }
    if (selectedBtnType==ElectroniRealNameAuthenticationHeaderView_Type_Face) {
        self.cardBottomImgV.hidden = YES;
        self.faceBottomImgV.hidden = NO;
        self.cardBtn.selected = YES;
        self.faceBtn.selected = YES;
    }
}
//
- (void)setUI{
    [_centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerImgView.superview);
        make.centerY.equalTo(_centerImgView.superview).offset(-10);
        make.width.offset(22);
        make.height.offset(11);
    }];
    //
    [_cardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerImgView);
        make.centerX.equalTo(_cardBtn.superview).multipliedBy(0.5);
        make.width.offset(60);
        make.height.offset(70);
    }];
    [_faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerImgView);
        make.centerX.equalTo(_faceBtn.superview).multipliedBy(1.5);
        make.width.offset(60);
        make.height.offset(70);
    }];
    //
    [_cardBottomImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(8);
        make.centerX.equalTo(_cardBtn);
        make.bottom.equalTo(_cardBottomImgV.superview.mas_bottom).offset(-10);
    }];
    [_faceBottomImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(8);
        make.centerX.equalTo(_faceBtn);
        make.bottom.equalTo(_faceBottomImgV.superview.mas_bottom).offset(-10);
    }];
    //
    [_bottomLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_faceBottomImgV.superview);
        make.height.offset(10);
    }];
  
}
#pragma mark ==
//
- (UIButton *)cardBtn{
    if (!_cardBtn) {
        _cardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cardBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"identity"] selectedImg:[UIImage imageNamed:@"card_success"]];
        [_cardBtn newAnBtnWithTextStr:@"身份认证"];
        [_cardBtn newAnBtnWithTextColor:[UIColor blackColor]];
        [_cardBtn newAnBtnWithFont:[UIFont systemFontOfSize:12]];
        [_cardBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }
    return _cardBtn;
}
- (UIButton *)faceBtn{
    if (!_faceBtn) {
        _faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"Face"] selectedImg:[UIImage imageNamed:@"Face-recognition"]];
        [_faceBtn newAnBtnWithTextStr:@"人脸识别"];
        [_faceBtn newAnBtnWithTextColor:[UIColor blackColor]];
        [_faceBtn newAnBtnWithFont:[UIFont systemFontOfSize:12]];
        [_faceBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }
    return _faceBtn;
}
//
- (UIImageView *)centerImgView{
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc]init];
        _centerImgView.image = [UIImage imageNamed:@"guide"];
    }
    return _centerImgView;
}
- (UIImageView *)cardBottomImgV{
    if (!_cardBottomImgV) {
        _cardBottomImgV = [[UIImageView alloc]init];
        _cardBottomImgV.image = [UIImage imageNamed:@"Select"];
    }
    return _cardBottomImgV;
}
- (UIImageView *)faceBottomImgV{
    if (!_faceBottomImgV) {
        _faceBottomImgV = [[UIImageView alloc]init];
        _faceBottomImgV.image = [UIImage imageNamed:@"Select"];
    }
    return _faceBottomImgV;
}
- (UIView *)bottomLineV{
    if (!_bottomLineV) {
        _bottomLineV = [[UIView alloc]init];
        _bottomLineV.backgroundColor = Color_245Gray;
    }
    return _bottomLineV;
}
@end
