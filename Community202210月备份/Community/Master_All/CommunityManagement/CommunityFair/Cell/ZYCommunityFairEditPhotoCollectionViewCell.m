//
//  ZYCommunityFairEditPhotoCollectionViewCell.m
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import "ZYCommunityFairEditPhotoCollectionViewCell.h"

@implementation ZYCommunityFairEditPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.deleteButton.hitTestEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
    
    self.addView.layer.cornerRadius = 5;
    self.addView.layer.masksToBounds = YES;
    
    [self.iconImageView zy_cornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
}

@end
