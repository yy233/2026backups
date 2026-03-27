//
//  ZYLifeCostAddGroupTopView.m
//  Community
//
//  Created by ZY on 2022/1/8.
//

#import "ZYLifeCostAddGroupTopView.h"

@interface ZYLifeCostAddGroupTopView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYLifeCostAddGroupTopView

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
    self.nameTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarS = class_getInstanceVariable([self.nameTF class], "_placeholderLabel");
    id placeholderLabelS = object_getIvar(self.nameTF, ivarS);
    [placeholderLabelS performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    UIButton *clearButton = [self.nameTF valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

@end
