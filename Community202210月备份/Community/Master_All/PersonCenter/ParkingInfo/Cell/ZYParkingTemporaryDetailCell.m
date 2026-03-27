//
//  ZYParkingTemporaryDetailCell.m
//  Community
//
//  Created by ZY on 2021/10/26.
//

#import "ZYParkingTemporaryDetailCell.h"

@interface ZYParkingTemporaryDetailCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *standardLabel;

@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@property (weak, nonatomic) IBOutlet UIView *line1View;

@property (weak, nonatomic) IBOutlet UIView *line2View;

@property (weak, nonatomic) IBOutlet UIView *line3View;

@property (weak, nonatomic) IBOutlet UIView *line4View;

@property (weak, nonatomic) IBOutlet UIView *line5View;

@end

@implementation ZYParkingTemporaryDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.carNameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.communityNameLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.startDateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.totalTimeLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.standardLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.line1View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line2View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line3View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line4View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line5View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

// 设置数据model
- (void)setModel:(ZYParkingTemporaryDetailDataModel *)model {
    _model = model;
    
    self.carNameLabel.text = _model.carPlate;
    self.communityNameLabel.text = [NSString stringWithFormat:@"小区信息：%@", _model.carPositionText];
    self.startDateLabel.text = [NSString stringWithFormat:@"进场时间：%@", _model.beginTime];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"共计时间：%@分钟", _model.minute];
    self.standardLabel.text = [NSString stringWithFormat:@"计费标准：%@元/小时（%@小时后按天算）", _model.expenseRule, _model.retentionHour];
    self.costLabel.text = [NSString stringWithFormat:@"￥%@", _model.money];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
