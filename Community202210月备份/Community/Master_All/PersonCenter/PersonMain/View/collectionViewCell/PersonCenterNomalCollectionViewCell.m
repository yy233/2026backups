//
//  PersonCenterNomalCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/18.
//

#import "PersonCenterNomalCollectionViewCell.h"

@implementation PersonCenterNomalCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.topImgV];
        [self.contentView addSubview:self.bottomTextLabel];
        [self setUI];
    }
    return self;
}

- (void)setUI{
//    _topImgV.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    [_topImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_topImgV.superview).insets(UIEdgeInsetsMake(0, 0, 20, 0));
    }];
    [_bottomTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topImgV.mas_bottom).offset(0);
        make.height.offset(20);
        make.left.equalTo(_bottomTextLabel.superview.mas_left);
        make.right.equalTo(_bottomTextLabel.superview.mas_right);
    }];
    
}
#pragma mark ==

-  (UIImageView *)topImgV{
    if (!_topImgV ) {
        _topImgV = [[UIImageView alloc]init];
//        _topImgV.contentMode = UIViewContentModeScaleAspectFit;
        _topImgV.contentMode = UIViewContentModeCenter;
    }
    return _topImgV;
}

- (UILabel *)bottomTextLabel{
    if (!_bottomTextLabel) {
        _bottomTextLabel = [[UILabel alloc]init];
        _bottomTextLabel.font = [UIFont systemFontOfSize:12];
        _bottomTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    _bottomTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
    return _bottomTextLabel;
}
@end
