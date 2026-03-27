//
//  ZYParkingTemporaryDetaiBottomView.m
//  Community
//
//  Created by ZY on 2021/10/26.
//

#import "ZYParkingTemporaryDetaiBottomView.h"

@interface ZYParkingTemporaryDetaiBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end

@implementation ZYParkingTemporaryDetaiBottomView

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

- (void)payButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payButtonEvent)]) {
        [self.delegate payButtonEvent];
    }
}

@end
