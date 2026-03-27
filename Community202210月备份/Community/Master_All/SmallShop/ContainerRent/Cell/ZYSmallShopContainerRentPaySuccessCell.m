//
//  ZYSmallShopContainerRentPaySuccessCell.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentPaySuccessCell.h"

@interface ZYSmallShopContainerRentPaySuccessCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ZYSmallShopContainerRentPaySuccessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据
- (void)setPrice:(NSString *)price {
    _price = price;
    
    self.priceLabel.text =  [ZYDecimalNumberTool stringWithDecimalString:_price];
}

@end
