//
//  ZYContractingPartyInformationSearchTopView.m
//  Community
//
//  Created by ZY on 2021/5/21.
//

#import "ZYContractingPartyInformationSearchTopView.h"

@implementation ZYContractingPartyInformationSearchTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.backgroundColor = [ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534;
    self.searchView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
    [self.backButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"ic_navi_return"] forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    self.searchTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarS = class_getInstanceVariable([self.searchTF class], "_placeholderLabel");
    id placeholderLabelS = object_getIvar(self.searchTF, ivarS);
    [placeholderLabelS performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    UIButton *clearButton = [self.searchTF valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
