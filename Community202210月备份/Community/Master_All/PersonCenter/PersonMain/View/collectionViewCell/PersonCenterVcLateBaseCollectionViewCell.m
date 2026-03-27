//
//  PersonCenterVcLateBaseCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/7/27.
//

#import "PersonCenterVcLateBaseCollectionViewCell.h"

#define BaseCollectionViewCell_W   ((Screen_W -32 -40)/4)


@implementation PersonCenterVcLateBaseCollectionViewCell
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
     [_topImgV mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.height.offset(BaseCollectionViewCell_W-10);
         make.centerX.top.equalTo(_topImgV.superview);
    }];
    [_bottomTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topImgV.mas_bottom).offset(0);
        make.height.offset(20);
        make.left.equalTo(_bottomTextLabel.superview.mas_left);
        make.right.equalTo(_bottomTextLabel.superview.mas_right);
    }];
    //无效的圆角
//     float cornerR = ((BaseCollectionViewCell_W-10)/2);
//     [_topImgV zy_cornerRadiusAdvance:cornerR rectCornerType:UIRectCornerAllCorners];
}
#pragma mark ==

-  (UIImageView *)topImgV{
    if (!_topImgV ) {
        _topImgV = [[UIImageView alloc]init];
//        _topImgV.contentMode = UIViewContentModeScaleAspectFit;
        _topImgV.contentMode = UIViewContentModeCenter;
//        _topImgV.backgroundColor = Color_245Gray;

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
