//
//  LifeGoodThingCellSubCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/9.
//

#import "LifeGoodThingCellSubCollectionViewCell.h"

@implementation LifeGoodThingCellSubCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleNameL];
        [self.contentView addSubview:self.imgV];
        [self setUI];
      
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.superview.mas_top).offset(5);
        make.bottom.equalTo(_titleNameL.mas_top).offset(-5);
        make.left.equalTo(_imgV.superview.mas_left);
        make.right.equalTo(_imgV.superview.mas_right);
        
    }]; 
    [_titleNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.bottom.equalTo(_titleNameL.superview.mas_bottom).offset(-5);
        make.left.equalTo(_titleNameL.superview.mas_left);
        make.right.equalTo(_titleNameL.superview.mas_right);
    }];
    
    
}
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
//        _imgV.layer.cornerRadius = 5;
//        _imgV.layer.masksToBounds = YES;
        [_imgV zy_cornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
    }
    return _imgV;
}
- (UILabel *)titleNameL{
    if (!_titleNameL) {
        _titleNameL = [[UILabel alloc]init];
        _titleNameL.font = [UIFont systemFontOfSize:12];
        _titleNameL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleNameL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleNameL;
}
@end
