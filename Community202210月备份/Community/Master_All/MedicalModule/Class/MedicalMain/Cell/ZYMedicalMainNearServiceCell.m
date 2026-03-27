//
//  ZYMedicalMainNearServiceCell.m
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import "ZYMedicalMainNearServiceCell.h"

@interface ZYMedicalMainNearServiceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;

@end

@implementation ZYMedicalMainNearServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.iconImageView zy_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillDataWithServiceModel:(MedicalServiceBaseModel *)model{
    NSArray *imgArrs = [model.images componentsSeparatedByString:@","];
    if (imgArrs.count>0) {
        [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr:imgArrs.firstObject]];
    }
    
    self.nameLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.title];

    if (model.discountPrice) {
        //有折扣
        self.currentPriceLabel.text = [NSString stringWithFormat:@"%@",model.discountPrice];
        self.originalPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
        self.originalPriceLabel.hidden = NO;
    }else{
        //没有折扣
        self.currentPriceLabel.text = [NSString stringWithFormat:@"%@",model.price];
        self.originalPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
        self.originalPriceLabel.hidden = YES;
    }
}

@end
