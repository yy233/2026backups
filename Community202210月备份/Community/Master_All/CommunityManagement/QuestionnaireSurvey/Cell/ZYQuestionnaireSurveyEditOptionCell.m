//
//  ZYQuestionnaireSurveyEditOptionCell.m
//  Community
//
//  Created by ZY on 2022/6/7.
//

#import "ZYQuestionnaireSurveyEditOptionCell.h"

@interface ZYQuestionnaireSurveyEditOptionCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *subContentV;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYQuestionnaireSurveyEditOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.subContentV.layer.borderWidth = 0.5;
    self.subContentV.layer.cornerRadius = 2;
    self.subContentV.layer.masksToBounds = YES;
    self.subContentV.layer.borderColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor.CGColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYQuestionnaireSurveyDetailEntityListOptionModel *)model {
    _model = model;
    
    if (!_model.isCurrentStatus) {
        if (_model.status) {
            [self.selectButton setImage:[UIImage imageNamed:@"wd_gouxuan_icon"] forState:UIControlStateNormal];
            self.subContentV.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9" andAlpha:0.15];
            self.subContentV.layer.borderColor = [UIColor zy_colorWithHexString:@"#2672F9"].CGColor;
        }else {
            [self.selectButton setImage:[UIImage imageNamed:@"wd_weigouxuan_icon"] forState:UIControlStateNormal];
            self.subContentV.backgroundColor = [UIColor clearColor];
            self.subContentV.layer.borderColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor.CGColor;
        }
    }else {
        if (_model.status) {
            [self.selectButton setImage:[UIImage imageNamed:@"wd_gouxuan_icon"] forState:UIControlStateNormal];
            self.subContentV.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
        }else {
            [self.selectButton setImage:[UIImage imageNamed:@"wd_weigouxuan_icon"] forState:UIControlStateNormal];
            self.subContentV.backgroundColor = [UIColor clearColor];
        }
    }
    
    self.contentLabel.text = _model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
