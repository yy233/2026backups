//
//  MainTopMenuCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/7/26.
// 主页顶部菜单collectionview_cell 新的

#import "MainTopMenuCollectionViewCell.h"
#define W_AllGap 40 //空隙 3个
#define Cell_W ((Screen_W-32) - W_AllGap )/4 // 60 (Screen_W=32)/4-10

@implementation MainTopMenuCollectionViewCell
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
//        if (model.dayIcon.length==5) {
////            _imgView.image = [UIImage imageNamed:@"More_white"];//更多item
//            _imgView.image = [UIImage imageNamed:@"Main_more"];
//        }else
        if (model.dayIcon.length < model.nightIcon.length){//浅色模式下 icon无图的时候 用深色模式的图片
            [_imgView sd_setImageWithURL:[UrlWithString getURLWithStr:model.nightIcon]];
        }else if(model.dayIcon.length==0  && model.nightIcon.length == 0){//图片都没数据的时候
                _imgView.image = [UIImage imageNamed:@"Main_more"];
        }else{//dayIcon有数据的情况
            [_imgView sd_setImageWithURL:[UrlWithString getURLWithStr:model.dayIcon]];
        }
         
    }else{
        if (model.nightIcon.length<5) {
//            _imgView.image = [UIImage imageNamed:@"More_night"];//更多item
            _imgView.image = [UIImage imageNamed:@"Main_more"];
        }else{
            [_imgView sd_setImageWithURL:[UrlWithString getURLWithStr:model.nightIcon]];
        }
    }
    _titleLabel.text = model.menuName;
}


- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgView.superview.mas_centerX);
        make.top.equalTo(_imgView.superview.mas_top).offset(10);
//        make.width.offset(45);//5个/行时使用
        make.width.offset(45);//4个每行时使用
        make.height.equalTo(_imgView.mas_width);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView.mas_bottom).offset(0);
        make.bottom.equalTo(_titleLabel.superview.mas_bottom).offset(0);
        make.left.equalTo(_titleLabel.superview.mas_left);
        make.right.equalTo(_titleLabel.superview.mas_right);
    }];
 
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
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
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleLabel;
}
@end
