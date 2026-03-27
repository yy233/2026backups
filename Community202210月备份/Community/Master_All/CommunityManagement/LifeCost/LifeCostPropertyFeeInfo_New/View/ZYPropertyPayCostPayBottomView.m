//
//  ZYPropertyPayCostPayBottomView.m
//  Community
//
//  Created by ZY on 2022/5/19.
//

#import "ZYPropertyPayCostPayBottomView.h"

@interface ZYPropertyPayCostPayBottomView ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end

@implementation ZYPropertyPayCostPayBottomView

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
    self.titleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    [self.payButton addTarget:self action:@selector(payButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)payButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payButtonEvent)]) {
        [self.delegate payButtonEvent];
    }
}

@end
