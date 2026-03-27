//
//  EIntergralMallMingXiListHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/2/23.
//

#import "EIntergralMallMingXiListHeaderView.h"
#define  Color_NavBack          Y_ColorWith16FromRGB(0x25283B)
@implementation EIntergralMallMingXiListHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 80);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color_NavBack;
        [self addSubview:self.eNumL];
        [self addSubview:self.bottomL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_eNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_eNumL.superview);
        make.height.offset(40);
    }];
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_eNumL);
        make.top.equalTo(_eNumL.mas_bottom);
    }];
}
- (UILabel *)eNumL{
    if (!_eNumL) {
        _eNumL = [[UILabel alloc]init];
        _eNumL.textColor = [UIColor whiteColor];
        _eNumL.font = FontSize_MoneyWallet_Bold(33);
        _eNumL.textAlignment = NSTextAlignmentCenter;
    }
    return _eNumL;
}
- (UILabel *)bottomL{
    if (!_bottomL) {
        _bottomL = [[UILabel alloc]init];
        _bottomL.textColor = [UIColor whiteColor];
        _bottomL.font = FontSize_MoneyWallet_Nomail(12);
        _bottomL.textAlignment = NSTextAlignmentCenter;
        _bottomL.text = @"E币";
    }
    return _bottomL;
}
@end
