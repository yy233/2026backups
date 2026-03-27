//
//  ZYParkingMonthCardBottomView.m
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import "ZYParkingMonthCardBottomView.h"

@interface ZYParkingMonthCardBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end

@implementation ZYParkingMonthCardBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buyButton.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(kScreenW - 32, 50) direction:IHGradientChangeDirectionLevel startColor:[UIColor zy_colorWithHexString:@"#0C2E61"] endColor:[UIColor zy_colorWithHexString:@"#466695"]];
    [self.buyButton addTarget:self action:@selector(buyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)buyButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyButtonEvent)]) {
        [self.delegate buyButtonEvent];
    }
}

@end
