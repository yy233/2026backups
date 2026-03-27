//
//  ZYMoneyOfThridBangDingWeiXinEditBottomCell.m
//  Community
//
//  Created by ZY on 2021/10/19.
//

#import "ZYMoneyOfThridBangDingWeiXinEditBottomCell.h"

@interface ZYMoneyOfThridBangDingWeiXinEditBottomCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation ZYMoneyOfThridBangDingWeiXinEditBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.subTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
