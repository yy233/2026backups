//
//  ZYElectronicMyInfoListCell.m
//  Community
//
//  Created by ZY on 2021/9/6.
//

#import "ZYElectronicMyInfoListCell.h"

@implementation ZYElectronicMyInfoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.skipImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"skip-all"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
