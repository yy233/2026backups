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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.8];
    self.detailTextLabel.textColor =  [ThemeManager shareManager].mainTextColor;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.detailTextLabel.font = [UIFont boldSystemFontOfSize:17];
    [self fdata];
}
- (void)fdata{
    self.textLabel.text = @"物业费";
    self.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",@"37.12"];
}
@end
