//
//  ZYMyPensionSettingCell.m
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import "ZYMyPensionSettingCell.h"

@interface ZYMyPensionSettingCell ()

@property (weak, nonatomic) IBOutlet UISwitch *remindSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *shakeSwitch;

@end

@implementation ZYMyPensionSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.remindSwitch addTarget:self action:@selector(remindSwitchChanded:) forControlEvents:UIControlEventValueChanged];
    [self.shakeSwitch addTarget:self action:@selector(shakeSwitchChanded:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)remindSwitchChanded:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(remindSwitchEvent:)]) {
        [self.delegate remindSwitchEvent:sender];
    }
}

- (void)shakeSwitchChanded:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shakeSwitchEvent:)]) {
        [self.delegate shakeSwitchEvent:sender];
    }
}

@end
