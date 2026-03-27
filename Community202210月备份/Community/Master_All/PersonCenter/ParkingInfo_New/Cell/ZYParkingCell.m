//
//  ZYParkingCell.m
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import "ZYParkingCell.h"

@interface ZYParkingCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@end

@implementation ZYParkingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
