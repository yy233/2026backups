//
//  ZYSmallShopContainerRentDetailBottomView.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentDetailBottomView.h"

@interface ZYSmallShopContainerRentDetailBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (weak, nonatomic) IBOutlet UIButton *rentButton;

@end

@implementation ZYSmallShopContainerRentDetailBottomView

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
    [self.rentButton addTarget:self action:@selector(rentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
// 联系商家
- (void)chatButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatButtonEvent)]) {
        [self.delegate chatButtonEvent];
    }
}

// 立即租用
- (void)rentButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rentButtonEvent)]) {
        [self.delegate rentButtonEvent];
    }
}

@end
