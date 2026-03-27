//
//  ZYReportAboutRepairApplyVoiceCell.m
//  Community
//
//  Created by ZY on 2022/3/7.
//

#import "ZYReportAboutRepairApplyVoiceCell.h"

@interface ZYReportAboutRepairApplyVoiceCell ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIImageView *voiceImageView;

@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger duration;

@end

@implementation ZYReportAboutRepairApplyVoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.playButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -8, -10, -8);
    self.closeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
    [self.playButton addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)isUseOnDetailVc{
    // (_voiceImageView.superview.superview) 才是 self 
    [self.voiceImageView.superview mas_remakeConstraints:^(MASConstraintMaker *make) {//68-40 28*0.5  14t14b
        make.edges.equalTo(_voiceImageView.superview.superview).insets(UIEdgeInsetsMake(14, 26, 14, 26));
    }];
    self.closeButton.hidden = YES;
}

// 设置数据model
- (void)setModel:(ZYReportAboutRepairApplyUploadModel *)model {
    _model = model;

    if (_model.isPlay) {
        [self.playButton setImage:[UIImage imageNamed:@"yl_stop"] forState:UIControlStateNormal];
        [self createVoiceTimer];
        [self playImageAnimationWithRepeatCount:_model.voiceLength];
    }else {
        [self.playButton setImage:[UIImage imageNamed:@"yl_play"] forState:UIControlStateNormal];
        [self deallocVoiceTimer];
        [self stopImageAnimation];
    }
    self.duration = _model.voiceLength;
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld″", _model.voiceLength];
}

- (void)dealloc {
    [self deallocVoiceTimer];
}

#pragma mark - 处理点击事件
- (void)playButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playButtonEvent)]) {
        [self.delegate playButtonEvent];
    }
}

- (void)closeButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonEvent)]) {
        [self.delegate closeButtonEvent];
    }
}

// 播放图片帧动画
- (void)playImageAnimationWithRepeatCount:(NSInteger)count {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i <= 30; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"yl_record_item%d", i]];
        [imageArray addObject:image];
    }
    // 设置图片的序列帧
    self.voiceImageView.animationImages = [imageArray copy];
    // 动画重复次数
    self.voiceImageView.animationRepeatCount = count;
    // 动画执行的时长
    self.voiceImageView.animationDuration = 1.0;
    // 开始动画
    [self.voiceImageView startAnimating];
}

// 停止图片帧动画
- (void)stopImageAnimation {
    if (self.voiceImageView.isAnimating) {
        [self.voiceImageView stopAnimating];
        // 清空动画数组
        self.voiceImageView.animationImages = nil;
    }
}

// 创建语音时长定时器
- (void)createVoiceTimer {
    // 开启定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(voiceTimerBack:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 定时器回调
- (void)voiceTimerBack:(NSTimer *)timer {
    self.duration--;
    if (self.duration >= 0) {
        self.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld″", self.duration];
        if (self.duration == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self deallocVoiceTimer];
                [self.playButton setImage:[UIImage imageNamed:@"yl_play"] forState:UIControlStateNormal];
                self.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld″", self.model.voiceLength];
                self.voicePlayCompleteBlock(self.model);
            });
        }
    }else {
        [self deallocVoiceTimer];
        [self.playButton setImage:[UIImage imageNamed:@"yl_play"] forState:UIControlStateNormal];
        self.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld″", self.model.voiceLength];
        self.voicePlayCompleteBlock(self.model);
    }
}

// 销毁定时器
- (void)deallocVoiceTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
