//
//  ZYFriendVerifyCell.m
//  Community
//
//  Created by ZY on 2021/4/24.
//

#import "ZYFriendVerifyCell.h"

@implementation ZYFriendVerifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.sendButton.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(kScreenW - 76, 46) direction:IHGradientChangeDirectionLevel startColor:Y_RGBA(37, 88, 255, 1) endColor:Y_RGBA(61, 142, 252, 1)];
    self.remarkTextView.text = @"";
    self.verifyTextView.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
