//
//  ZYUploadFaceCollectionViewCell.m
//  Community
//
//  Created by ZY on 2021/8/10.
//

#import "ZYUploadFaceCollectionViewCell.h"

@implementation ZYUploadFaceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.deleteButton.hitTestEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
    
    self.addView.layer.cornerRadius = 2;
    self.addView.layer.masksToBounds = YES;
    
    [self.iconImageView zy_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
}

@end
