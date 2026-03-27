//
//  ZYAccessRecordSettingMemberCell.m
//  Community
//
//  Created by ZY on 2022/4/26.
//

#import "ZYAccessRecordSettingMemberCell.h"

@interface ZYAccessRecordSettingMemberCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UIView *relationView;

@property (weak, nonatomic) IBOutlet UILabel *relationLabel;

@end

@implementation ZYAccessRecordSettingMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.iconImageView zy_cornerRadiusAdvance:30 rectCornerType:UIRectCornerAllCorners];
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.telLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    self.relationView.layer.borderWidth = 0.5;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.relationView.layer.borderColor = [UIColor clearColor].CGColor;
        self.relationView.backgroundColor = [UIColor zy_colorWithHexString:@"#FFE9C5"];
        self.relationLabel.textColor = [UIColor zy_colorWithHexString:@"#FF3607"];
    }else {
        self.relationView.layer.borderColor = [UIColor zy_colorWithHexString:@"#F7DCB1"].CGColor;
        self.relationView.backgroundColor = [UIColor clearColor];
        self.relationLabel.textColor = [UIColor zy_colorWithHexString:@"#F7DCB1"];
    }
}

// 设置数据model
- (void)setModel:(ZYAccessRecordVisitPermitModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.faceUrl] placeholderImage:[UIImage imageNamed:@"cc_placeholder"]];
    self.nameLabel.text = _model.name;
    self.relationLabel.text = _model.relationName;
    self.telLabel.text = _model.mobile;
    self.memberSwitch.on = _model.memberNoticePermit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
