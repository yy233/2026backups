//
//  ZYChatInformationTopCollectionViewCell.m
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import "ZYChatInformationTopCollectionViewCell.h"

@implementation ZYChatInformationTopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    // 图片切圆角
    [self.iconImageView zy_cornerRadiusAdvance:self.iconImageView.bounds.size.width / 2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (void)prepareForReuse{
    [super prepareForReuse];
    
    self.iconImageView.image = nil;
    self.titleLabel.text = @"";
}
@end
