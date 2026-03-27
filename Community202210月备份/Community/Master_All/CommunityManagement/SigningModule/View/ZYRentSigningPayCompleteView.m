//
//  ZYRentSigningPayCompleteView.m
//  Community
//
//  Created by ZY on 2021/9/14.
//

#import "ZYRentSigningPayCompleteView.h"

@interface ZYRentSigningPayCompleteView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation ZYRentSigningPayCompleteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.subTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.priceLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

@end
