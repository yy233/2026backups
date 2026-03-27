//
//  ZYActivityApplyDetatilBottomView.m
//  Community
//
//  Created by ZY on 2021/8/2.
//

#import "ZYActivityApplyDetatilBottomView.h"

@interface ZYActivityApplyDetatilBottomView ()

@property (weak, nonatomic) IBOutlet UIView *signView;

@property (weak, nonatomic) IBOutlet UIView *cancelView;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYActivityApplyDetatilBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.applyView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_L2672f9;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.signView.backgroundColor = [UIColor zy_colorWithHexString:@"#F8F8F8"];
    }else {
        self.signView.backgroundColor = [UIColor zy_colorWithHexString:@"#112957"];
    }
    [self.appliedButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

@end
