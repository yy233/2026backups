//
//  BaseImgAndLabelCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2022/2/28.
//

#import "BaseImgAndLabelCollectionViewCell.h"

@implementation BaseImgAndLabelCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.imgView];
        [self.backView addSubview:self.titleLabel];
        [self setBaseUI];
    }
    return self;
}
-(void)prepareForReuse{
    [super prepareForReuse];
   
    _imgView.image = nil;
    _titleLabel.text = nil;
}

- (void)setBaseUI{//allh=100
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f));
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgView.superview);
        make.top.equalTo(_imgView.superview.mas_top).offset(20);
        make.width.offset(35);
        make.height.equalTo(_imgView.mas_width);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_titleLabel.superview.mas_bottom).offset(-20);
        make.height.offset(20);
        //make.left.right.equalTo(_titleLabel.superview);有限宽
        make.centerX.equalTo(_titleLabel.superview);
        make.width.equalTo(_titleLabel.superview).offset(0);//可占满间距0
    }];
 
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.clipsToBounds = YES;
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
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = Y_ColorWith16FromRGB(0x6E727D);
    }
    return _titleLabel;
}

@end
