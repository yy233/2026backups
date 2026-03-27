//
//  ZYQuestionnaireSurveyStatisticalTextCell.m
//  Community
//
//  Created by ZY on 2022/6/8.
//

#import "ZYQuestionnaireSurveyStatisticalTextCell.h"

@interface ZYQuestionnaireSurveyStatisticalTextCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *subContentV;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYQuestionnaireSurveyStatisticalTextCell

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

// 设置数据
- (void)setContent:(NSString *)content {
    _content = content;
    
    self.contentLabel.text = _content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
