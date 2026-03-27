//
//  ZYHouseRepairIssueRecordPopView.m
//  Community
//
//  Created by ZY on 2022/4/11.
//

#import "ZYHouseRepairIssueRecordPopView.h"

static CGFloat popViewDuration = 0.25;
#define kContentViewHeight (210+bottom_height)

@interface ZYHouseRepairIssueRecordPopView()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIButton *downButton;

@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *voiceImageView;

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZYHouseRepairIssueRecordPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.duration = 60;
    self.contentHeightConstraint.constant = kContentViewHeight;
    self.contentViewBottomConstraint.constant = -kContentViewHeight;
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.voiceTimeLabel.text = @"60s";
    self.voiceTimeLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.bottomLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    [self.downButton addTarget:self action:@selector(downButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    // 添加按钮按下事件
    [self.voiceButton addTarget:self action:@selector(voiceButtonTouchDownClicked) forControlEvents:UIControlEventTouchDown];
    // 添加按钮松开事件
    [self.voiceButton addTarget:self action:@selector(voiceButtonTouchUpClicked) forControlEvents:(UIControlEventTouchUpInside|UIControlEventTouchUpOutside)];
}

#pragma mark - 显示视图
- (void)showHouseRepairIssueRecordPopView {
    UIWindow *window = [Tool toolGetKeyWindow];
    UIView *supView = window.rootViewController.view;
    if (!supView) {
        return;
    }
    self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [supView addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 1.0;
        self.contentViewBottomConstraint.constant = 0;
        [self layoutIfNeeded];
    }];
}

#pragma mark - 隐藏视图
- (void)hiddenHouseRepairIssueRecordPopView {
    self.alpha = 1.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 0.0;
        self.contentViewBottomConstraint.constant = -kContentViewHeight;
        [self layoutIfNeeded];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
    [self stopImageAnimation];
    [self deallocVoiceTimer];
}

#pragma mark - 处理点击事件
- (void)downButtonClicked {
    [self hiddenHouseRepairIssueRecordPopView];
}

// 按下事件
- (void)voiceButtonTouchDownClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceButtonTouchDownEvent)]) {
        [self.delegate voiceButtonTouchDownEvent];
        self.voiceTimeLabel.hidden = NO;
        self.voiceImageView.hidden = NO;
        self.bottomLabel.hidden = YES;
        [self playImageAnimationWithRepeatCount:60];
        // 震动
        [self vibrationEffect];
        [self createVoiceTimer];
    }
}

// 松开事件
- (void)voiceButtonTouchUpClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceButtonTouchUpEvent)]) {
        [self.delegate voiceButtonTouchUpEvent];
    }
}

#pragma mark - 帧动画相关方法
// 播放图片帧动画
- (void)playImageAnimationWithRepeatCount:(NSInteger)count {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i < 20; i++) {
        UIImage *image;
        if([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"voice_animation%d", i]];
        }else {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"voice_animation_Dark%d", i]];
        }
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
    self.duration--;
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%lds", self.duration];
    if (self.duration <= 0) {
        [self deallocVoiceTimer];
        Y_NSNotificationCenter_PostNotice_NilObject_Name(@"REPAIR_VOICE_END_BACK")
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
