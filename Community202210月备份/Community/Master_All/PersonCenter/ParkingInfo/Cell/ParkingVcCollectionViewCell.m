//
//  ParkingVcCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/6.
//

#import "ParkingVcCollectionViewCell.h"

@implementation ParkingVcCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.backV];
        [self.backV addSubview:self.imgV];
        [self.backV addSubview:self.titleL];
        [self setNomalUI];
    }
    return self;
}
- (void)setNomalUI{
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backV.superview);
    }];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV.superview).offset(-12);;
        make.centerX.equalTo(_imgV.superview.mas_centerX);
        make.height.equalTo(_imgV.superview).multipliedBy(0.5);
        make.width.equalTo(_imgV.mas_height);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL.superview);
        make.height.offset(20);
        make.top.equalTo(_imgV.mas_bottom).offset(5);
    }];
}
 
 
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
        _backV.layer.cornerRadius = 20;
        _backV.layer.masksToBounds = YES;
    }
    _backV.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    return _backV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:14];
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    _titleL.textColor = [ThemeManager shareManager].themeTextMainColor;
    return _titleL;
}
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}
@end
