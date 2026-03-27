//
//  BillListVcTopView.m
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import "BillListVcTopView.h"

@implementation BillListVcTopView
 
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 60);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.typeBtn];
        [self addSubview:self.timeBtn];
        [self setSubUI];
    }
    return self;
}

- (void)setSubUI{
    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_typeBtn.superview).multipliedBy(0.5);
        make.width.offset(120);
        make.height.offset(30);
        make.centerY.equalTo(_typeBtn.superview);
    }];
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timeBtn.superview).multipliedBy(1.5);
        make.width.offset(120);
        make.height.offset(30);
        make.centerY.equalTo(_typeBtn.superview);
    }];
}
#pragma mark ==


- (UIButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeBtn newAnBtnWithImg:[UIImage imageNamed:@"hr_xiala_icon"]];
        [_typeBtn newAnBtnWithFont:[UIFont systemFontOfSize:14.0]];
        [_typeBtn newAnBtnWithTextStr:@"全部类型"];
        [_typeBtn newAnBtnWithTextColor:[ThemeManager shareManager].detailTextColor];
        [_typeBtn newAnBtnWithLayerCorNerNum:3.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_typeBtn newAnBtnWithBackColor:[ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW];
    }
    return _typeBtn;
}
- (UIButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeBtn newAnBtnWithImg:[UIImage imageNamed:@"hr_xiala_icon"]];
        [_timeBtn newAnBtnWithFont:[UIFont systemFontOfSize:14.0]];
        [_timeBtn newAnBtnWithTextStr:@"全部时间"];
        [_timeBtn newAnBtnWithTextColor:[ThemeManager shareManager].detailTextColor];
        [_timeBtn newAnBtnWithLayerCorNerNum:3.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_timeBtn newAnBtnWithBackColor:[ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW];
    }
    return _timeBtn;
}
@end
