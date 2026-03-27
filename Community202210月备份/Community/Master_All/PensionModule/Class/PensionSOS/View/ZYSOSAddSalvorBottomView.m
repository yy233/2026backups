//
//  ZYSOSAddSalvorBottomView.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYSOSAddSalvorBottomView.h"

@interface ZYSOSAddSalvorBottomView ()


@property (weak, nonatomic) IBOutlet UIButton *inputButton;

@end

@implementation ZYSOSAddSalvorBottomView

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
    [self.inputButton addTarget:self action:@selector(inputButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)okButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(okButtonEvent)]) {
        [self.delegate okButtonEvent];
    }
}

- (void)inputButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputButtonEvent)]) {
        [self.delegate inputButtonEvent];
    }
}

@end
