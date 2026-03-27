//
//  EIntergralMallGoodsDatailVcFooterView.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "EIntergralMallGoodsDatailVcFooterView.h"

@implementation EIntergralMallGoodsDatailVcFooterView
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 50);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lineView];
        [self addSubview:self.okBtn];
        [self addSubview:self.allL];
        [self addSubview:self.eNumL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.superview).offset(0);
        make.left.right.equalTo(_lineView.superview);
        make.height.offset(1);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_okBtn.superview);
        make.width.offset(100);
    }];
    [_allL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_okBtn.mas_top);
        make.height.offset(20);
        make.right.equalTo(_okBtn.mas_left).offset(-10);
    }];
    [_eNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_okBtn.mas_bottom);
        make.height.offset(30);
        make.right.equalTo(_okBtn.mas_left).offset(-10);
    }];
    
}
#pragma mark ==
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = Color_238GrayColor;
    }
    return _lineView;
}
- (UILabel *)allL{
    if (!_allL) {
        _allL = [[UILabel alloc]init];
        _allL.text = @"合计";
        _allL.textColor = Color_138GrayColor;
        _allL.font = FontSize_MoneyWallet_Nomail(12);
        _allL.textAlignment = NSTextAlignmentRight;
    }
    return _allL;
}
- (UILabel *)eNumL{
    if (!_eNumL) {
        _eNumL = [[UILabel alloc]init];
        _eNumL.font = FontSize_MoneyWallet_Nomail(14);
        _eNumL.textAlignment = NSTextAlignmentRight;
    }
    return _eNumL;
}
- (UIButton *)okBtn{
    if (!_okBtn ) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(14)];
        [_okBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_okBtn newAnBtnWithTextStr:@"确认兑换"];
        [_okBtn newAnBtnWithBackColor:COlor_Red255];
    }
    return _okBtn;
}

@end
