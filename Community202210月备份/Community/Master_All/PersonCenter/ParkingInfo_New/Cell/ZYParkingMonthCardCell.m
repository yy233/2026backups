//
//  ZYParkingMonthCardCell.m
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import "ZYParkingMonthCardCell.h"

@interface ZYParkingMonthCardCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZYParkingMonthCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.renewalButton.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(74, 30) direction:IHGradientChangeDirectionLevel startColor:[UIColor zy_colorWithHexString:@"#E9B87A"] endColor:[UIColor zy_colorWithHexString:@"#F8D9AD"]];
    self.renewalButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    self.renewalButton.titleLabel.font = [UIFont systemFontOfSize:15];
}

// 设置数据model
- (void)setModel:(ZYParkingMonthCardModel *)model {
    _model = model;
    
    if (_model.groundUpAndDown == 1) {
        self.nameLabel.text = _model.carPositionNumber;
        self.cardLabel.text = @"车位包月卡";
    }else {
        self.nameLabel.text = _model.carNumber;
        self.cardLabel.text = @"车辆包月卡";
    }
    self.addressLabel.text = _model.siteClassificationName;
    self.dateLabel.text = [NSString stringWithFormat:@"有效期至%@", model.stopTime.xh_format_yyyy_MM_dd];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
