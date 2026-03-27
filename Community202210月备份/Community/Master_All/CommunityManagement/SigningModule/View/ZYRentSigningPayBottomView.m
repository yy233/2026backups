//
//  ZYRentSigningPayBottomView.m
//  Community
//
//  Created by ZY on 2021/9/14.
//

#import "ZYRentSigningPayBottomView.h"

@interface ZYRentSigningPayBottomView ()

@end

@implementation ZYRentSigningPayBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGSize size = CGSizeMake(kScreenW - 32, 50);
    self.okButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
    [self.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击事件
- (void)okButtonClicked {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(okButtonEvent)]) {
        [self.delegate okButtonEvent];
    }
}

@end
