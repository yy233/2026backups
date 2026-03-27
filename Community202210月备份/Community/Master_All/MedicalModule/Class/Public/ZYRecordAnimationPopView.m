//
//  ZYRecordAnimationPopView.m
//  Community
//
//  Created by ZY on 2021/12/17.
//

#import "ZYRecordAnimationPopView.h"

static CGFloat popViewDuration = 0.25;

@interface ZYRecordAnimationPopView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIImageView *recordImageView;

@end

@implementation ZYRecordAnimationPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.popViewHeightConstraint.constant = 295 + button_bottom_height;
    self.labelBottomConstraint.constant = 22 + button_bottom_height;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewTap)]];
    [self.contentV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentVTap)]];
    self.closeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [self.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 显示视图
- (void)showRecordAnimationPopView {
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
    
    [self recordImageAnimation];
}

#pragma mark - 隐藏视图
- (void)hiddenRecordAnimationPopView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    self.alpha = 1.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 0.0;
    }];
    
    [self stopImageAnimation];
}

#pragma mark - 图片帧动画
// 播放图片帧动画
- (void)recordImageAnimation {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 2; i < 25; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"yl_record_animation%d", i]];
        [imageArray addObject:image];
    }
    // 设置图片的序列帧
    self.recordImageView.animationImages = [imageArray copy];
    // 动画重复次数
    self.recordImageView.animationRepeatCount = 0;
    // 动画执行的时长
    self.recordImageView.animationDuration = 1.5;
    // 开始动画
    [self.recordImageView startAnimating];
}

// 停止图片帧动画
- (void)stopImageAnimation {
    [self.recordImageView stopAnimating];
    // 清空动画数组
    self.recordImageView.animationImages = nil;
}

#pragma mark - 处理点击事件
- (void)popViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popViewEvent)]) {
        [self.delegate popViewEvent];
    }
}

- (void)contentVTap {
}

- (void)closeButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonEvent)]) {
        [self.delegate closeButtonEvent];
    }
}

@end
