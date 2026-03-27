//
//  ZYSmallShopGoodsDetailBottomView.m
//  Community
//
//  Created by ZY on 2022/3/2.
//

#import "ZYSmallShopGoodsDetailBottomView.h"

@interface ZYSmallShopGoodsDetailBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end

@implementation ZYSmallShopGoodsDetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.chatButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:1];
    [self.chatButton addTarget:self action:@selector(chatButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.shoppingCartButton addTarget:self action:@selector(shoppingCartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.buyButton addTarget:self action:@selector(buyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
// 联系商家
- (void)chatButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatButtonEvent)]) {
        [self.delegate chatButtonEvent];
    }
}

// 加入购物车
- (void)shoppingCartButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shoppingCartButtonEvent)]) {
        [self.delegate shoppingCartButtonEvent];
    }
}

// 立即购买
- (void)buyButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyButtonEvent)]) {
        [self.delegate buyButtonEvent];
    }
}

@end
