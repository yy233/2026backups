//
//  ZYSOSSalvageServiceCell.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYSOSSalvageServiceCell.h"

@interface ZYSOSSalvageServiceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation ZYSOSSalvageServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    [self.iconImageView zy_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillDataWithAgencyModel:(SosAddressBookAgencyModel *)model{
    self.nameLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.shopName];
    self.distanceLabel.text =  [NSString stringWithFormat:@"距离%0.1f公里",(double)(model.distance/1000)];
    self.locationLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.businessAddress];
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr:model.shopLogo] placeholderImage:[UIImage imageNamed:@"yl_yytox"]];

}
@end
