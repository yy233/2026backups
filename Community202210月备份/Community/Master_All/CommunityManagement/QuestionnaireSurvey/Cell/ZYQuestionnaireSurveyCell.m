//
//  ZYQuestionnaireSurveyCell.m
//  Community
//
//  Created by ZY on 2022/6/7.
//

#import "ZYQuestionnaireSurveyCell.h"

@interface ZYQuestionnaireSurveyCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ZYQuestionnaireSurveyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabelWidthConstraint.constant = kScreenW - 62;
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.statusButton.titleLabel.font = [UIFont systemFontOfSize:13];
}

// 设置数据model
- (void)setModel:(ZYQuestionnaireSurveyListModel *)model {
    _model = model;
    
    if (_model.voteStatus == 3) {
        self.statusLabel.text = @"已完成";
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            self.statusLabel.backgroundColor = [UIColor zy_colorWithHexString:@"#F4F4F7"];
        }else {
            self.statusLabel.backgroundColor = [UIColor zy_colorWithHexString:@"#2E4674"];
        }
        self.statusLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    }else {
        self.statusLabel.text = @"进行中";
        self.statusLabel.backgroundColor = [UIColor zy_colorWithHexString:@"#FF8319" andAlpha:0.2];
        self.statusLabel.textColor = [UIColor zy_colorWithHexString:@"#FF8319"];
    }
    if (!_model.status && _model.voteStatus == 2) {
        [self.statusButton setTitle:@"去参与" forState:UIControlStateNormal];
    }else {
        [self.statusButton setTitle:@"查看" forState:UIControlStateNormal];
    }
    self.titleLabel.text = _model.theme;
    self.contentLabel.text = _model.content;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@截止", _model.overTime.xh_formatYueRi, _model.overTime.xh_format_HH_mm_ss];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
