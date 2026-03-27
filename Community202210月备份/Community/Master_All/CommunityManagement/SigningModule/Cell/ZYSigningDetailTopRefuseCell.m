//
//  ZYSigningDetailTopRefuseCell.m
//  Community
//
//  Created by ZY on 2021/8/19.
//

#import "ZYSigningDetailTopRefuseCell.h"

@interface ZYSigningDetailTopRefuseCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYSigningDetailTopRefuseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
