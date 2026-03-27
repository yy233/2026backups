//
//  ZYCommunityFairComprehensiveSearchCell.m
//  Community
//
//  Created by ZY on 2022/6/10.
//

#import "ZYCommunityFairComprehensiveSearchCell.h"

@interface ZYCommunityFairComprehensiveSearchCell ()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *markLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ZYCommunityFairComprehensiveSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    [self.shopImageView zy_cornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
    self.shopNameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.addressLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
