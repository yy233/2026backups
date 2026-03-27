//
//  ZYSmallShopServiceCollectionViewCell.m
//  Community
//
//  Created by ZY on 2022/3/2.
//

#import "ZYSmallShopServiceCollectionViewCell.h"

@interface ZYSmallShopServiceCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;

@end

@implementation ZYSmallShopServiceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置数据model
- (void)setModel:(ZYSmallShopMainValue3RecordsModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.commodityHeadImg] placeholderImage:[UIImage imageNamed:@"cc_placeholder"]];
    ZYImageWidthHeightModel *imageWidthHeightModel = [ZYSmallShopImageUrlSegmentationTool imageUrlSegmentationWithUrlStr:_model.commodityHeadImg];
    [self setImageAspectRatioWithModel:imageWidthHeightModel];
    self.titleLabel.text = _model.commodityName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [ZYDecimalNumberTool stringWithDecimalString:_model.commoditySellPrice]];
    self.originPriceLabel.text = [NSString stringWithFormat:@"原价￥%@", [ZYDecimalNumberTool stringWithDecimalString:_model.commodityOriginalPrice]];
}

- (void)setImageAspectRatioWithModel:(ZYImageWidthHeightModel *)model {
    CGFloat height;
    CGFloat ratio;
    if (model.width == 0) {
        ratio = 0;
    }else {
        ratio = model.height / model.width;
    }
    if (kMinAspectRatio <= ratio && ratio <= kMaxAspectRatio) {
        height = ratio * kZYSmallShopServiceCollectionViewCell_W;
    }else if (ratio  < kMinAspectRatio) {
        height = kMinAspectRatio * kZYSmallShopServiceCollectionViewCell_W;
    }else {
        height = kMaxAspectRatio * kZYSmallShopServiceCollectionViewCell_W;
    }
    self.iconImageViewHeightConstraint.constant = height;
}

@end
