//
//  ZYReportAboutRepairApplyInfoCollectionViewCell.m
//  Community
//
//  Created by ZY on 2022/3/7.
//

#import "ZYReportAboutRepairApplyInfoCollectionViewCell.h"

@interface ZYReportAboutRepairApplyInfoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYReportAboutRepairApplyInfoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.layer.borderWidth = 0.5;
    self.contentV.layer.borderColor = [UIColor zy_colorWithHexString:@"#2672F9"].CGColor;
    self.contentV.layer.cornerRadius = 2.5;
    self.contentV.layer.masksToBounds = YES;
}

// 设置数据model
- (void)setModel:(ZYReportAboutRepairApplyCategoryModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.name;
    if (_model.isSelected) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.contentV.layer.borderColor = [UIColor zy_colorWithHexString:@"#2672F9"].CGColor;
        self.contentV.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
    }else {
        self.titleLabel.textColor = [ZYThemeManager shareManager].threeLevelTitleThemeColor_Dc5c9d4;
        self.contentV.layer.borderColor = [ZYThemeManager shareManager].borderThemeColor.CGColor;
        self.contentV.backgroundColor = [UIColor clearColor];
    }
}

@end
