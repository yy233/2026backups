//
//  PersonCenterTitleTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/18.
//

#import "PersonCenterTitleTableViewCell.h"

@implementation PersonCenterTitleTableViewCell

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
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.rightBtn];
    }
    return self;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake(26, 10, Screen_W*0.5, 20);//26
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    return _titleLabel;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(Screen_W-100, 10, 80, 20);
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    [_rightBtn setTitleColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
    _rightBtn.titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    return _rightBtn;
}
@end
