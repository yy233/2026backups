//
//  HouseRepairOldInputLookDetailTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/4.
//

#import "HouseRepairOldInputLookDetailBaseShowTextTableViewCell.h"

@implementation HouseRepairOldInputLookDetailBaseShowTextTableViewCell

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
        [self.contentView addSubview:self.titleL];
        [self setUI];
    }
    return  self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_titleL.superview).insets(UIEdgeInsetsMake(0, 26, 0, 26) );
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleL;
}
@end


@implementation HouseRepairOldInputLookDetailBaseShowTitleTableViewCell

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
        self.titleL.font = [UIFont boldSystemFontOfSize:14];
        WEAKSELF
        [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.titleL.superview).insets(UIEdgeInsetsMake(10, 26, 0, 26));
        }];
    }
    return  self;
}
@end

