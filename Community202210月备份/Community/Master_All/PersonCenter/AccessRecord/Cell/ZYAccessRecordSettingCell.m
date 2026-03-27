//
//  ZYAccessRecordSettingCell.m
//  Community
//
//  Created by ZY on 2022/4/25.
//

#import "ZYAccessRecordSettingCell.h"

@interface ZYAccessRecordSettingCell ()

@property (weak, nonatomic) IBOutlet UIView *visitContentV;

@property (weak, nonatomic) IBOutlet UILabel *visitTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subVisitTitleLabel;

@property (weak, nonatomic) IBOutlet UISwitch *visitSwitch;

@property (weak, nonatomic) IBOutlet UIView *noticeContentV;

@property (weak, nonatomic) IBOutlet UILabel *noticeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subnoticeTitleLabel;

@property (weak, nonatomic) IBOutlet UISwitch *noticeSwitch;

@end

@implementation ZYAccessRecordSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.visitContentV
    .backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.visitTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.subVisitTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    [self.visitSwitch addTarget:self action:@selector(visitSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.noticeContentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.noticeTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.subnoticeTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    [self.noticeSwitch addTarget:self action:@selector(noticeSwitchChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYAccessRecordVisitPermitModel *)model {
    _model = model;
    
    self.visitSwitch.on = _model.visitPermit;
    self.noticeSwitch.on = _model.noticePermit;
}

#pragma mark - 处理点击事件
- (void)visitSwitchChanged:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(visitSwitchChangedEvent:)]) {
        [self.delegate visitSwitchChangedEvent:self.visitSwitch];
    }
}

- (void)noticeSwitchChanged:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(noticeSwitchChangedEvent:)]) {
        [self.delegate noticeSwitchChangedEvent:self.noticeSwitch];
    }
}

@end
