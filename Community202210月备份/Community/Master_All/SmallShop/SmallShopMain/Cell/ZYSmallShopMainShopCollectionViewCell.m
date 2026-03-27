//
//  ZYSmallShopMainShopCollectionViewCell.m
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import "ZYSmallShopMainShopCollectionViewCell.h"

@interface ZYSmallShopMainShopCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopImageViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *activityView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@property (weak, nonatomic) IBOutlet UILabel *hotLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotViewHeightConstraint;

@end

@implementation ZYSmallShopMainShopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置数据model
- (void)setModel:(ZYSmallShopMainValue3RecordsModel *)model {
    _model = model;
    
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:_model.commodityHeadImg] placeholderImage:[UIImage imageNamed:@"cc_placeholder"]];
    ZYImageWidthHeightModel *imageWidthHeightModel = [ZYSmallShopImageUrlSegmentationTool imageUrlSegmentationWithUrlStr:_model.commodityHeadImg];
    [self setImageAspectRatioWithModel:imageWidthHeightModel];
    self.shopNameLabel.text = _model.commodityName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [ZYDecimalNumberTool stringWithDecimalString:_model.commoditySellPrice]];
    self.originPriceLabel.text = [NSString stringWithFormat:@"原价￥%@", [ZYDecimalNumberTool stringWithDecimalString:_model.commodityOriginalPrice]];
    if (_model.activityName.length > 0) {
        self.activityViewTopConstraint.constant = 6;
        self.activityViewHeightConstraint.constant = 20;
        self.activityView.hidden = NO;
        self.activityLabel.text = _model.activityName;
    }else {
        self.activityViewTopConstraint.constant = 0;
        self.activityViewHeightConstraint.constant = 0;
        self.activityView.hidden = YES;
        self.activityLabel.text = @"";
    }
    if (_model.selling > 0) {
        self.hotLabel.text = [NSString stringWithFormat:@"本月热卖：%ld", _model.selling];
    }else if (_model.commodityInventedSales > 0) {
        self.hotLabel.text = [NSString stringWithFormat:@"本月热卖：%ld", _model.commodityInventedSales];
    }
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
        height = ratio * kZYSmallShopMainShopCollectionViewCell_W;
    }else if (ratio  < kMinAspectRatio) {
        height = kMinAspectRatio * kZYSmallShopMainShopCollectionViewCell_W;
    }else {
        height = kMaxAspectRatio * kZYSmallShopMainShopCollectionViewCell_W;
    }
    self.shopImageViewHeightConstraint.constant = height;
}

@end
