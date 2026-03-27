//
//  ZYProcessEvidenceDepositCertificateCell.m
//  Community
//
//  Created by ZY on 2021/5/28.
//

#import "ZYProcessEvidenceDepositCertificateCell.h"

@interface ZYProcessEvidenceDepositCertificateCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYProcessEvidenceDepositCertificateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.subTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.codeLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

// 设置数据model
- (void)setModel:(ZYProcessEvidenceDataListDataModel *)model {
    _model = model;
    
    if (_model.codeType == 0) {
        self.subTitleLabel.text = @"存证号：";
    }else {
        self.subTitleLabel.text = @"司法链：";
    }
    self.titleLabel.text = _model.role;
    self.dateLabel.text = _model.time;
    self.contentLabel.text = _model.describe;
    self.codeLabel.text = _model.code;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
