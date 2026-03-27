//
//  ZYParkingInvalidMonthCardCell.m
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import "ZYParkingInvalidMonthCardCell.h"

@interface ZYParkingInvalidMonthCardCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZYParkingInvalidMonthCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    self.dateLabel.text = [NSString stringWithFormat:@"有效期至%@", model.stopTime.xh_format_yyyyMMdd];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
