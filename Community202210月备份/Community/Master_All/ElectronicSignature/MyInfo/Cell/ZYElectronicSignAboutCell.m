//
//  ZYElectronicSignAboutCell.m
//  Community
//
//  Created by ZY on 2021/5/25.
//

#import "ZYElectronicSignAboutCell.h"

@interface ZYElectronicSignAboutCell ()

@property (weak, nonatomic) IBOutlet UILabel *content1Label;

@property (weak, nonatomic) IBOutlet UILabel *content2Label;

@end

@implementation ZYElectronicSignAboutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.content1Label.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.content2Label.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    CGSize size = CGSizeMake(kScreenW - 176, 50);
    self.okButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
