//
//  ZYSmallShopOrderTimeView.m
//  Community
//
//  Created by ZY on 2022/3/18.
//

#import "ZYSmallShopOrderTimeView.h"

@interface ZYSmallShopOrderTimeView ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSTimer *timer;

// 倒计时终点
@property (nonatomic, assign) NSInteger countdownFinishTime;

@end

@implementation ZYSmallShopOrderTimeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.timeLabel.text = [NSDate br_stringFromDate:[NSDate date] dateFormat:@"HH:mm:ss"];
    // 开启定时器
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(notiTimerBack) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

// 定时器回调
- (void)notiTimerBack {
    self.timeLabel.text = [NSDate br_stringFromDate:[NSDate date] dateFormat:@"HH:mm:ss"];
}

@end
