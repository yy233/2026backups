//
//  MainCenterCollectionViewCell.m
//  Community
// 主页顶部菜单
//  Created by 余莹 on 2020/11/16.
// 主页顶部菜单collectionview_cell 旧的 暂不使用

#import "MainCenterCollectionViewCell.h"

@interface MainCenterCollectionViewCell ()

@end
@implementation MainCenterCollectionViewCell
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
-(void)prepareForReuse{
    [super prepareForReuse];
   
    _imgView.image = nil;
    _titleLabel.text = nil;
}
-(void)setModel:(MainCenterCollectionViewCellModel *)model{
    if([ThemeManager shareManager].type == ThemeType_White){
        if (model.dayIcon.length<5) {
            _imgView.image = [UIImage imageNamed:@"More_white"];//更多item
        }else{
            [_imgView sd_setImageWithURL:[UrlWithString getURLWithStr:model.dayIcon]];
        }
    }else{
        if (model.nightIcon.length<5) {
            _imgView.image = [UIImage imageNamed:@"More_night"];//更多item
        }else{
            [_imgView sd_setImageWithURL:[UrlWithString getURLWithStr:model.nightIcon]];
        }
    }
    //
    _titleLabel.text = model.menuName;
}


- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgView.superview.mas_centerX);
        make.top.equalTo(_imgView.superview.mas_top).offset(15);
        make.width.offset(50);
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
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleLabel;
}
@end
