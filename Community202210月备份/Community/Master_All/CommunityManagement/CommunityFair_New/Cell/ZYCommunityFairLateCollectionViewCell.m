//
//  ZYCommunityFairLateCollectionViewCell.m
//  Community
//
//  Created by ZY on 2022/6/9.
//

#import "ZYCommunityFairLateCollectionViewCell.h"

@interface ZYCommunityFairLateCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopImageViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *markLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation ZYCommunityFairLateCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.shopNameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.distanceLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    [self.iconImageView zy_cornerRadiusAdvance:12 rectCornerType:UIRectCornerAllCorners];
}

@end
