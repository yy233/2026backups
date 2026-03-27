//
//  ZYLifeCostHelpCenterTitleView.m
//  Community
//
//  Created by ZY on 2022/1/5.
//

#import "ZYLifeCostHelpCenterTitleView.h"

@interface ZYLifeCostHelpCenterTitleView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYLifeCostHelpCenterTitleView

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
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

@end
