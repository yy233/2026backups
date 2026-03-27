//
//  ZYQuestionnaireSurveyEditTextCell.m
//  Community
//
//  Created by ZY on 2022/6/7.
//

#import "ZYQuestionnaireSurveyEditTextCell.h"
#import "UITextView+YLTextView.h"

@interface ZYQuestionnaireSurveyEditTextCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYQuestionnaireSurveyEditTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [ZYThemeManager shareManager].borderThemeColor.CGColor;
    self.textView.layer.cornerRadius = 2;
    self.textView.layer.masksToBounds = YES;
    self.textView.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.textView.limitLength = @300;
    self.textView.placeholder = @"请输入...";
    self.textView.placeholdColor = [UIColor zy_colorWithHexString:@"#AAAEB9"];
    self.textView.placeholdFont = [UIFont systemFontOfSize:14];
    self.textView.wordCountLabel.textColor = [UIColor zy_colorWithHexString:@"#AAAEB9"];
}

// 设置数据model
- (void)setModel:(ZYQuestionnaireSurveyDetailEntityListModel *)model {
    _model = model;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld、%@", _model.order, _model.content];
    self.textView.text = _model.answerContent;
    self.textView.placeholder = @"请输入...";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
