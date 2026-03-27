//
//  ZYParkingAddMonthCardCell.m
//  Community
//
//  Created by ZY on 2022/5/9.
//

#import "ZYParkingAddMonthCardCell.h"

@interface ZYParkingAddMonthCardCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYParkingAddMonthCardCell

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
    if (_model.content.length > 0) {
        self.contentLabel.text = _model.content;
        self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    }else {
        self.contentLabel.text = @"请选择";
        self.contentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
