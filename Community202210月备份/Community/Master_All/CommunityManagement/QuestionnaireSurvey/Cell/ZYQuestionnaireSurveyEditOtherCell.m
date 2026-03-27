//
//  ZYQuestionnaireSurveyEditOtherCell.m
//  Community
//
//  Created by ZY on 2022/6/8.
//

#import "ZYQuestionnaireSurveyEditOtherCell.h"
#import "UITextView+YLTextView.h"

@interface ZYQuestionnaireSurveyEditOtherCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *subContentV;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYQuestionnaireSurveyEditOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.subContentV.layer.borderWidth = 0.5;
    self.subContentV.layer.cornerRadius = 2;
    self.subContentV.layer.masksToBounds = YES;
    self.subContentV.layer.borderColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor.CGColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    self.textView.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.textView.placeholder = @"请输入...";
    self.textView.placeholdColor = [UIColor zy_colorWithHexString:@"#AAAEB9"];
    self.textView.placeholdFont = [UIFont systemFontOfSize:14];
    self.textView.wordCountLabel.textColor = [UIColor zy_colorWithHexString:@"#AAAEB9"];
}

// 设置数据model
- (void)setModel:(ZYQuestionnaireSurveyDetailEntityListOptionModel *)model {
    _model = model;
    
    if (!_model.isCurrentStatus) {
        if (_model.status) {
            self.textView.text = _model.otherContent;
            self.textView.hidden = NO;
            self.textView.placeholder = @"请输入...";
            self.textView.delegate = self;
            [self.selectButton setImage:[UIImage imageNamed:@"wd_gouxuan_icon"] forState:UIControlStateNormal];
            self.subContentV.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9" andAlpha:0.15];
            self.subContentV.layer.borderColor = [UIColor zy_colorWithHexString:@"#2672F9"].CGColor;
        }else {
            self.textView.hidden = YES;
            [self.selectButton setImage:[UIImage imageNamed:@"wd_weigouxuan_icon"] forState:UIControlStateNormal];
            self.subContentV.backgroundColor = [UIColor clearColor];
            self.subContentV.layer.borderColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor.CGColor;
        }
    }else {
        if (_model.status) {
            self.textView.text = _model.otherContent;
            self.textView.hidden = NO;
            self.textView.placeholder = @"请输入...";
            self.textView.delegate = self;
            [self.selectButton setImage:[UIImage imageNamed:@"wd_gouxuan_icon"] forState:UIControlStateNormal];
            self.subContentV.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
        }else {
            self.textView.hidden = YES;
            [self.selectButton setImage:[UIImage imageNamed:@"wd_weigouxuan_icon"] forState:UIControlStateNormal];
            self.subContentV.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.model.otherContent = textView.text;
    if (self.block) {
        self.block(textView.text);
    }
}

@end
