//
//  DiscoverMainCollectionViewCell.m
//  Socialize
//
//  Created by 余莹 on 2023/5/12.
//

#import "ZhiBoMainListSubCollectionViewCell.h"

#define  textLabel_w  ( (Screen_W-32-20)*0.4 )
@implementation ZhiBoMainListSubCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.imgView];
        [self.backView addSubview:self.typeImg];
        [self.backView addSubview:self.typeLabel];
        [self.backView addSubview:self.textBkv];
        [self.backView addSubview:self.topRightVOiceOrLiveTypeLabel];
        [self.backView addSubview:self.topRightPubOrPivTypeLabel];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.subtitleLabel_S];
        [self.backView addSubview:self.numLabel];
        [self.backView addSubview:self.dealLineTimeLabel];
        [self setUI];
       
    }
    return self;
}

//- (void)displayLayer:(CALayer *)layer{
//
//}

- (void)dealloc{
    _titleLabel.text = @"";
    _subtitleLabel_S.text = @"";
    NSLog(@" dealloc 当前ZhiBoMainListSubCollectionViewCell ");
}
-(void)prepareForReuse{
    [super prepareForReuse];
    _imgView.image = nil;
    _typeImg.image = nil;
    _titleLabel.text = @"";
    _subtitleLabel_S.text = @"";
    NSLog(@" prepareForReuse 当前ZhiBoMainListSubCollectionViewCell离开显示框");
}

//-(void)setModel:(MainCenterCollectionViewCellModel *)model{
//    if([ThemeManager shareManager].type == ThemeType_White){
//        if (model.dayIcon.length<5) {
//            _imgView.image = [UIImage imageNamed:@"More_white"];//更多item
//        }else{
//            [_imgView sd_setImageWithURL:[UrlWithString getURLWithStr:model.dayIcon]];
//        }
//    }else{
//        if (model.nightIcon.length<5) {
//            _imgView.image = [UIImage imageNamed:@"More_night"];//更多item
//        }else{
//            [_imgView sd_setImageWithURL:[UrlWithString getURLWithStr:model.nightIcon]];
//        }
//    }
//    //
//    _titleLabel.text = model.menuName;
//}

-(void)layoutSubviews{
    [super layoutSubviews];
}
- (void)setUI{
    CGFloat typeShow_W = 100;
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView);
    }];
    [_typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_typeImg.superview).offset(-10);
//        make.width.offset(60+10);
        make.width.offset(typeShow_W+10);
        make.height.offset(30+10);
        //(10, 10, 0, 10));//扩张一部分 防止展示顶部和左下圆角
    }];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_typeLabel.superview);
//        make.width.offset(60);
        make.width.offset(typeShow_W);
        make.height.offset(30);
    }];

 
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_numLabel.superview.mas_bottom).offset(-5);
        make.right.equalTo(_numLabel.superview.mas_right).offset(-10);
        make.width.equalTo(_numLabel.superview).multipliedBy(0.4);
    }];
    [_dealLineTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_numLabel.mas_top).offset(-5);
        make.right.width.equalTo(_numLabel);
        make.height.offset(20);
         
    }];
    
    [_subtitleLabel_S mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.bottom.equalTo(_numLabel);
        make.left.equalTo(_subtitleLabel_S.superview.mas_left).offset(10);
        make.width.offset(textLabel_w);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_subtitleLabel_S.mas_top).offset(0);
        make.left.height.equalTo(_subtitleLabel_S);
        //make.width.equalTo(_titleLabel.superview).multipliedBy(0.4);
        make.width.offset(textLabel_w);
    }];
    
    [_textBkv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_textBkv.superview);
        make.top.equalTo(_titleLabel).offset(-5);
    }];
    
    [_topRightVOiceOrLiveTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_numLabel);
        make.height.offset(22.0);
        make.top.equalTo(_topRightVOiceOrLiveTypeLabel.superview).offset(10);
        make.width.offset(50);
    }];
    [_topRightPubOrPivTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topRightVOiceOrLiveTypeLabel.mas_left).offset(-15);
        make.height.offset(22.0);
        make.top.equalTo(_topRightVOiceOrLiveTypeLabel.superview).offset(10);
        make.width.offset(50);
    }];
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor  = [UIColor lightGrayColor];
//        _backView.backgroundColor = [ThemeManager shareManager].meueMoreContentItemBackgroundColor;
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

- (UIImageView *)typeImg{
    if(!_typeImg){
        _typeImg = [[UIImageView alloc]init];
        _typeImg.layer.cornerRadius = 6;
        _typeImg.layer.masksToBounds = YES;
        _typeImg.backgroundColor = [UIColor orangeColor];
        
    }
    return _typeImg;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.numberOfLines = 2;
        _typeLabel.font = [UIFont systemFontOfSize:11];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.textColor = [UIColor whiteColor];
     }
    return _typeLabel;
}

- (UILabel *)topRightVOiceOrLiveTypeLabel{
    if(!_topRightVOiceOrLiveTypeLabel){
        _topRightVOiceOrLiveTypeLabel = [[UILabel alloc]init];
        _topRightVOiceOrLiveTypeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _topRightVOiceOrLiveTypeLabel.layer.cornerRadius = 10;
        _topRightVOiceOrLiveTypeLabel.layer.masksToBounds = YES;
        _topRightVOiceOrLiveTypeLabel.textColor = [UIColor whiteColor];
        _topRightVOiceOrLiveTypeLabel.font = [UIFont systemFontOfSize:13.0];
        _topRightVOiceOrLiveTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topRightVOiceOrLiveTypeLabel;
}
- (UILabel *)topRightPubOrPivTypeLabel{
    if(!_topRightPubOrPivTypeLabel){
        _topRightPubOrPivTypeLabel = [[UILabel alloc]init];
        _topRightPubOrPivTypeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _topRightPubOrPivTypeLabel.layer.cornerRadius = 10;
        _topRightPubOrPivTypeLabel.layer.masksToBounds = YES;
        _topRightPubOrPivTypeLabel.textColor = [UIColor whiteColor];
        _topRightPubOrPivTypeLabel.font = [UIFont systemFontOfSize:13.0];
        _topRightPubOrPivTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topRightPubOrPivTypeLabel;
    
}
- (UIView *)textBkv{
    if(!_textBkv){
        _textBkv = [[UIView alloc]init];
        _textBkv.backgroundColor = [Color_153GrayColor colorWithAlphaComponent:0.5];
        _textBkv.layer.masksToBounds = YES;
    }
    return _textBkv;
}


//- (STScrollBar *)titleLabel{
//    if (!_titleLabel) {
//        CGRect textf = CGRectMake(0, 0, textLabel_w, 20);
//        _titleLabel = [[STScrollBar alloc]initWithFrame:textf];
//        _titleLabel.colorText = [UIColor whiteColor];
//        _titleLabel.font = [UIFont systemFontOfSize:12];
//    }
//
//    return _titleLabel;
//}
//
//- (STScrollBar *)subtitleLabel{
//    if(!_subtitleLabel){
//        CGRect textf = CGRectMake(0, 0, textLabel_w, 20);
//        _subtitleLabel = [[STScrollBar alloc]initWithFrame:textf];
//        _subtitleLabel.colorText = [UIColor whiteColor];
//        _subtitleLabel.font = [UIFont systemFontOfSize:14];
//    }
//    return _subtitleLabel;
//
//}
- (KJMarqueeLabel *)titleLabel{
    if (!_titleLabel) {
        CGRect textf = CGRectMake(0, 0, textLabel_w, 20);
        _titleLabel = [[KJMarqueeLabel alloc]initWithFrame:textf];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.marqueeLabelType = KJMarqueeLabelTypeLeft;
    }
    return _titleLabel;
}
- (KJMarqueeLabel *)subtitleLabel_S{
    if(!_subtitleLabel_S){
        CGRect textf = CGRectMake(0, 0, textLabel_w, 20);
        _subtitleLabel_S = [[KJMarqueeLabel alloc]initWithFrame:textf];
        _subtitleLabel_S.textColor = [UIColor whiteColor];
        _subtitleLabel_S.font = [UIFont systemFontOfSize:14];
        _subtitleLabel_S.marqueeLabelType = KJMarqueeLabelTypeLeft;
    }
    return _subtitleLabel_S;
}

-(UILabel *)numLabel{
    if(!_numLabel){
        _numLabel = [[UILabel alloc]init];
        _numLabel.numberOfLines = 2;
        _numLabel.font = [UIFont systemFontOfSize:13.0];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.textColor = [UIColor whiteColor];
//        _numLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _numLabel;
}
    
- (UILabel *)dealLineTimeLabel{
    if(!_dealLineTimeLabel){
        _dealLineTimeLabel = [[UILabel alloc]init];
        _dealLineTimeLabel.numberOfLines = 1;
        _dealLineTimeLabel.font = [UIFont systemFontOfSize:13.0];
        _dealLineTimeLabel.textAlignment = NSTextAlignmentRight;
        _dealLineTimeLabel.textColor = [UIColor whiteColor];
//        _numLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _dealLineTimeLabel;
}
    

   
@end

