//
//  ZYAlreadyElectronicRealNameAuthenticationView.m
//  Community
//
//  Created by ZY on 2021/9/4.
//

#import "ZYAlreadyElectronicRealNameAuthenticationView.h"

@interface ZYAlreadyElectronicRealNameAuthenticationView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation ZYAlreadyElectronicRealNameAuthenticationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    CGSize size = CGSizeMake(kScreenW - 80, 50);
    self.backButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
}

@end
