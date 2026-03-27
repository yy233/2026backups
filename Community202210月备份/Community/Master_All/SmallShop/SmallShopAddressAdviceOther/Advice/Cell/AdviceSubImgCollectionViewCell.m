//
//  AdviceSubImgCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/3.
//

#import "AdviceSubImgCollectionViewCell.h"

@implementation AdviceSubImgCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.bottomL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bottomL.superview);
        make.height.offset(20);
        make.bottom.equalTo(_bottomL.superview).offset(-10);
    }];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV.superview).offset(-10);
        make.centerX.equalTo(_imgV.superview);
        make.width.height.offset(60);
    }];
}
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleToFill;
    }
    return _imgV;
}
- (UILabel *)bottomL{
    if (!_bottomL) {
        _bottomL = [[UILabel alloc]init];
        _bottomL.textColor = Y_ColorWith16FromRGB(0xAAAEB9 );
        _bottomL.font = [UIFont systemFontOfSize:12.0];
        _bottomL.text = @"上传图片";
        _bottomL.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomL;
}

@end
