//
//  OrderAdviceSuccessView.m
//  Community
//
//  Created by 余莹 on 2022/3/3.
//

#import "OrderAdviceSuccessView.h"

@interface OrderAdviceSuccessView ()
 
@end

@implementation OrderAdviceSuccessView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.centerBtn];
        [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_centerBtn.superview);
            make.centerY.equalTo(_centerBtn.superview).offset(-10);
            make.width.height.offset(210);
        }];
        [self.centerBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }
    return self;
}

- (UIButton *)centerBtn{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerBtn.userInteractionEnabled = NO;
        [_centerBtn newAnBtnWithImg:[UIImage imageNamed:@"cc_complete_icon"]];
        [_centerBtn newAnBtnWithTextStr:@"感谢您的反馈！"];
        [_centerBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0x2B2C2F)];
        [_centerBtn newAnBtnWithFont: [UIFont boldSystemFontOfSize:18.0]];
    }
    return _centerBtn;
}
@end
