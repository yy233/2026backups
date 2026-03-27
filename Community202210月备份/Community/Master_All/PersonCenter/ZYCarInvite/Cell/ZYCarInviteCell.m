//
//  ZYCarInviteCell.m
//  Community
//
//  Created by ZY on 2022/5/18.
//

#import "ZYCarInviteCell.h"

@interface ZYCarInviteCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@end

@implementation ZYCarInviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
