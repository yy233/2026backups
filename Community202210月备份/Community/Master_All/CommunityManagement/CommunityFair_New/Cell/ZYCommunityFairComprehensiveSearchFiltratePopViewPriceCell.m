//
//  ZYCommunityFairComprehensiveSearchFiltratePopViewPriceCell.m
//  Community
//
//  Created by ZY on 2022/6/11.
//

#import "ZYCommunityFairComprehensiveSearchFiltratePopViewPriceCell.h"

@interface ZYCommunityFairComprehensiveSearchFiltratePopViewPriceCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *minView;

@property (weak, nonatomic) IBOutlet UIView *maxView;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYCommunityFairComprehensiveSearchFiltratePopViewPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.minView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
    self.maxView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
    self.minTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarMin = class_getInstanceVariable([self.minTF class], "_placeholderLabel");
    id placeholderLabelMin = object_getIvar(self.minTF, ivarMin);
    [placeholderLabelMin performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    Ivar ivarMax = class_getInstanceVariable([self.maxTF class], "_placeholderLabel");
    id placeholderLabelMax = object_getIvar(self.maxTF, ivarMax);
    [placeholderLabelMax performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
