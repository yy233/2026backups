//
//  ZYHealthDataDeviceHeaderView.m
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import "ZYHealthDataDeviceHeaderView.h"

@interface ZYHealthDataDeviceHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *deviceManagerButton;

@end

@implementation ZYHealthDataDeviceHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)devSectonHeaderViewShowThisRightBtnBool:(BOOL)isShow{
    self.deviceManagerButton.hidden = !isShow;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.deviceManagerButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.deviceManagerButton addTarget:self action:@selector(deviceManagerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)deviceManagerButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deviceManagerButtonEvent)]) {
        [self.delegate deviceManagerButtonEvent];
    }
}

@end
