//
//  ZYSmallShopBaseRoundBottomViewDelegate.m
//  EShops
//
//  Created by ZY on 2022/2/11.
//

#import "ZYSmallShopBaseRoundBottomView.h"

@interface ZYSmallShopBaseRoundBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation ZYSmallShopBaseRoundBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBtnText:(NSString *)btnText {
    _btnText = btnText;
    
    [self.okButton setTitle:_btnText forState:UIControlStateNormal];
}

#pragma mark - 处理点击事件
- (void)okButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(okButtonEvent)]) {
        [self.delegate okButtonEvent];
    }
}

@end
