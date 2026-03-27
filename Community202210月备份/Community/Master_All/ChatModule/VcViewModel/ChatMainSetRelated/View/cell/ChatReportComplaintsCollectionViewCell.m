//
//  ChatReportComplaintsCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "ChatReportComplaintsCollectionViewCell.h"

@interface ChatReportComplaintsCollectionViewCell ()
@end

@implementation ChatReportComplaintsCollectionViewCell
- (void)fillSubCellWithTitleStr:(NSString *)titleStr withImgNameStr:(NSString *)imgNameStr{
    self.imgV.image = [UIImage imageNamed:imgNameStr];
    self.titleL.text = titleStr;
}
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
        make.top.equalTo(_imgV.superview.mas_top).offset(12);;
        make.centerX.equalTo(_imgV.superview.mas_centerX);
        make.width.equalTo(_imgV.superview).multipliedBy(0.8);
        make.height.equalTo(_imgV.superview).multipliedBy(0.5);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL.superview);
        make.height.offset(20);
        make.top.equalTo(_imgV.mas_bottom).offset(5);
    }];
}
 
//- (void)setCellNewUIWithTitleAndImgHaveJianJu{
//    _imgV.contentMode = UIViewContentModeCenter;
//    [_titleL mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_imgV.mas_bottom).offset(10);
//    }];
//}
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
        _titleL.textColor = [Y_ColorWith16FromRGB(0x333333) colorWithAlphaComponent:0.7];
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
