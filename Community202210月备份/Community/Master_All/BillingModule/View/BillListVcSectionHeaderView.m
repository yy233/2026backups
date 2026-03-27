//
//  BillListVcSectionHeaderView.m
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import "BillListVcSectionHeaderView.h"

@implementation BillListVcSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 40);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.timeL];
        [self addSubview:self.moneyL];
        [self setSubUI];
    }
    return self;
}


- (void)setSubUI{
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_timeL.superview);
        make.left.equalTo(_timeL.superview).offset(16);
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_moneyL.superview);
        make.right.equalTo(_moneyL.superview).offset(-16);
    }];
}

- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = [ThemeManager shareManager].detailTextColor;
        _timeL.font = [UIFont systemFontOfSize:15.0];
        _timeL.textAlignment = NSTextAlignmentLeft;
    }
    return _timeL;
}


- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = [ThemeManager shareManager].detailTextColor;
        _moneyL.font = [UIFont systemFontOfSize:12.0];
        _moneyL.textAlignment = NSTextAlignmentRight;
    }
    return _moneyL;
}
@end
