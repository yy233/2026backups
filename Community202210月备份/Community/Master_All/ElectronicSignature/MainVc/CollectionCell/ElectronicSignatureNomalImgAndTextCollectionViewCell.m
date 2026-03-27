//
//  ElectronicSignatureNomalImgAndTextSearchView.m
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import "ElectronicSignatureNomalImgAndTextCollectionViewCell.h"

@implementation ElectronicSignatureNomalImgAndTextCollectionViewCell
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
        make.centerX.equalTo(_imgV.superview.mas_centerX);
        make.centerY.equalTo(_imgV.superview.mas_centerY).offset(-12);
        make.width.equalTo(_imgV.superview).multipliedBy(0.75);
        make.height.equalTo(_imgV.superview).multipliedBy(0.45);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL.superview);
        make.height.offset(20);
        make.top.equalTo(_imgV.mas_bottom);
    }];
}
 
- (void)setCellNewUIWithTitleAndImgHaveJianJu{
    _imgV.contentMode = UIViewContentModeCenter;
    [_titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.mas_bottom).offset(10);
    }];
}
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
        _backV.layer.cornerRadius = 5;
        _backV.layer.masksToBounds = YES;
    }
    return _backV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [UIColor whiteColor];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
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
