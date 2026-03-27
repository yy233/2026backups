//
//  ZYSigningDetailIntroCell.m
//  Community
//
//  Created by ZY on 2021/8/19.
//

#import "ZYSigningDetailIntroCell.h"

@interface ZYSigningDetailIntroCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitle1Label;

@property (weak, nonatomic) IBOutlet UILabel *subTitle2Label;

@property (weak, nonatomic) IBOutlet UILabel *subTitle3Label;

@end

@implementation ZYSigningDetailIntroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.subTitle1Label.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.subTitle2Label.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.subTitle3Label.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
