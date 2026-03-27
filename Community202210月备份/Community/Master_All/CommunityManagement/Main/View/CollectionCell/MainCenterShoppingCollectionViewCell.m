//
//  MainCenterShoppingCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2020/11/17.
//

#import "MainCenterShoppingCollectionViewCell.h"
#define  LookBtn_BgeinColor Y_RGBA(13, 98, 252, 1)
#define  LookBtn_EndColor   Y_RGBA(48, 189, 255, 1)
@interface MainCenterShoppingCollectionViewCell ()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailTitleLabel;
@property (nonatomic,strong)UIImageView *rightImgView;
@property (nonatomic,strong)UIImageView *centerImgView;//换成centerLookBtn
@property (nonatomic,strong)UIButton *centerLookBtn;
@end

@implementation MainCenterShoppingCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if ([ThemeManager shareManager].type == ThemeType_White) {
            self.backgroundColor = [UIColor whiteColor];
        }else{
            self.backgroundColor = Y_RGBA(17, 41, 87, 1);
        }
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        [self addSubview:self.rightImgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailTitleLabel];
        [self addSubview:self.centerImgView];
        [self addSubview:self.centerLookBtn];
        [self setUI];
    }
    return self;
}
-(void)prepareForReuse{
    [super prepareForReuse];
    _rightImgView.image = nil;
    _centerImgView.image = nil;
    _titleLabel.text = nil;
    _detailTitleLabel.text = nil;
    if ([ThemeManager shareManager].type == ThemeType_White) {
        self.backgroundColor = [UIColor whiteColor];
        _centerLookBtn.backgroundColor = Y_RGBA(27, 64, 169, 1);
        self.titleLabel.textColor = Y_RGBA(255, 0, 51, 1);
        self.detailTitleLabel.textColor = Y_RGBA(148, 151, 159, 1);
    }else{
        self.backgroundColor = Y_RGBA(17, 41, 87, 1);
        _centerLookBtn.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(55, 20) direction:IHGradientChangeDirectionLevel startColor:LookBtn_BgeinColor endColor:LookBtn_EndColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.detailTitleLabel.textColor = Y_RGBA(194, 215, 255, 1);
    }
}
-(void)setModel:(MainCenterCollectionViewShoppingCellModel *)model{
    _titleLabel.text = [TextShowWithModelStr textShowWithModelStr:model.titleStr];
    _detailTitleLabel.text = [TextShowWithModelStr textShowWithModelStr:model.detailTitleStr];
    _rightImgView.image = [UIImage imageNamed:[TextShowWithModelStr textShowWithModelStr:model.rightImgStr]];
 
}

- (void)setUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(10);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(10);
        make.right.equalTo(_titleLabel.superview.mas_right);
        make.height.offset(15);
    }];
    [_detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.height.offset(15);
    }];
    [_centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.width.offset(60);
        make.left.equalTo(_detailTitleLabel.mas_left);
        make.top.equalTo(_detailTitleLabel.mas_bottom).offset(8);
    }];
    [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(60);
        make.height.offset(50);
        make.bottom.equalTo(_rightImgView.superview.mas_bottom);
        make.right.equalTo(_rightImgView.superview.mas_right);
    }];
    [_centerLookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_detailTitleLabel.mas_left);
        make.top.equalTo(_detailTitleLabel.mas_bottom).offset(8);
        make.width.offset(55);
        make.height.offset(20);
    }];
    if ([ThemeManager shareManager].type == ThemeType_White) {
        self.backgroundColor = [UIColor whiteColor];
        _centerLookBtn.backgroundColor = Y_RGBA(27, 64, 169, 1);
        self.titleLabel.textColor = Y_RGBA(255, 0, 51, 1);
        self.detailTitleLabel.textColor = Y_RGBA(148, 151, 159, 1);
    }else{
        self.backgroundColor = Y_RGBA(17, 41, 87, 1);
        _centerLookBtn.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(55, 20) direction:IHGradientChangeDirectionLevel startColor:LookBtn_BgeinColor endColor:LookBtn_EndColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.detailTitleLabel.textColor = Y_RGBA(194, 215, 255, 1);
    }
}
- (UIImageView *)centerImgView{
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc]init];
        _centerImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerImgView;
}
- (UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc]init];
        _rightImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _rightImgView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = Y_RGBA(255, 0, 51, 1);
    }
    return _titleLabel;
}
- (UILabel *)detailTitleLabel{
    if (!_detailTitleLabel) {
        _detailTitleLabel = [[UILabel alloc]init];
        _detailTitleLabel.numberOfLines = 1;
        _detailTitleLabel.font = [UIFont systemFontOfSize:11];
        _detailTitleLabel.textAlignment = NSTextAlignmentLeft;
        _detailTitleLabel.textColor = [UIColor grayColor];
    }
    return _detailTitleLabel;
}
- (UIButton *)centerLookBtn{
    if (!_centerLookBtn) {
        _centerLookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerLookBtn setTitle:@"去看看" forState:UIControlStateNormal];
        _centerLookBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_centerLookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _centerLookBtn.layer.cornerRadius = 10;
    }
    return _centerLookBtn;
}
@end
