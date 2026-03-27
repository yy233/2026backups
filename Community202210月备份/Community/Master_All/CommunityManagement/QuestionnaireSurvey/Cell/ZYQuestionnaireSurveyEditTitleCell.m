//
//  ZYQuestionnaireSurveyEditTitleCell.m
//  Community
//
//  Created by ZY on 2022/6/7.
//

#import "ZYQuestionnaireSurveyEditTitleCell.h"

@interface ZYQuestionnaireSurveyEditTitleCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYQuestionnaireSurveyEditTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabelWidthConstraint.constant = kScreenW - 32;
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYQuestionnaireSurveyDetailModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.theme;
    self.contentLabel.text = _model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
