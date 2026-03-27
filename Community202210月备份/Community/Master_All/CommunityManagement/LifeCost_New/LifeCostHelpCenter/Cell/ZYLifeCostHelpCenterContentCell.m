//
//  ZYLifeCostHelpCenterContentCell.m
//  Community
//
//  Created by ZY on 2022/1/4.
//

#import "ZYLifeCostHelpCenterContentCell.h"

@interface ZYLifeCostHelpCenterContentCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYLifeCostHelpCenterContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentLabelWidthConstraint.constant = kScreenW - 32;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.desLabel.textColor = [ZYThemeManager shareManager].threeLevelTitleThemeColor_Dc5c9d4;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
