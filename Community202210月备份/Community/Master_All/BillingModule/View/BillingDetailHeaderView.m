//
//  BillingDetailHeaderView.m
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import "BillingDetailHeaderView.h"


@implementation BillingDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 170);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgV];
        [self addSubview:self.typeL];
        [self addSubview:self.moneyL];
        [self setSubUI];
    }
    return self;
}
- (void)setSubUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(70);
        make.centerX.equalTo(_imgV.superview);
        make.top.equalTo(_imgV.superview).offset(15);
    }];
    
    [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.centerX.equalTo(_typeL.superview);
        make.top.equalTo(_imgV.mas_bottom).offset(5);
    }];
    
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.centerX.equalTo(_moneyL.superview);
        make.top.equalTo(_typeL.mas_bottom).offset(5);
    }];
}

#pragma mark ==
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}

- (UILabel *)typeL{
    if (!_typeL) {
        _typeL = [[UILabel alloc]init];
        _typeL.textColor = [ThemeManager shareManager].mainTextColor;
        _typeL.font = [UIFont systemFontOfSize:15.0];
        _typeL.textAlignment = NSTextAlignmentCenter;
    }
    return _typeL;
}
 
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyL.font = [UIFont boldSystemFontOfSize:36.0];
        _moneyL.textAlignment = NSTextAlignmentCenter;

    }
    return _moneyL;
}

@end
