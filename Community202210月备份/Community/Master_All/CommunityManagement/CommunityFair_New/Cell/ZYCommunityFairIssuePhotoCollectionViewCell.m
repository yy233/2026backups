//
//  ZYCommunityFairIssuePhotoCollectionViewCell.m
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import "ZYCommunityFairIssuePhotoCollectionViewCell.h"

@implementation ZYCommunityFairIssuePhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.deleteButton.hitTestEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
    
    self.addView.layer.cornerRadius = 5;
    self.addView.layer.masksToBounds = YES;
    
    [self.iconImageView zy_cornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
}

@end
