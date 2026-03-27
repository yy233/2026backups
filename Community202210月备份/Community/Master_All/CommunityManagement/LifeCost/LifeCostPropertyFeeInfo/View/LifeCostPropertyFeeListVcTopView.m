//
//  LifeCostPropertyFeeListVcTopView.m
//  Community
//
//  Created by 余莹 on 2021/7/6.
//

#import "LifeCostPropertyFeeListVcTopView.h"

@implementation LifeCostPropertyFeeListVcTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 110);//无间隔 100 有间隔则加
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftImgV];
        [self addSubview:self.addressBtn];
        [self addSubview:self.twoBtnBackView];
        [self.twoBtnBackView addSubview:self.twoBtnCenterLineView];
        [self.twoBtnBackView addSubview:self.oneBtn];
        [self.twoBtnBackView addSubview:self.twoBtn];
        self.oneBtn.selected = YES;
        self.twoBtn.selected = NO;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    
    [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressBtn.superview).offset(10);
        make.height.offset(30);
        make.centerX.equalTo(_addressBtn.superview);
    }];
    [_addressBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5.0];

    
    [_leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.right.equalTo(_addressBtn.mas_left).offset(-5);
        make.centerY.equalTo(_addressBtn);
    }];
    //
    [_twoBtnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressBtn.mas_bottom).offset(10);
        make.width.equalTo(_twoBtnBackView.superview).offset(-32);
        make.centerX.equalTo(_twoBtnBackView.superview);
        make.height.offset(50);
    }];
    [_twoBtnCenterLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_twoBtnCenterLineView.superview);
        make.width.offset(1);
        make.height.offset(20);
    }];
    //
    [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_oneBtn.superview).multipliedBy(0.48);
        make.top.bottom.equalTo(_oneBtn.superview);
        make.right.equalTo(_oneBtn.superview.mas_centerX).offset(-2);
    }];
    [_twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_twoBtn.superview).multipliedBy(0.48);
        make.top.bottom.equalTo(_twoBtn.superview);
        make.left.equalTo(_twoBtn.superview.mas_centerX).offset(2);
    }];

    
}
- (UIImageView *)leftImgV{
    if (!_leftImgV) {
        _leftImgV = [[UIImageView alloc]init];
        _leftImgV.contentMode = UIViewContentModeScaleAspectFit;
        _leftImgV.image = [[UIImage imageNamed:@"details_location"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _leftImgV.tintColor =  [ThemeManager shareManager].mainTextColor;//源图附色 
    }
    return _leftImgV;
}
- (UIButton *)addressBtn{
    if (!_addressBtn ) {
        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_addressBtn newAnBtnWithImg:[UIImage imageNamed:@"drop_down_B"]];

        }else{
            [_addressBtn newAnBtnWithImg:[UIImage imageNamed:@"drop_down_W"]];
        }
        [_addressBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
        [_addressBtn addTarget:self action:@selector(addressBtnTouchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressBtn;
}

- (UIView *)twoBtnBackView{
    if (!_twoBtnBackView) {
        _twoBtnBackView = [[UIView alloc]init];
        _twoBtnBackView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
        _twoBtnBackView.layer.cornerRadius = 20;
        _twoBtnBackView.layer.masksToBounds = YES;
    }
    return _twoBtnBackView;
}
- (UIView *)twoBtnCenterLineView{
    if (!_twoBtnCenterLineView) {
        _twoBtnCenterLineView = [[UIView alloc]init];
        _twoBtnCenterLineView.backgroundColor =  [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.6];
    }
    return _twoBtnCenterLineView;
}
- (UIButton *)oneBtn{
    if(!_oneBtn){
        _oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneBtn newAnBtnWithTextColorNomal:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5] withTextColorSelected:[ThemeManager shareManager].mainTextColor];
        [_oneBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:16]];
        [_oneBtn newAnBtnWithTextStr:@"待缴纳"];
        [_oneBtn addTarget:self action:@selector(oneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneBtn;
}
- (UIButton *)twoBtn{
    if(!_twoBtn){
        _twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twoBtn newAnBtnWithTextColorNomal:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5] withTextColorSelected:[ThemeManager shareManager].mainTextColor];
        [_twoBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:16]];
        [_twoBtn newAnBtnWithTextStr:@"已缴纳"];
        [_twoBtn addTarget:self action:@selector(twoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _twoBtn;
}
- (void)oneBtnAction{
    if (_oneBtn.selected) {
        return;
    }
    _oneBtn.selected = YES;
    _twoBtn.selected = NO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(chooseStaussIndexWithStaus:)]) {
        [_delegate chooseStaussIndexWithStaus:LifeCostPropertyFeeListVcTopView_Staus_NoPay];//@"待缴纳"
    }
    
}
- (void)twoBtnAction{
    if (_twoBtn.selected) {
        return;
    }
    _oneBtn.selected = NO;
    _twoBtn.selected = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(chooseStaussIndexWithStaus:)]) {
        [_delegate chooseStaussIndexWithStaus:LifeCostPropertyFeeListVcTopView_Staus_Payed];//@"已缴纳"
    }
    
}

#pragma mark ==
- (void)addressBtnTouchAction{
    if (isNil(self.delegate)) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(topAddressBtnTouchAction)]) {
        [_delegate topAddressBtnTouchAction];
    }
    
}
@end
