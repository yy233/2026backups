//
//  ZYFileReceiveEmailView.m
//  Community
//
//  Created by ZY on 2021/5/28.
//

#import "ZYFileReceiveEmailView.h"

@interface ZYFileReceiveEmailView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *decTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *decLabel;

@end

@implementation ZYFileReceiveEmailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.TFView.layer.borderWidth = 0.5;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.TFView.layer.borderColor = Y_RGBA(213, 216, 224, 1).CGColor;
    }else {
        self.TFView.layer.borderColor = Y_RGBA(62, 81, 119, 1).CGColor;
    }
    CGSize size = CGSizeMake(268, 44);
    self.sendButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
    self.decTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.decLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    
    self.emailTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarE = class_getInstanceVariable([self.emailTF class], "_placeholderLabel");
    id placeholderLabelE = object_getIvar(self.emailTF, ivarE);
    [placeholderLabelE performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
}

@end
