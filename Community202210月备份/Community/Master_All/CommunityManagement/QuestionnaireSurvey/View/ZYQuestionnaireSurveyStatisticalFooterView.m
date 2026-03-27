//
//  ZYQuestionnaireSurveyStatisticalFooterView.m
//  Community
//
//  Created by ZY on 2022/6/8.
//

#import "ZYQuestionnaireSurveyStatisticalFooterView.h"

@implementation ZYQuestionnaireSurveyStatisticalFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.moreButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:3];
    [self.moreButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_D949daa forState:UIControlStateNormal];
}

@end
