//
//  ZYParkingTemporaryCell.m
//  Community
//
//  Created by ZY on 2021/10/25.
//

#import "ZYParkingTemporaryCell.h"

@interface ZYParkingTemporaryCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;

@end

@implementation ZYParkingTemporaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.carNameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.communityNameLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

// 设置数据model
- (void)setModel:(ZYParkingTemporaryDataModel *)model {
    _model = model;
    
    self.carNameLabel.text = _model.carPlate;
    self.dateLabel.text = [NSString stringWithFormat:@"进场时间：%@", _model.beginTime];
    self.communityNameLabel.text = [NSString stringWithFormat:@"小区信息：%@", _model.carPositionText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
