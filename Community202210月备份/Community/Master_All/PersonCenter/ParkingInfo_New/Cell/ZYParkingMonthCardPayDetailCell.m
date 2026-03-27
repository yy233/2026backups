//
//  ZYParkingMonthCardPayDetailCell.m
//  Community
//
//  Created by ZY on 2022/5/9.
//

#import "ZYParkingMonthCardPayDetailCell.h"

@interface ZYParkingMonthCardPayDetailCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYParkingMonthCardPayDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYParkingMonthCardRenewalModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.title;
    self.contentLabel.text = _model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
