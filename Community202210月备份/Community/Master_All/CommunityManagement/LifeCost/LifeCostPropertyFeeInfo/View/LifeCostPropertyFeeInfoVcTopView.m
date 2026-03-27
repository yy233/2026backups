//
//  LifeCostPropertyFeeInfoVcTopView.m
//  Community
//
//  Created by 余莹 on 2021/7/6.
//

#import "LifeCostPropertyFeeInfoVcTopView.h"

@implementation LifeCostPropertyFeeInfoVcTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftImgV];
        [self addSubview:self.addressLabel];
        [self addSubview:self.timeLabel];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [_leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.left.equalTo(_leftImgV.superview).offset(16);
        make.centerY.equalTo(_leftImgV.superview);
    }];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImgV.mas_right).offset(7);
        make.centerY.equalTo(_addressLabel.superview);
        make.height.offset(30);
        make.width.equalTo(_addressLabel.superview).multipliedBy(0.55);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_timeLabel.superview).offset(-16);
        make.centerY.equalTo(_timeLabel.superview);
        make.height.offset(30);
        make.width.equalTo(_timeLabel.superview).multipliedBy(0.4);
    }];

}

#pragma mark ==
- (UIImageView *)leftImgV{
    if (!_leftImgV) {
        _leftImgV = [[UIImageView alloc]init];
        _leftImgV.contentMode = UIViewContentModeScaleAspectFit;
        _leftImgV.image = [UIImage imageNamed:@"details_location"];
    }
    return _leftImgV;
}
- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}
@end
