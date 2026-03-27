//
//  ZYSmallShopServiceDetailPriceCell.m
//  Community
//
//  Created by ZY on 2022/3/3.
//

#import "ZYSmallShopServiceDetailPriceCell.h"

@interface ZYSmallShopServiceDetailPriceCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation ZYSmallShopServiceDetailPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYSmallShopServiceDetailModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.serveName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [ZYDecimalNumberTool stringWithDecimalString:_model.serveSellPrice]];
    self.originPriceLabel.text = [NSString stringWithFormat:@"原价￥%@", [ZYDecimalNumberTool stringWithDecimalString:_model.serveOriginalPrice]];
    self.remarkLabel.text = _model.serveDescribe;
}

@end
