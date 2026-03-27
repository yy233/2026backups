//
//  ZYQuestionnaireSurveyEditHeaderView.m
//  Community
//
//  Created by ZY on 2022/6/7.
//

#import "ZYQuestionnaireSurveyEditHeaderView.h"

@interface ZYQuestionnaireSurveyEditHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@end

@implementation ZYQuestionnaireSurveyEditHeaderView

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
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.subLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_D949daa;
}

// 设置数据model
- (void)setModel:(ZYQuestionnaireSurveyDetailEntityListModel *)model {
    _model = model;
    
    if (_model.choose == 2) {
        self.subLabel.hidden = NO;
        self.titleLabel.text = [NSString stringWithFormat:@"%ld、%@（多选）", _model.order, _model.content];
        if (_model.maxChoice > 0) {
            self.subLabel.text = [NSString stringWithFormat:@"*最少选择%ld个，最多选择%ld个", _model.minChoice, _model.maxChoice];
        }else {
            self.subLabel.text = [NSString stringWithFormat:@"*最少选择%ld个", _model.minChoice];
        }
    }else {
        self.subLabel.hidden = YES;
        self.titleLabel.text = [NSString stringWithFormat:@"%ld、%@", _model.order, _model.content];
        self.subLabel.text = @"";
    }
}

@end
