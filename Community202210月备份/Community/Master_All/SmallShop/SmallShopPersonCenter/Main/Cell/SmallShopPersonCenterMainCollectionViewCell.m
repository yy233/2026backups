//
//  SmallShopPersonCenterMainCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2022/2/28.
//

#import "SmallShopPersonCenterMainCollectionViewCell.h"

@implementation SmallShopPersonCenterMainCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
 
        [self.backView addSubview:self.redNumL];
        WEAKSELF
        [_redNumL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.imgView.mas_top);
            make.centerX.equalTo(weakSelf.imgView).offset(16);
            make.height.offset(12.0);
            make.width.greaterThanOrEqualTo(_redNumL.mas_height);//最小宽度。
        }];
    }
    return self;
}
- (UILabel *)redNumL{
    if (!_redNumL) {
        _redNumL = [[UILabel alloc]init];
        _redNumL.numberOfLines = 1;
        _redNumL.font = [UIFont systemFontOfSize:9.0];
        _redNumL.textAlignment = NSTextAlignmentCenter;
        _redNumL.textColor = Y_ColorWith16FromRGB(0xffffff);
        _redNumL.backgroundColor = Y_ColorWith16FromRGB(0xEE5656);
        _redNumL.layer.cornerRadius = 6.0;
        _redNumL.clipsToBounds = YES;
    }
    return _redNumL;
}
@end
 
