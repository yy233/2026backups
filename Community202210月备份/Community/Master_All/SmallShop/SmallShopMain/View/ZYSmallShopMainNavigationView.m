//
//  ZYSmallShopMainNavigationView.m
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import "ZYSmallShopMainNavigationView.h"

@interface ZYSmallShopMainNavigationView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTopConstraint;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation ZYSmallShopMainNavigationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topViewTopConstraint.constant = status_height;
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
// 返回
- (void)backButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonEvent)]) {
        [self.delegate backButtonEvent];
    }
}

@end
