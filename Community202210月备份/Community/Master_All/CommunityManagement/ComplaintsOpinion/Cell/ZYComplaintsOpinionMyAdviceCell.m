//
//  ZYComplaintsOpinionMyAdviceCell.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYComplaintsOpinionMyAdviceCell.h"

@interface ZYComplaintsOpinionMyAdviceCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *nameLineView;

@property (weak, nonatomic) IBOutlet UIView *dateLineView;

@property (weak, nonatomic) IBOutlet UIView *statusLineView;

@end

@implementation ZYComplaintsOpinionMyAdviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.nameTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.dateTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.statusTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.dateLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.statusLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.dateLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.statusLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

// 设置数据model
- (void)setModel:(ZYComplaintsOpinionMyAdviceDataModel *)model {
    _model = model;
    
    self.nameLabel.text = _model.communityName;
    self.dateLabel.text = _model.complainTime.xh_format_yyyy_MM_dd_HH_mm;
    if (_model.status == 0) {
        self.statusLabel.text = @"未处理";
    }else {
        self.statusLabel.text = @"已处理";
    }
    self.contentLabel.text = _model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
