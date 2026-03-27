//
//  ElectronicSigbatureTextLabelTableViewCell.m
//  Community
//
//  Created by ZY on 2021/4/17.
//

#import "ElectronicSigbatureTextLabelTableViewCell.h"

@interface ElectronicSigbatureTextLabelTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ElectronicSigbatureTextLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self setUI];
    }
    return self;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"合同知识";
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_L3c496f;
    }
    
    return _titleLabel;
}

- (void)setUI {
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_titleLabel.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
}

@end
