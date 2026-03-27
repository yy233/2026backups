//
//  ZYDisclaimerCell.m
//  Community
//
//  Created by ZY on 2021/9/29.
//

#import "ZYDisclaimerCell.h"

@interface ZYDisclaimerCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYDisclaimerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
