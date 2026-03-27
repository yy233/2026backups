//
//  HealthSleepTotalSectionHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import "HealthSleepTotalSectionHeaderView.h"
#import "BaseHealthHeader.h"

@implementation HealthSleepTotalSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 40);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftTipView];
        [self addSubview:self.showTipLabel];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_leftTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftTipView.superview.mas_left).offset(16);
        make.width.offset(5);
        make.height.offset(10);
        make.centerY.equalTo(_leftTipView.superview);
    }];
    [_showTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftTipView.mas_right).offset(5);
        make.centerY.equalTo(_leftTipView);
        make.height.offset(20);
    }];
}
- (UIView *)leftTipView{
    if (!_leftTipView) {
        _leftTipView = [[UIView alloc]init];
        _leftTipView.backgroundColor = Color_HealthMainGreenColor;
    }
    return _leftTipView;
}
- (UILabel *)showTipLabel{
    if (!_showTipLabel) {
        _showTipLabel = [[UILabel alloc]init];
        _showTipLabel.textColor = Color_51BlackColor;
        _showTipLabel.font = [PensionThemeManager shareManager].Pension_TextFont_B15;
    }
    return _showTipLabel;
}
@end
