//
//  ParkingPayInfoHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/8/7.
//

#import "ParkingPayInfoHeaderView.h"

@interface ParkingPayInfoHeaderView ()
@property (nonatomic,strong) UIButton *oneBtn;
@property (nonatomic,strong) UIButton *twoBtn;
@property (nonatomic,strong) UIView *lineV;

@end

@implementation ParkingPayInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0,0, Screen_W, 40);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.oneBtn];
        [self addSubview:self.twoBtn];
        [self addSubview:self.lineV];
        [self setUI];
        self.oneBtn.selected = YES;
        self.twoBtn.selected = NO;
    }
    return self;
}
- (void)setUI{
    [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_oneBtn.superview);
        make.width.equalTo(_oneBtn.superview).multipliedBy(0.5);
    }];
    [_twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_twoBtn.superview);
        make.width.equalTo(_twoBtn.superview).multipliedBy(0.5);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_lineV.superview);
        make.width.offset(1);
        make.height.equalTo(_lineV.superview).multipliedBy(0.5);
    }];
}
#pragma mark ==
- (UIButton *)oneBtn{
    if (!_oneBtn) {
        _oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor withBackColor:Color_11BlueColor withFont:[UIFont boldSystemFontOfSize:15] withLayerCorNerNum:0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_oneBtn newAnBtnWithTextStr:@"临时缴费"];
        [_oneBtn newAnBtnWithTextColorNomal:[[ThemeManager shareManager].mainTextColor  colorWithAlphaComponent:0.7] withTextColorSelected:[ThemeManager shareManager].mainTextColor];
        [_oneBtn addTarget:self action:@selector(oneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneBtn;
}
- (UIButton *)twoBtn{
    if (!_twoBtn) {
        _twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twoBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor withBackColor:Color_11BlueColor withFont:[UIFont boldSystemFontOfSize:15] withLayerCorNerNum:0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_twoBtn newAnBtnWithTextStr:@"月租缴费"];
        [_twoBtn newAnBtnWithTextColorNomal:[[ThemeManager shareManager].mainTextColor  colorWithAlphaComponent:0.7] withTextColorSelected:[ThemeManager shareManager].mainTextColor];
        [_twoBtn addTarget:self action:@selector(twoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _twoBtn;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = Y_ColorWith16FromRGB(0xABC1E8);
    }
    return _lineV;
}
#pragma mark ===
- (void)oneBtnAction{
    if (_oneBtn.selected == YES) {
        return;
    }else{
        _oneBtn.selected = YES;
        _twoBtn.selected = NO;
    }
    self.touchUpBlock(0);
}
- (void)twoBtnAction{
    if (_twoBtn.selected == YES) {
        return;
    }else{
        _oneBtn.selected = NO;
        _twoBtn.selected = YES;
    }
    self.touchUpBlock(1); 
}
@end
