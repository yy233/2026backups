//
//  IssueHouseThreeGroupTextInfoShowTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/22.
//

#import "IssueHouseThreeGroupTextInfoShowTableViewCell.h"

@implementation IssueHouseThreeGroupTextInfoShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setUIOfNewTitles{
    self.oneTopLabel.text = @"房屋户型";
    self.twoTopLabel.text = @"朝向";
    self.thrTopLabel.text = @"楼层";
    self.oneBottomLabel.text = @"";
    self.twoBottomLabel.text = @"";
    self.thrBottomLabel.text = @"";
}
@end
