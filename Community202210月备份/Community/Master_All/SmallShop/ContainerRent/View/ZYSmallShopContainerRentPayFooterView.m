//
//  ZYSmallShopContainerRentPayFooterView.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentPayFooterView.h"

@interface ZYSmallShopContainerRentPayFooterView ()

@end

@implementation ZYSmallShopContainerRentPayFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.agreementButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    [self.agreementButton addTarget:self action:@selector(agreementButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
// 协议
- (void)agreementButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreementButtonEvent)]) {
        [self.delegate agreementButtonEvent];
    }
}

@end
