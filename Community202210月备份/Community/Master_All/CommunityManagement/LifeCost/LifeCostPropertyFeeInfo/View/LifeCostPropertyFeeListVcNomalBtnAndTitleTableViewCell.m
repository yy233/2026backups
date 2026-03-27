//
//  LifeCostPropertyFeeListVcNomalTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/7/6.
//

#import "LifeCostPropertyFeeListVcNomalBtnAndTitleTableViewCell.h"

@implementation LifeCostPropertyFeeListVcNomalBtnAndTitleTableViewCell

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
  
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.backView addSubview:self.topRightChooseBtn];
        [self.backView addSubview:self.titleL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_topRightChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.left.equalTo(_topRightChooseBtn.superview).offset(16);
        make.centerY.equalTo(_topRightChooseBtn.superview);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topRightChooseBtn.mas_right).offset(16);
        make.centerY.equalTo(_titleL.superview);
        make.right.equalTo(_titleL.superview).offset(-10);
    }];
    self.detailTextLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    self.detailTextLabel.font = [UIFont systemFontOfSize:14];
    [_topRightChooseBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];//扩大点击范围
}
- (UIButton *)topRightChooseBtn{
    if (!_topRightChooseBtn) {
        _topRightChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topRightChooseBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"Chooseahouse_normal"] selectedImg:[UIImage imageNamed:@"Chooseahouse_Select"]];
    }
    return _topRightChooseBtn;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    return _titleL;
}
@end
