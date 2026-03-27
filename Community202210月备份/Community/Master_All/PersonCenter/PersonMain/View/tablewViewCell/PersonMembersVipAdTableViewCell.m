//
//  PersonMembersVipAdTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/25.
// 会员优惠解锁

#import "PersonMembersVipAdTableViewCell.h"
#define OpenBtn_Color_Begin Y_RGBA(253, 224, 154, 1)
#define OpenBtn_Color_END   Y_RGBA(227, 195, 119, 1)
@implementation PersonMembersVipAdTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backV];
        [self.backV addSubview:self.topImgV];
        [self.backV addSubview:self.titleLabel];
        [self.backV addSubview:self.rightOpenVipBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backV.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    [_topImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topImgV.superview.mas_centerY);
        make.left.equalTo(_topImgV.superview.mas_left).offset(20);
        make.height.offset(30);
        make.width.offset(30);
    }];
    [_rightOpenVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightOpenVipBtn.superview.mas_centerY);
        make.right.equalTo(_rightOpenVipBtn.superview.mas_right).offset(-10);
        make.height.offset(30);
        make.width.offset(70);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.superview.mas_centerY);
        make.left.equalTo(_topImgV.mas_right).offset(20);
        make.height.offset(30);
        make.right.equalTo(_rightOpenVipBtn.mas_left).offset(10);
    }];
    
}
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
        _backV.layer.cornerRadius = 7.5;
        _backV.backgroundColor = Y_RGBA(41, 47, 69, 1);
    }
    return _backV;
}
-  (UIImageView *)topImgV{
    if (!_topImgV ) {
        _topImgV = [[UIImageView alloc]init];
        _topImgV.contentMode = UIViewContentModeScaleAspectFit;
        _topImgV.image = [UIImage imageNamed:@"My_member"];
    }
    return _topImgV;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake(26, 10, Screen_W*0.5, 20);//26
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = Y_RGBA(249, 218, 147, 1);
        _titleLabel.text = @"会员优惠等你来解锁";
    }
    return _titleLabel;
}
- (UIButton *)rightOpenVipBtn{
    if (!_rightOpenVipBtn) {
        _rightOpenVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightOpenVipBtn.frame = CGRectMake(Screen_W-110, 10, 80, 20);
        _rightOpenVipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rightOpenVipBtn setTitleColor: Y_RGBA(130, 93, 5, 1) forState:UIControlStateNormal];
        _rightOpenVipBtn.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(70, 30) direction:IHGradientChangeDirectionLevel startColor:OpenBtn_Color_Begin endColor:OpenBtn_Color_END];
        [_rightOpenVipBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        _rightOpenVipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _rightOpenVipBtn.layer.cornerRadius = 15;
    }
    return _rightOpenVipBtn;
}
@end
