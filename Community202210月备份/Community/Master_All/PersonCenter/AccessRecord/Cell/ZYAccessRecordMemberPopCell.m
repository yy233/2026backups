//
//  ZYAccessRecordMemberPopCell.m
//  Community
//
//  Created by ZY on 2022/4/26.
//

#import "ZYAccessRecordMemberPopCell.h"

@implementation ZYAccessRecordMemberPopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
