//
//  YuEMingXiDetailHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "YuEMingXiDetailHeaderView.h"

@implementation YuEMingXiDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 150);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.moneyL];
        [self addSubview:self.bottomL];
        [self addSubview:self.lineView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_moneyL.superview);
        make.height.offset(30);
    }];
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_moneyL.superview);
        make.top.equalTo(_moneyL.mas_bottom);
        make.height.offset(30);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_lineView.superview);
        make.left.equalTo(_lineView.superview).offset(16);
        make.right.equalTo(_lineView.superview).offset(-16);
        make.height.offset(1);
    }];
    
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textAlignment = NSTextAlignmentCenter;
        _moneyL.font = FontSize_MoneyWallet_Bold(36);
    }
    _moneyL.textColor = [ThemeManager shareManager].mainTextColor;
    return _moneyL;
}
- (UILabel *)bottomL{
    if (!_bottomL) {
        _bottomL = [[UILabel alloc]init];
        _bottomL.textAlignment = NSTextAlignmentCenter;
        _bottomL.font = FontSize_MoneyWallet_Nomail(12);
        _bottomL.textColor = [UIColor blackColor];
    }
    _bottomL.textColor = [ThemeManager shareManager].mainTextColor;
    return _bottomL;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [ThemeManager shareManager].themeLineColor;//Color_245Gray;
    }
    return _lineView;
}
@end
