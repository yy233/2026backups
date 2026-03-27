//
//  LifeCostAddGroupNameTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/3/24.
//

#import "LifeCostAddGroupNameTableViewCell.h"

@implementation LifeCostAddGroupNameTableViewCell

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
        [self.contentView addSubview:self.textField];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textField.superview).insets(UIEdgeInsetsMake(5, 26, 5, 26));
    }];
}
#pragma mark ==
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.textColor =  [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"自定义分组名" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]}];
        _textField.attributedPlaceholder =  placeholderString;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = [UIFont systemFontOfSize:15];
    }
    return _textField;
}


@end
