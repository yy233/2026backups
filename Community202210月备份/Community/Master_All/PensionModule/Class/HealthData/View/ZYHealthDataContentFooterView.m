//
//  ZYHealthDataContentFooterView.m
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import "ZYHealthDataContentFooterView.h"

@interface ZYHealthDataContentFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *bindButton;

@end

@implementation ZYHealthDataContentFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bindButton.layer.borderWidth = 1;
    self.bindButton.layer.borderColor = Y_RGBA(54, 200, 193, 1).CGColor;
    self.bindButton.layer.cornerRadius = 5;
    self.bindButton.layer.masksToBounds = YES;
    [self.bindButton addTarget:self action:@selector(bindButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)bindButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bindButtonEvent)]) {
        [self.delegate bindButtonEvent];
    }
}

@end
