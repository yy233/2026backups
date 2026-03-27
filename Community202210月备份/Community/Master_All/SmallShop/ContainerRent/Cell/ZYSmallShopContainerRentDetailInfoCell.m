//
//  ZYSmallShopContainerRentDetailInfoCell.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentDetailInfoCell.h"

@interface ZYSmallShopContainerRentDetailInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *containerNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *containerAreaLabel;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end

@implementation ZYSmallShopContainerRentDetailInfoCell

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
    
    self.containerNumLabel.text = [NSString stringWithFormat:@"货柜编号：%@", _model.cabinetNumber];
    self.containerAreaLabel.text = [NSString stringWithFormat:@"货柜尺寸：%@立方米", _model.volume];
    self.dayLabel.text = [NSString stringWithFormat:@"剩余可用时间：%ld天", _model.remainDay];
    if (_model.isHiddenRemainDay) {
        self.dayLabel.hidden = YES;
    }else {
        self.dayLabel.hidden = NO;
    }
}

@end
