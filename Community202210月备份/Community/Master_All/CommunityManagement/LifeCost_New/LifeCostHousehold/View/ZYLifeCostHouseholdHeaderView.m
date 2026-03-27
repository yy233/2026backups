//
//  ZYLifeCostHouseholdHeaderView.m
//  Community
//
//  Created by ZY on 2022/1/6.
//

#import "ZYLifeCostHouseholdHeaderView.h"

@implementation ZYLifeCostHouseholdHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, 50) radius:7.5 corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        [self.moreButton setImage:[UIImage imageNamed:@"gengduo_BlackColor"] forState:UIControlStateNormal];
    }else {
        [self.moreButton setImage:[UIImage imageNamed:@"gengduo_Dark"] forState:UIControlStateNormal];
    }
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

@end
