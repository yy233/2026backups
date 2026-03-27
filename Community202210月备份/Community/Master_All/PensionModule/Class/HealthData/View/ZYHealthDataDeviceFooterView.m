//
//  ZYHealthDataDeviceFooterView.m
//  Community
//
//  Created by ZY on 2021/11/9.
//

#import "ZYHealthDataDeviceFooterView.h"

@interface ZYHealthDataDeviceFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end

@implementation ZYHealthDataDeviceFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.goButton addTarget:self action:@selector(goButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)goButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goButtonEvent)]) {
        [self.delegate goButtonEvent];
    }
}

@end
