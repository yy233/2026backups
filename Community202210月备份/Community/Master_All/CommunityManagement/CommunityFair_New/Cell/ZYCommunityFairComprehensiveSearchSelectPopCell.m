//
//  ZYCommunityFairComprehensiveSearchSelectPopCell.m
//  Community
//
//  Created by ZY on 2022/6/10.
//

#import "ZYCommunityFairComprehensiveSearchSelectPopCell.h"

@implementation ZYCommunityFairComprehensiveSearchSelectPopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
