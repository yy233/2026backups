//
//  MoreMenuCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/24.
//

#import "MoreMenuCollectionViewCell.h"
#import "MoreMenuCollectionHeaderView.h"
@interface MoreMenuCollectionViewCell ()
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel *titleLabel;
@end
@implementation MoreMenuCollectionViewCell
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
- (void)prepareForReuse{
    [super prepareForReuse];
    _imgView.image = nil;
    _titleLabel.text = nil;
}
- (void)setModel:(MainCenterCollectionViewCellModel *)model{

    _imgView.backgroundColor = [UIColor blueColor];
    _titleLabel.text = model.menuName;
    if ([ThemeManager shareManager].type == ThemeType_White) {  //图片获取的键不一样
        [_imgView sd_setImageWithURL:[UrlWithString getURLWithStr:model.icon]];
    }else{
        [_imgView sd_setImageWithURL:[UrlWithString getURLWithStr:model.icon]]; //待改model
    }
}


- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgView.superview.mas_centerX);
        make.top.equalTo(_imgView.superview.mas_top).offset(15);
        make.width.offset(45);
        make.height.equalTo(_imgView.mas_width);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView.mas_bottom).offset(10);
        make.bottom.equalTo(_titleLabel.superview.mas_bottom).offset(-5);
        make.left.equalTo(_titleLabel.superview.mas_left);
        make.right.equalTo(_titleLabel.superview.mas_right);
    }];
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor = [ThemeManager shareManager].meueMoreContentItemBackgroundColor;
    }
    return _backView;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleLabel;
}
@end
