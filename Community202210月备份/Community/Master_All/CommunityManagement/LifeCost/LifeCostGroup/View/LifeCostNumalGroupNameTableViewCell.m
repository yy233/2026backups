//
//  LifeCostNumalGroupNameTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/3/24.
//

#import "LifeCostNumalGroupNameTableViewCell.h"

@implementation LifeCostNumalGroupNameTableViewCell

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
        self.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.chooseTypeBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_nameL.superview).insets(UIEdgeInsetsMake(5, 26, 5, 50));
    }];
    [_chooseTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.centerY.equalTo(_chooseTypeBtn.superview);
        make.right.equalTo(_chooseTypeBtn.superview.mas_right).offset(-26);
    }];
}
#pragma mark ==
- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = [ThemeManager shareManager].mainTextColor;
        _nameL.font = [UIFont systemFontOfSize:15];
    }
    return _nameL;
}
- (UIButton *)chooseTypeBtn{
    if (!_chooseTypeBtn) {
        _chooseTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseTypeBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"Selectgroup_Default_night"] selectedImg:[UIImage imageNamed:@"Selectgroup_Select_night"]];
    }
    return _chooseTypeBtn;
}
@end
