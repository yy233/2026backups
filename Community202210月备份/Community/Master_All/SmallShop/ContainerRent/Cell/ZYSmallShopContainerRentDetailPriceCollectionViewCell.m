//
//  ZYSmallShopContainerRentDetailPriceCollectionViewCell.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentDetailPriceCollectionViewCell.h"

@interface ZYSmallShopContainerRentDetailPriceCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYSmallShopContainerRentDetailPriceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置数据model
- (void)setModel:(ZYSmallShopContainerRentDetailCabinetModel *)model {
    _model = model;
    
    self.originPriceLabel.text = [NSString stringWithFormat:@"原价￥%@", [ZYDecimalNumberTool stringWithDecimalString:_model.cabinetPriceOriginal]];
    self.priceLabel.text = [ZYDecimalNumberTool stringWithDecimalString:_model.cabinetPriceSell];
    if (_model.cabinetPriceStatus == 1) {
        self.titleLabel.text = @"货柜月租";
    }else if (_model.cabinetPriceStatus == 2) {
        self.titleLabel.text = @"货柜季租";
    }else if (_model.cabinetPriceStatus == 3) {
        self.titleLabel.text = @"货柜半年租";
    }else if (_model.cabinetPriceStatus == 4) {
        self.titleLabel.text = @"货柜年租";
    }
}

@end
