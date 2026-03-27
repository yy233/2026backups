//
//  ZYElectroniNewRealNameAuthenticationFailView.m
//  Community
//
//  Created by ZY on 2022/4/29.
//

#import "ZYElectroniNewRealNameAuthenticationFailView.h"

@interface ZYElectroniNewRealNameAuthenticationFailView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *againButtonBottomConstraint;

@property (weak, nonatomic) IBOutlet UIButton *againButton;

@end

@implementation ZYElectroniNewRealNameAuthenticationFailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.againButtonBottomConstraint.constant = 45 + button_bottom_height;
    [self.againButton addTarget:self action:@selector(againButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)againButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(againButtonEvent)]) {
        [self.delegate againButtonEvent];
    }
}

@end
