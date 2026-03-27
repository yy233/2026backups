//
//  ZYCarInvitePaySuccessView.m
//  Community
//
//  Created by ZY on 2022/5/18.
//

#import "ZYCarInvitePaySuccessView.h"

@interface ZYCarInvitePaySuccessView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subLabel1;

@property (weak, nonatomic) IBOutlet UILabel *subLabel2;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation ZYCarInvitePaySuccessView

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
    self.subLabel1.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.subLabel2.textColor = [ZYThemeManager shareManager].titleThemeColor;
    [self.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)okButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(okButtonEvent)]) {
        [self.delegate okButtonEvent];
    }
}

@end
