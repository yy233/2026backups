//
//  ZYIssueActivityVoicePopView.m
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import "ZYIssueActivityVoicePopView.h"

static CGFloat popViewDuration = 0.25;

@interface ZYIssueActivityVoicePopView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceBottomConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *voiceImageView;

@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZYIssueActivityVoicePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentHeightConstraint.constant = 275 + button_bottom_height;
    self.voiceBottomConstraint.constant = 36 + button_bottom_height;
}

- (void)dealloc {
    [self deallocVoiceTimer];
}

#pragma mark - 显示视图
- (void)showIssueActivityVoicePopView {
    UIWindow *window = [Tool toolGetKeyWindow];
    UIView *supView = window.rootViewController.view;
    if (!supView) {
        return;
    }
    [supView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview);
    }];
    self.alpha = 0.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 1.0;
    }];
    
    // 震动
    [self vibrationEffect];
    [self playImageAnimationWithRepeatCount:60];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createVoiceTimer];
    });
}

#pragma mark - 隐藏视图
- (void)hiddenIssueActivityVoicePopView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    self.alpha = 1.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 0.0;
    }];
    
    [self stopImageAnimation];
    [self deallocVoiceTimer];
}

#pragma mark - 处理点击事件
// 播放图片帧动画
- (void)playImageAnimationWithRepeatCount:(NSInteger)count {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i < 20; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"voice_animation%d", i]];
        [imageArray addObject:image];
    }
    // 设置图片的序列帧
    self.voiceImageView.animationImages = [imageArray copy];
    // 动画重复次数
    self.voiceImageView.animationRepeatCount = 0;
    // 动画执行的时长
    self.voiceImageView.animationDuration = 0.75;
    // 开始动画
    [self.voiceImageView startAnimating];
}

// 停止图片帧动画
- (void)stopImageAnimation {
    [self.voiceImageView stopAnimating];
    // 清空动画数组
    self.voiceImageView.animationImages = nil;
}

// 创建语音时长定时器
- (void)createVoiceTimer {
    if (!self.timer) {
        // 开启定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(voiceTimerBack:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

// 定时器回调
- (void)voiceTimerBack:(NSTimer *)timer {
    
    self.duration++;
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%lds", self.duration];
    if (self.duration >= 60) {
        [self deallocVoiceTimer];
        Y_NSNotificationCenter_PostNotice_NilObject_Name(@"VOICE_END_BACK")
    }
}

// 销毁定时器
- (void)deallocVoiceTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - 震动效果
- (void)vibrationEffect {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *impactor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [impactor impactOccurred];
    }
}

@end
