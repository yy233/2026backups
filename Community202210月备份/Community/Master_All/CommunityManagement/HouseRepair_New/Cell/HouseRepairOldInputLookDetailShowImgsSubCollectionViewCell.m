//
//  HouseRepairOldInputLookDetailShowImgsSubCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/7.
//

#import "HouseRepairOldInputLookDetailShowImgsSubCollectionViewCell.h"

@implementation HouseRepairOldInputLookDetailShowImgsSubCollectionViewCell
 
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgV];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_imgV.superview);
        make.width.offset(80);
        make.height.equalTo(_imgV.mas_width);
    }];
}
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.clipsToBounds = YES;
    }
    return _imgV;
}
@end
