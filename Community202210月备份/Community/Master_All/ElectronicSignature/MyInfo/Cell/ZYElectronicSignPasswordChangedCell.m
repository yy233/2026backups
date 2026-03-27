//
//  ZYElectronicSignPasswordChangedCell.m
//  Community
//
//  Created by ZY on 2021/7/7.
//

#import "ZYElectronicSignPasswordChangedCell.h"

@interface ZYElectronicSignPasswordChangedCell ()

@property (weak, nonatomic) IBOutlet UIView *line1View;

@property (weak, nonatomic) IBOutlet UIView *line2View;

@property (weak, nonatomic) IBOutlet UIView *line3View;

@end

@implementation ZYElectronicSignPasswordChangedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.oldPWTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarO = class_getInstanceVariable([self.oldPWTF class], "_placeholderLabel");
    id placeholderLabelO = object_getIvar(self.oldPWTF, ivarO);
    [placeholderLabelO performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    UIButton *oldPWTFClearButton = [self.oldPWTF valueForKey:@"_clearButton"];
    [oldPWTFClearButton setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];
    
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
    self.line3View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    CGSize size = CGSizeMake(kScreenW - 60, 50);
    self.okButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
