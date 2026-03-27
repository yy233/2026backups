//
//  MoneyOfThridBangDingWeiXinEditVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/10/18.
//

#import "MoneyOfThridBangDingWeiXinOrZfbEditVcTableViewCell.h"

@interface MoneyOfThridBangDingWeiXinOrZfbEditVcTableViewCell ()
@property (nonatomic,strong) UIImageView *leftImgV;
@property (nonatomic,strong) UIImageView *centerImgV;
@property (nonatomic,strong) UIImageView *rightImgV;

@end

@implementation MoneyOfThridBangDingWeiXinOrZfbEditVcTableViewCell
- (void)fillTypeWithISZfbBool:(BOOL)isZFBbool{
    if(isZFBbool){
        _leftImgV.image = [UIImage imageNamed:@"Balance_zhifubao"]; 
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =  [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.leftImgV];
        [self.contentView addSubview:self.centerImgV];
        [self.contentView addSubview:self.rightImgV];

        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(55);
        make.centerY.equalTo(_leftImgV.superview);
        make.centerX.equalTo(_leftImgV.superview).multipliedBy(0.5);
    }];
    [_centerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(25);
        make.centerY.equalTo(_centerImgV.superview);
        make.centerX.equalTo(_centerImgV.superview);
    }];
    [_rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(55);
        make.centerY.equalTo(_rightImgV.superview);
        make.centerX.equalTo(_rightImgV.superview).multipliedBy(1.5);
    }];
    
}
- (UIImageView *)leftImgV{
    if (!_leftImgV) {
        _leftImgV = [[UIImageView alloc]init];
        _leftImgV.image = [UIImage imageNamed:@"wx_icon_BangIng"];
    }
    return _leftImgV;
}
- (UIImageView *)centerImgV{
    if (!_centerImgV) {
        _centerImgV = [[UIImageView alloc]init];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            _centerImgV.image = [UIImage imageNamed:@"center_icon_BangDing"];
        }else{
            _centerImgV.image = [UIImage imageNamed:@"center_icon_BangDing_Night"];
        }
    }
    return _centerImgV;
}
- (UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc]init];
        _rightImgV.image = [UIImage imageNamed:@"app-icon01"];
    }
    return _rightImgV;
}

@end
