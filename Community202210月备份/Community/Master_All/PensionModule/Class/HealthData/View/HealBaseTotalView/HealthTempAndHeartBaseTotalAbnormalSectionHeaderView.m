//
//  HealthTempAbnormalSectionHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/11/22.
//

#import "HealthTempAndHeartBaseTotalAbnormalSectionHeaderView.h"

@implementation HealthTempAndHeartBaseTotalAbnormalSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRectMake(0, 0, Screen_W, 30);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.rightBtn];
        [self addSubview:self.titleL];
        [self addSubview:self.lineV];
        [self setUI];
    }
    return self;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
    }
    return _titleL;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"yl_xiala2"] selectedImg:[UIImage imageNamed:@"yl_shangla"]];
    }
    return _rightBtn;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
    }
    return _lineV;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleL.superview);
        make.left.equalTo(_titleL.superview).offset(16);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_rightBtn.superview);
        make.width.offset(30);
        make.right.equalTo(_rightBtn.superview).offset(-16);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_lineV.superview).offset(-32);
        make.centerX.bottom.equalTo(_lineV.superview);
        make.height.offset(1.0);
    }];
}
- (void)rightBtnAction{
    if (isNotNil(self.touchSubBtnBlcok)) {
        self.touchSubBtnBlcok();
    }
}
@end
