//
//  ZYPensionMainActivityImageCollectionViewCell.m
//  Community
//
//  Created by ZY on 2021/11/5.
//

#import "ZYPensionMainActivityImageCollectionViewCell.h"

@implementation ZYPensionMainActivityImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.iconImageView zy_cornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
}

@end
