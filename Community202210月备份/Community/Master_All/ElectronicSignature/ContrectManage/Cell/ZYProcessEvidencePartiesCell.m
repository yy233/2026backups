//
//  ZYProcessEvidencePartiesCell.m
//  Community
//
//  Created by ZY on 2021/5/28.
//

#import "ZYProcessEvidencePartiesCell.h"

@interface ZYProcessEvidencePartiesCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *partTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYProcessEvidencePartiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

// 设置数据model
- (void)setModel:(ZYProcessEvidenceDataListDataModel *)model {
    _model = model;
    
    if (_model.roleType == 0) {
        self.partTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    }else if (_model.roleType == 1) {
        self.partTitleLabel.textColor = Y_RGBA(38, 114, 249, 1);
    }else {
        self.partTitleLabel.textColor = Y_RGBA(0, 204, 171, 1);
    }
    self.partTitleLabel.text = _model.role;
    self.dateLabel.text = _model.time;
    self.contentLabel.text = _model.describe;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
