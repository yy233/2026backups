//
//  ZYLifeCostHelpCenterSearchView.m
//  Community
//
//  Created by ZY on 2022/1/4.
//

#import "ZYLifeCostHelpCenterSearchView.h"

@interface ZYLifeCostHelpCenterSearchView ()

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation ZYLifeCostHelpCenterSearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.searchView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
    [self.searchButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarS = class_getInstanceVariable([self.searchTF class], "_placeholderLabel");
    id placeholderLabelS = object_getIvar(self.searchTF, ivarS);
    [placeholderLabelS performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    UIButton *clearButton = [self.searchTF valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)searchButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchButtonEvent)]) {
        [self.delegate searchButtonEvent];
    }
}

@end
