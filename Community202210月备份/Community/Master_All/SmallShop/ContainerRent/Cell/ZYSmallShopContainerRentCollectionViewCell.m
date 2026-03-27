//
//  ZYSmallShopContainerRentCollectionViewCell.m
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import "ZYSmallShopContainerRentCollectionViewCell.h"

@interface ZYSmallShopContainerRentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ZYSmallShopContainerRentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置数据model
- (void)setModel:(ZYSmallShopContainerRentListRecordsModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.cabinetImg] placeholderImage:[UIImage imageNamed:@"cc_placeholder_small"]];
    self.titleLabel.text = _model.title;
    self.sizeLabel.text = [NSString stringWithFormat:@"尺寸：%@立方米", _model.volume];
    self.priceLabel.text = [NSString stringWithFormat:@"%@/月", [ZYDecimalNumberTool stringWithDecimalString:_model.price]];
}

@end
