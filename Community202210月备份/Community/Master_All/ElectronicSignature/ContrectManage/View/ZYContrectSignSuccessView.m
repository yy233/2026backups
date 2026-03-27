//
//  ZYContrectSignSuccessView.m
//  Community
//
//  Created by ZY on 2021/9/22.
//

#import "ZYContrectSignSuccessView.h"

@interface ZYContrectSignSuccessView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYContrectSignSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topViewConstraint.constant = 100 + status_height;
    self.contentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    CGSize size = CGSizeMake(200, 50);
    self.okButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
}

@end
