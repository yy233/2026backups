//
//  ZYSmallShopDetailImageCell.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopDetailImageCell.h"

@interface ZYSmallShopDetailImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation ZYSmallShopDetailImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYSmallShopContainerRentDetailModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.cabinetImg] placeholderImage:[UIImage imageNamed:@"cc_placeholder_big_banner"]];
}

@end
