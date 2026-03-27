//
//  ZYSmallShopPayBaseBottomView.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopPayBaseBottomView.h"

@interface ZYSmallShopPayBaseBottomView ()

@end

@implementation ZYSmallShopPayBaseBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.payButton addTarget:self action:@selector(payButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
// 立即购买
- (void)payButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payButtonEvent)]) {
        [self.delegate payButtonEvent];
    }
}

@end
