//
//  UserCertificationCellSectionFooterView.m
//  Community
//
//  Created by 余莹 on 2020/12/15.
//

#import "UserCertificationCellSectionFooterView.h"

@implementation UserCertificationCellSectionFooterView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sectionFooterViewBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_sectionFooterViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_sectionFooterViewBtn.superview).insets(UIEdgeInsetsMake(0, 26, 15, 26));
    }];
}
- (UIButton *)sectionFooterViewBtn{
    if (!_sectionFooterViewBtn) {
        _sectionFooterViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sectionFooterViewBtn.frame = CGRectMake(26, 0, Screen_W-52, 50);
        _sectionFooterViewBtn.backgroundColor = [[ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor colorWithAlphaComponent:0.8];
        _sectionFooterViewBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _sectionFooterViewBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_sectionFooterViewBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];//mainTexDetailLightBluetColor
    }
    return _sectionFooterViewBtn;
}
@end
