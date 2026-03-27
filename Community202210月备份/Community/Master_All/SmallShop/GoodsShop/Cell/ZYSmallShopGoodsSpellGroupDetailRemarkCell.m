//
//  ZYSmallShopGoodsSpellGroupDetailRemarkCell.m
//  Community
//
//  Created by ZY on 2022/3/12.
//

#import "ZYSmallShopGoodsSpellGroupDetailRemarkCell.h"

@interface ZYSmallShopGoodsSpellGroupDetailRemarkCell ()

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation ZYSmallShopGoodsSpellGroupDetailRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYSmallShopGoodsSpellGroupDetailModel *)model {
    _model = model;
    
    self.remarkLabel.text = _model.commodityDescribe;
}

@end
