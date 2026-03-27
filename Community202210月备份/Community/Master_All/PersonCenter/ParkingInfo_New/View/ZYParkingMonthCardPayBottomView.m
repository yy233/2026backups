//
//  ZYParkingMonthCardPayBottomView.m
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import "ZYParkingMonthCardPayBottomView.h"

@interface ZYParkingMonthCardPayBottomView ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@end

@implementation ZYParkingMonthCardPayBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.payButton addTarget:self action:@selector(payButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)payButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payButtonEvent)]) {
        [self.delegate payButtonEvent];
    }
}

@end
