//
//  ZYSmallShopContainerRentPayPriceCollectionViewCell.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentPayPriceCollectionViewCell.h"

@interface ZYSmallShopContainerRentPayPriceCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYSmallShopContainerRentPayPriceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.layer.borderColor = [UIColor zy_colorWithHexString:@"#D8DCE6"].CGColor;
    self.contentV.layer.borderWidth = 1;
    self.contentV.layer.cornerRadius = 5;
    self.contentV.layer.masksToBounds = YES;
}

// 设置数据model
- (void)setModel:(ZYSmallShopContainerRentDetailCabinetModel *)model {
    _model = model;
    
    self.originPriceLabel.text = [NSString stringWithFormat:@"原价￥%@", [ZYDecimalNumberTool stringWithDecimalString:_model.cabinetPriceOriginal]];
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [ZYDecimalNumberTool stringWithDecimalString:_model.cabinetPriceSell]];
    if (_model.cabinetPriceStatus == 1) {
        self.titleLabel.text = @"货柜月租";
    }else if (_model.cabinetPriceStatus == 2) {
        self.titleLabel.text = @"货柜季租";
    }else if (_model.cabinetPriceStatus == 3) {
        self.titleLabel.text = @"货柜半年租";
    }else if (_model.cabinetPriceStatus == 4) {
        self.titleLabel.text = @"货柜年租";
    }
    if (_model.isSelected) {
        self.contentV.layer.borderColor = [UIColor zy_colorWithHexString:@"#FF0033"].CGColor;
    }else {
        self.contentV.layer.borderColor = [UIColor zy_colorWithHexString:@"#D8DCE6"].CGColor;
    }
}

@end
