//
//  LifeCostPropertyFeeListVcBottomPayInfoView.m
//  Community
//
//  Created by 余莹 on 2021/7/8.
//

#import "LifeCostPropertyFeeListVcBottomPayInfoView.h"

@interface LifeCostPropertyFeeListVcBottomPayInfoView ()

@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UIButton *payBtn;
//

@property (nonatomic,strong) UILabel *quanXuanL;
@property (nonatomic,strong) UILabel *yingFuL;
 @end


@implementation LifeCostPropertyFeeListVcBottomPayInfoView


- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 50);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self addSubview:self.quanXuanL];
        [self addSubview:self.yingFuL];
        [self addSubview:self.chooseBtn];
        [self addSubview:self.moneyL];
        [self addSubview:self.payBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_chooseBtn.superview);
        make.width.height.offset(20);
        make.left.offset(32);
    }];
    [_quanXuanL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_quanXuanL.superview);
        make.height.offset(20);
        make.left.equalTo(_chooseBtn.mas_right).offset(5);
        make.width.offset(60);
    }];
    //
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_payBtn.superview);
        make.height.equalTo(_payBtn.superview);
        make.right.equalTo(_payBtn.superview);
        make.width.offset(120);
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_moneyL.superview);
        make.height.equalTo(_moneyL.superview).offset(-10);
        make.right.equalTo(_payBtn.mas_left).offset(-5);
    }];
    [_yingFuL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_yingFuL.superview);
        make.height.offset(20);
        make.right.equalTo(_moneyL.mas_left).offset(1);
        make.width.offset(60);
    }];
}
#pragma mark ==
- (UIButton *)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"Chooseahouse_normal"] selectedImg:[UIImage imageNamed:@"Chooseahouse_Select"]];
        [_chooseBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
//        _moneyL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyL.textColor = Y_ColorWith16FromRGB(0xFF3A3A);
        _moneyL.font = [UIFont boldSystemFontOfSize:14];
        _moneyL.numberOfLines = 0;
        _moneyL.text = @"0";
    }
    return _moneyL;
}
- (UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn newAnBtnWithTextStr:@"立即缴费"];
        //[_payBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
        [_payBtn newAnBtnWithTextColor: [UIColor whiteColor] ];
        [_payBtn newAnBtnWithBackColor:Color_38BlueColor];
        [_payBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15]];
        [_payBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}
- (UILabel *)quanXuanL{
    if (!_quanXuanL) {
        _quanXuanL = [[UILabel alloc]init];
        _quanXuanL.textColor = [ThemeManager shareManager].mainTextColor;
        _quanXuanL.font = [UIFont systemFontOfSize:14];
        _quanXuanL.textAlignment = NSTextAlignmentLeft;
        _quanXuanL.text = @"全选";
    }
    return _quanXuanL;
}
- (UILabel *)yingFuL{
    if (!_yingFuL) {
        _yingFuL = [[UILabel alloc]init];
        _yingFuL.textColor = [ThemeManager shareManager].mainTextColor;
        _yingFuL.font = [UIFont systemFontOfSize:14];
        _yingFuL.textAlignment = NSTextAlignmentRight;
        _yingFuL.text = @"应付:";
    }
    return _yingFuL;
}

#pragma mark ==
- (void)fillBottomViewAllMoney:(double)moneyD{
    _moneyL.text =  [NSString stringWithFormat:@"¥%0.2f",moneyD];
}
#pragma mark ==
- (void)chooseBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(bottomViewTouchAllChooseBtnWithSelectedBool:)]) {
        [_delegate bottomViewTouchAllChooseBtnWithSelectedBool:sender.selected];
    }
}
- (void)payBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(bottomViewTouchPayBtnWithMoneyNum:)]) {//新版的moneyL 有¥符号
        [_delegate bottomViewTouchPayBtnWithMoneyNum:[[_moneyL.text substringFromIndex:1] doubleValue]];//substringFromIndex 从Index开始截取到最后
    }
}

@end
