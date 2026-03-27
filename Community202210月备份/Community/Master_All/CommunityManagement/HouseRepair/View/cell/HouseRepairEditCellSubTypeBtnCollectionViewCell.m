//
//  HouseRepairEditCellSubTypeBtnCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import "HouseRepairEditCellSubTypeBtnCollectionViewCell.h"

@implementation HouseRepairEditCellSubTypeBtnCollectionViewCell

//- (void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//    if (selected) {
//        [self nowSelectedType:selected];
//    }else{
//        [self nowSelectedType:selected];
//    }
//}

- (void)nowSelectedType:(BOOL)isSelectedType{
    if (isSelectedType) {
        self.isSelectedShowView.hidden = NO;
        self.rightBottomImg.hidden = NO;
    }else{
        self.isSelectedShowView.hidden = YES;
        self.rightBottomImg.hidden = YES;
    }
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.isSelectedShowView];
        [self.isSelectedShowView addSubview:self.rightBottomImg];
        [self.contentView addSubview:self.titleLabel];
        [self setUI];
        self.selected = NO;
    }
    return self;
}

- (void)setUI{
    _rightBottomImg.backgroundColor = [UIColor cyanColor];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_titleLabel.superview);
    }];
    [_isSelectedShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_isSelectedShowView.superview);
    }];
    [_rightBottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_rightBottomImg.superview.mas_bottom);
        make.right.equalTo(_rightBottomImg.superview.mas_right);
        make.width.offset(15);
        make.height.equalTo(_rightBottomImg.mas_width);
    }];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _titleLabel.layer.cornerRadius = 2;
        _titleLabel.layer.borderWidth = 0.5;
        _titleLabel.layer.borderColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5].CGColor;
    }
    return _titleLabel;
}

- (UIView *)isSelectedShowView{
    if (!_isSelectedShowView) {
        _isSelectedShowView = [[UIView alloc]init];
        _isSelectedShowView.layer.cornerRadius = 2;
        _isSelectedShowView.layer.masksToBounds = YES;
        _isSelectedShowView.backgroundColor = Y_RGBA(38, 114, 249, 1);
    }
    return _isSelectedShowView;
}
- (UIImageView *)rightBottomImg{
    if (!_rightBottomImg) {
        _rightBottomImg = [[UIImageView alloc]init];
    }
    return _rightBottomImg;
}
@end
