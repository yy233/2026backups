//
//  ZYChatUserInfoCenterAllCollectionViewCell.m
//  Community
//
//  Created by ZY on 2021/4/24.
//

#import "ZYChatUserInfoCenterAllCollectionViewCell.h"

@implementation ZYChatUserInfoCenterAllCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake((kScreenW - 88) / 4, ((kScreenW - 88) / 4) * 69 / 72) direction:IHGradientChangeDirectionLevel startColor:Y_RGBA(61, 142, 252, 1) endColor:Y_RGBA(37, 88, 255, 1)];
}

@end
