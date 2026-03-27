//
//  ZYQuestionnaireSurveyEditFooterView.m
//  Community
//
//  Created by ZY on 2022/6/8.
//

#import "ZYQuestionnaireSurveyEditFooterView.h"

@interface ZYQuestionnaireSurveyEditFooterView ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@end

@implementation ZYQuestionnaireSurveyEditFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
}

@end
