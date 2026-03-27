//
//  ZYMoulageHelperVcHeaderView.m
//  Community
//
//  Created by ZY on 2021/4/15.
//

#import "ZYMoulageHelperVcHeaderView.h"

@interface ZYMoulageHelperVcHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *filtrateLabel;


@end

@implementation ZYMoulageHelperVcHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.filtrateLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.systemTemplateButton.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.systemTemplateButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.personalTemplateButton.backgroundColor = Y_RGBA(190, 213, 253, 1);
        [self.personalTemplateButton setTitleColor:Y_RGBA(58, 70, 108, 1) forState:UIControlStateNormal];
    }else {
        self.personalTemplateButton.backgroundColor = Y_RGBA(0, 21, 52, 1);
        [self.personalTemplateButton setTitleColor:Y_RGBA(148, 157, 170, 1) forState:UIControlStateNormal];
    }
}

@end
