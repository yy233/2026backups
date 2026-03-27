//
//  ZYContrectManageTopView.m
//  Community
//
//  Created by ZY on 2021/8/30.
//

#import "ZYContrectManageTopView.h"

@interface ZYContrectManageTopView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ZYContrectManageTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor_Lblack;
    [self.backButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"ic_navi_return"] forState:UIControlStateNormal];
    [self.searchButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"search-all"] forState:UIControlStateNormal];
}

@end
