//
//  ZYSmallShopPayWayBaseCell.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopPayWayBaseCell.h"

@interface ZYSmallShopPayWayBaseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation ZYSmallShopPayWayBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据
- (void)setModel:(ZYSmallShopPayWayModel *)model {
    _model = model;
    
    self.iconImageView.image = [UIImage imageNamed:_model.image];
    self.titleLabel.text = _model.title;
    self.selectButton.selected = _model.isSelected;
}

@end
