//
//  ZYRealNameAuthenticationPopView.m
//  Community
//
//  Created by ZY on 2022/4/28.
//

#import "ZYRealNameAuthenticationPopView.h"

static CGFloat popViewDuration = 0.25;

@interface ZYRealNameAuthenticationPopView ()

@property (weak, nonatomic) IBOutlet UIButton *noRealNameButton;

@property (weak, nonatomic) IBOutlet UIButton *realNameButton;

@end

@implementation ZYRealNameAuthenticationPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.noRealNameButton addTarget:self action:@selector(noRealNameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.realNameButton addTarget:self action:@selector(realNameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 显示视图
- (void)showRealNameAuthenticationPopView {
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
}

#pragma mark - 隐藏视图
- (void)hiddenRealNameAuthenticationPopView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    self.alpha = 1.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 0.0;
    }];
}

#pragma mark - 处理点击事件
- (void)noRealNameButtonClicked {
    [self hiddenRealNameAuthenticationPopView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(noRealNameButtonEvent)]) {
        [self.delegate noRealNameButtonEvent];
    }
}

- (void)realNameButtonClicked {
    [self hiddenRealNameAuthenticationPopView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(realNameButtonEvent)]) {
        [self.delegate realNameButtonEvent];
    }
}

@end
