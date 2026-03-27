//
//  ZYIntelligentInquirySearchExpertCell.m
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import "ZYIntelligentInquirySearchExpertCell.h"

@interface ZYIntelligentInquirySearchExpertCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation ZYIntelligentInquirySearchExpertCell
- (void)fillDataWithShopModel:(MedicalStoresBaseModel *)model{
 
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: model.shopLogo ]];

    self.shopNameLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.shopName];
    self.nameLabel.text = @"店铺类别";
    self.typeLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.shopTreeIdName];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.iconImageView zy_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
