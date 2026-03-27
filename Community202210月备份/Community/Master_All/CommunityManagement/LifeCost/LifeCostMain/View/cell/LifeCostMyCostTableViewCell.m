//
//  LifeCostMyCostTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import "LifeCostMyCostTableViewCell.h"

@interface LifeCostMyCostTableViewCell ()
//@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *headerIcon;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *detailL;
@property (nonatomic,strong) UIImageView *rightIcon;
 
@end
@implementation LifeCostMyCostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

 
- (void)fillDataWithModel:(LifeCostMainVcTopGroupSubAccountEntityModel *)model{
        [_headerIcon sd_setImageWithURL:[UrlWithString getURLWithStr:[TextShowWithModelStr textShowWithModelStr:model.typePicUrl]] placeholderImage:[UIImage imageNamed:kLifeCost_Placeholder_ImgName]]; 
        _titleL.text = [TextShowWithModelStr textShowWithModelStr:model.typeName];
        _detailL.text =  [NSString stringWithFormat:@"%@ | %@",[TextShowWithModelStr textShowWithModelStr:model.account],[TextShowWithModelStr textShowWithModelStr:model.householder]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.headerIcon];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailL];
        [self.contentView addSubview:self.rightIcon];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerIcon.superview.mas_left).offset(26);
        make.top.equalTo(_headerIcon.superview.mas_top).offset(1);
        make.bottom.equalTo(_headerIcon.superview.mas_bottom).offset(-1);
        make.width.offset(30);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(10);
        make.left.equalTo(_headerIcon.mas_right).offset(10);
        make.right.equalTo(_titleL.superview.mas_right).offset(-45);
        make.height.offset(20);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(5);
        make.left.equalTo(_titleL.mas_left);
        make.right.equalTo(_titleL.mas_right);
        make.bottom.equalTo(_detailL.superview.mas_bottom).offset(-10);
    }];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightIcon.superview.mas_centerY);
        make.right.equalTo(_rightIcon.superview.mas_right).offset(-40);
        make.width.offset(5);
        make.height.offset(30);
    }];
  
}
#pragma mark ==
- (UIImageView *)headerIcon{
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc]init];
//        _headerIcon.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
        _headerIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headerIcon;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont systemFontOfSize:15];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.font = [UIFont systemFontOfSize:12];
        _detailL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    }
    return _detailL;
}
- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc]init];
        _rightIcon.contentMode = UIViewContentModeScaleAspectFit;
        if ([ThemeManager shareManager].type==ThemeType_White) {
            _rightIcon.image = [UIImage imageNamed:@"rightSkip"];
        }else{
            _rightIcon.image = [UIImage imageNamed:@"rightSkip_white"];
        }
    }
    return _rightIcon;
}
 

@end
