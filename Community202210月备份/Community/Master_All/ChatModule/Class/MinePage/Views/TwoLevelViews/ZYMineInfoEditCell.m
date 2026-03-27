//
//  ZYMineInfoEditCell.m
//  Community
//
//  Created by ZY on 2021/4/25.
//

#import "ZYMineInfoEditCell.h"

@implementation ZYMineInfoEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.iconImageView zy_cornerRadiusAdvance:self.iconImageView.bounds.size.width / 2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
