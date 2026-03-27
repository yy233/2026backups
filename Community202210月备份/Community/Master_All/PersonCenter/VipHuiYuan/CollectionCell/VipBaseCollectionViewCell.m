//
//  VipHeaderViewSubCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "VipBaseCollectionViewCell.h"
 


@implementation VipBaseCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.backV];
        [self.backV addSubview:self.imgV];
        [self.backV addSubview:self.titleL];
        [self.backV addSubview:self.centerL];
        [self.backV addSubview:self.bottomL];
        [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_backV.superview);
        }];
        //
//        [self setBaseUI];
//        [self setBaseHaveImgUI];
    }
    return self;
}
- (void)setBaseLabelUI{
  
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_titleL.superview);
        make.height.offset(30);
    }];
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_titleL.superview);
        make.height.offset(30);
    }];
    [_centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL.superview);
        make.top.equalTo(_titleL.mas_bottom);
        make.bottom.equalTo(_bottomL.mas_top);
    }];
    
   
}
- (void)setBaseHaveImgUI{
   //
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.superview.mas_top).offset(12);;
        make.centerX.equalTo(_imgV.superview.mas_centerX);
        make.width.offset(60);
        make.height.equalTo(_imgV.mas_width);
    }];
    //
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.mas_bottom);
        make.left.right.equalTo(_titleL.superview);
        make.height.offset(30);
    }];
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_titleL.superview);
        make.height.offset(20);
    }];
    [_centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL.superview);
        make.top.equalTo(_titleL.mas_bottom);
        make.bottom.equalTo(_bottomL.mas_top);
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
        _backV.backgroundColor = [UIColor whiteColor];
        _backV.layer.cornerRadius = 7.5;
        _backV.layer.masksToBounds = YES;
    }
    return _backV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.textColor = Color_brown114;
        _titleL.font =  FontSize_Vip_Bold(12);
    }
    return _titleL;
}

- (UILabel *)centerL{
    if (!_centerL) {
        _centerL = [[UILabel alloc]init];
        
        _centerL.textAlignment = NSTextAlignmentCenter;
        _centerL.textColor = COlor_Red255;
        _centerL.font =  FontSize_Vip_Bold(25);
    }
    return _centerL;
}
 
- (UILabel *)bottomL{
    if (!_bottomL) {
        _bottomL = [[UILabel alloc]init];
        _bottomL.textAlignment = NSTextAlignmentCenter;
        _bottomL.textColor = Color_brown192;
        _bottomL.font =  FontSize_Vip_Nomail(11);
        
    }
    return _bottomL;
}
//
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}
@end
