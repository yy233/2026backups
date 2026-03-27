//
//  MoneyWalletVcLateTopView.m
//  Community
//
//  Created by 余莹 on 2021/10/12.
//

#import "MoneyWalletVcLateTopView.h"

@implementation MoneyWalletVcLateTopView

- (void)fillDataWithYuE:(double)yue {
    self.moneyL.text = [NSString stringWithFormat:@"%0.2f",yue];
}

#pragma mark ==
- (void)tiXianBtnAction{
    
    if (_delegate && [_delegate respondsToSelector:@selector(goToTiXianBtnAction)]) {
        [_delegate goToTiXianBtnAction];
    }
} 
 
#pragma mark=

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 110);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        UIColor *beginColor =  Y_RGBA(38, 114, 249, 1);
        UIColor *endColor =  Y_RGBA(56, 128, 251, 1);
        CGSize size = CGSizeMake(Screen_W-32, 110);//h
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        //
        self.backView.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
        self.backView.layer.cornerRadius = 5;
        //
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.titleLabelRight];
        self.titleLabelRight.hidden = YES;
        //
        [self.backView addSubview:self.moneyL];
        [self.backView addSubview:self.tiXianBtn];
//        //
//        [self.backView addSubview:self.lineV];
//        [self.backView addSubview:self.yuemingxiLabel];
//        [self.backView addSubview:self.jiantouimgV];
//        [self.backView addSubview:self.yuemingxiCleanBtn];
        [self setUI];
 
    }
    return self;
}

 
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(20);
        make.left.equalTo(_titleL.superview.mas_left).offset(10);
        make.height.offset(30);
    }];
    [_titleLabelRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(_titleL);
        make.right.equalTo(_titleLabelRight.superview.mas_right).offset(-10);
    }];
    //
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_moneyL.superview.mas_centerY).offset(10);
        make.left.equalTo(_titleL);
        make.height.offset(30);
    }];
    [_tiXianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLabelRight.mas_right);
        make.width.offset(60);
        make.height.offset(20);
        make.centerY.equalTo(_moneyL.mas_centerY);
    }];
//    //
//    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_moneyL.mas_bottom).offset(20);
//        make.left.equalTo(_titleL.mas_left);
//        make.right.equalTo(_titleLabelRight.mas_right);
//        make.height.offset(1);
//    }];
//    //
//    [_yuemingxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.height.equalTo(_titleL);
//        make.bottom.equalTo(_yuemingxiLabel.superview.mas_bottom).offset(-10);
//    }];
//    [_jiantouimgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_bangKaBtn.mas_right);
//        make.width.offset(5);
//        make.height.offset(10);
//        make.centerY.equalTo(_yuemingxiLabel);
//    }];
//    [_yuemingxiCleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.equalTo(_yuemingxiLabel);
//        make.right.equalTo(_jiantouimgV);
//    }];
    
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"余额（元）";
        _titleL.textColor = Y_RGBA(207, 220, 254, 1);
        _titleL.font = FontSize_MoneyWallet_Nomail(12);
    }
    return _titleL;
}
- (UILabel *)titleLabelRight{
    if (!_titleLabelRight) {
        _titleLabelRight = [[UILabel alloc]init];
        _titleLabelRight.text = @"银行卡(张)";
        _titleLabelRight.textColor = Y_RGBA(207, 220, 254, 1);
        _titleLabelRight.font = FontSize_MoneyWallet_Nomail(12);
    }
    return _titleLabelRight;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.text = @"0.00";
        _moneyL.textColor = [UIColor whiteColor];
        _moneyL.font = FontSize_MoneyWallet_Bold(30);
    }
    return _moneyL;
}
- (UIButton *)tiXianBtn{
    if (!_tiXianBtn) {
        _tiXianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tiXianBtn newAnBtnWithTextStr:@"提现"];
        [_tiXianBtn newAnBtnWithTextColor:Y_RGBA(207, 220, 254, 1)];
        [_tiXianBtn newAnBtnWithLayerCorNerNum:10 withLayerLineWidth:0.5 withLayerLineColor:Y_RGBA(207, 220, 254, 1)];
        _tiXianBtn.titleLabel.font = FontSize_MoneyWallet_Nomail(12);
        _tiXianBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
        [_tiXianBtn addTarget:self action:@selector(tiXianBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tiXianBtn;
}
 
 
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = Color_38BlueColor;
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
@end
