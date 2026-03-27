//
//  ImExOrderMainVcSubCollectionViewCell.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import "ImExOrderMainVcSubCollectionViewCell.h"

@implementation ImExOrderMainVcSubCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.imgView];
        [self.backView addSubview:self.titleLabel];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel.superview);
        make.centerY.equalTo(_titleLabel.superview);
        make.height.offset(50);
    }];
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake(200, 200)
                                                                  direction:IHGradientChangeDirectionVertical
                                                                 startColor:CC_Red_Drak_A
                                                                   endColor:CC_Brown_C];
        }
    return _backView;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}
@end
