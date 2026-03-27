//
//  ZYRentSigningPayWayCell.m
//  Community
//
//  Created by ZY on 2021/9/14.
//

#import "ZYRentSigningPayWayCell.h"

@interface ZYRentSigningPayWayCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@end

@implementation ZYRentSigningPayWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

// 设置数据model
- (void)setModel:(ZYRentSigningPayWayModel *)model {
    _model = model;
    
    if (_model.isSelected) {
        [self.statusButton setImage:[UIImage imageNamed:@"pay_way_select"] forState:UIControlStateNormal];
    }else {
        [self.statusButton setImage:[UIImage imageNamed:@"pay_way_normal"] forState:UIControlStateNormal];
    }
    self.iconImageView.image = [UIImage imageNamed:_model.iconImageName];
    self.titleLabel.text = _model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
