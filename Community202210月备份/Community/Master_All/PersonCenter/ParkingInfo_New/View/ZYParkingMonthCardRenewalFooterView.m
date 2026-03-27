//
//  ZYParkingMonthCardRenewalFooterView.m
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import "ZYParkingMonthCardRenewalFooterView.h"

@interface ZYParkingMonthCardRenewalFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subLabel1;

@property (weak, nonatomic) IBOutlet UILabel *subLabel2;

@end

@implementation ZYParkingMonthCardRenewalFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.subLabel1.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.subLabel2.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

@end
