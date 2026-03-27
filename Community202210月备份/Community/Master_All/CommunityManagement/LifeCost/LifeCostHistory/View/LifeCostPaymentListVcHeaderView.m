//
//  LifeCostPaymentListVcHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/1/11.
//

#import "LifeCostPaymentListVcHeaderView.h"
#define Color_subBtnSelected   Y_RGBA(38, 114, 249, 1)

@interface LifeCostPaymentListVcHeaderView ()
@property (nonatomic,strong) UIButton *payTypeChooseBtn;
@property (nonatomic,strong) UIButton *timeChooseBtn;
@end

@implementation LifeCostPaymentListVcHeaderView

- (void)fillNewShowChoosePayTypeStr:(NSString *)payTypeStr{
    if (payTypeStr.length==0) {
        [self.payTypeChooseBtn setTitle:@"全部费种" forState:UIControlStateNormal];
    }else{
        [self.payTypeChooseBtn setTitle:payTypeStr forState:UIControlStateNormal];
    }
    [self.payTypeChooseBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:4.0];
}
- (void)fillNewShowChooseTimeStr:(NSString *)timeStr{
    if (timeStr.length==0) {
        [self.timeChooseBtn setTitle:@"全部时间" forState:UIControlStateNormal];
    }else{
        [self.timeChooseBtn setTitle:timeStr forState:UIControlStateNormal];
    }
    [self.timeChooseBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:4.0];

}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self addSubview:self.payTypeChooseBtn];
        [self addSubview:self.timeChooseBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_payTypeChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payTypeChooseBtn.superview.mas_top);
        make.left.equalTo(_payTypeChooseBtn.superview.mas_left);
        make.width.equalTo(_payTypeChooseBtn.superview.mas_width).multipliedBy(0.5);
        make.height.offset(50);
    }];
    [_timeChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeChooseBtn.superview.mas_top);
        make.right.equalTo(_timeChooseBtn.superview.mas_right);
        make.width.equalTo(_timeChooseBtn.superview.mas_width).multipliedBy(0.5);
        make.height.offset(50);
    }];
    [self.payTypeChooseBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:4.0];
    [self.timeChooseBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:4.0];

}
#pragma mark ===
- (UIButton *)payTypeChooseBtn{
    if (!_payTypeChooseBtn) {
        _payTypeChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payTypeChooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_payTypeChooseBtn setTitle:@"全部费种" forState:UIControlStateNormal];
        [_payTypeChooseBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_payTypeChooseBtn setTitleColor:Color_subBtnSelected forState:UIControlStateSelected];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_payTypeChooseBtn newAnBtnWithImg:[UIImage imageNamed:@"skip_xiala"]];
        }else{
            [_payTypeChooseBtn newAnBtnWithImg:[UIImage imageNamed:@"skip_xiala_zhouye"]];
        }
        [_payTypeChooseBtn addTarget:self action:@selector(payTypeChooseBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _payTypeChooseBtn;
}
- (UIButton *)timeChooseBtn{
    if (!_timeChooseBtn) {
        _timeChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _timeChooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_timeChooseBtn setTitle:@"全部时间" forState:UIControlStateNormal];
        [_timeChooseBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_timeChooseBtn setTitleColor:Color_subBtnSelected forState:UIControlStateSelected];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_timeChooseBtn newAnBtnWithImg:[UIImage imageNamed:@"skip_xiala"]];
        }else{
            [_timeChooseBtn newAnBtnWithImg:[UIImage imageNamed:@"skip_xiala_zhouye"]];
        }
        [_timeChooseBtn addTarget:self action:@selector(timeChooseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeChooseBtn;
}
- (void)payTypeChooseBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchOneChoosePayTypeBtn)]) {
        [_delegate touchOneChoosePayTypeBtn];
    }
}
- (void)timeChooseBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchOneChooseTimeBtn)]) {
        [_delegate touchOneChooseTimeBtn];
    }
}
@end
