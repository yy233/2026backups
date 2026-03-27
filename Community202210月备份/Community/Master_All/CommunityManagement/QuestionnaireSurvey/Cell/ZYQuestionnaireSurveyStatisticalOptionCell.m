//
//  ZYQuestionnaireSurveyStatisticalOptionCell.m
//  Community
//
//  Created by ZY on 2022/6/8.
//

#import "ZYQuestionnaireSurveyStatisticalOptionCell.h"

@interface ZYQuestionnaireSurveyStatisticalOptionCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *subContentV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statisticalViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *statisticalView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *voteLabel;

@end

@implementation ZYQuestionnaireSurveyStatisticalOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.subContentV.layer.borderWidth = 0.5;
    self.subContentV.layer.cornerRadius = 2;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.statisticalView.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
        self.subContentV.layer.borderColor = [UIColor zy_colorWithHexString:@"#F0F1F6"].CGColor;
    }else {
        self.statisticalView.backgroundColor = [UIColor zy_colorWithHexString:@"#2E4674"];
        self.subContentV.layer.borderColor = [UIColor zy_colorWithHexString:@"#2E4674"].CGColor;
    }
    self.subContentV.layer.masksToBounds = YES;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYQuestionnaireSurveyDetailEntityListOptionModel *)model {
    _model = model;
    
    self.contentLabel.text = _model.content;
    self.voteLabel.text = [NSString stringWithFormat:@"%ld票", _model.number];
    if (_model.total > 0) {
        self.statisticalViewWidthConstraint.constant = (CGFloat)_model.number / (CGFloat)_model.total * (kScreenW - 32);
    }else {
        self.statisticalViewWidthConstraint.constant = 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
