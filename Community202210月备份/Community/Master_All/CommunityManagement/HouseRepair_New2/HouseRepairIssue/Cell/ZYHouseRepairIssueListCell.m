//
//  ZYHouseRepairIssueListCell.m
//  Community
//
//  Created by ZY on 2022/4/12.
//

#import "ZYHouseRepairIssueListCell.h"

@implementation ZYHouseRepairIssueListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    self.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
