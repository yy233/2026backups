//
//  ZYElectronicSignPasswordSettingCell.m
//  Community
//
//  Created by ZY on 2021/7/7.
//

#import "ZYElectronicSignPasswordSettingCell.h"

@interface ZYElectronicSignPasswordSettingCell ()

@property (weak, nonatomic) IBOutlet UIView *line1View;

@property (weak, nonatomic) IBOutlet UIView *line2View;

@end

@implementation ZYElectronicSignPasswordSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.pwTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarP = class_getInstanceVariable([self.pwTF class], "_placeholderLabel");
    id placeholderLabelP = object_getIvar(self.pwTF, ivarP);
    [placeholderLabelP performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    UIButton *pwTFClearButton = [self.pwTF valueForKey:@"_clearButton"];
    [pwTFClearButton setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];
    
    self.verifyPWTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarV = class_getInstanceVariable([self.verifyPWTF class], "_placeholderLabel");
    id placeholderLabelV = object_getIvar(self.verifyPWTF, ivarV);
    [placeholderLabelV performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    UIButton *verifyPWTFClearButton = [self.verifyPWTF valueForKey:@"_clearButton"];
    [verifyPWTFClearButton setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.line1View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line2View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    CGSize size = CGSizeMake(kScreenW - 60, 50);
    self.okButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
