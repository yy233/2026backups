//
//  ZYChooseTemporaryTimePopView.m
//  Community
//
//  Created by ZY on 2021/10/26.
//

#import "ZYChooseTemporaryTimePopView.h"

static CGFloat popViewDuration = 0.25;

@interface ZYChooseTemporaryTimePopView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *thirtyMinutesButton;

@property (weak, nonatomic) IBOutlet UIButton *sixtyMinutesButton;

@property (weak, nonatomic) IBOutlet UIButton *ninetyMinutesButton;

@end

@implementation ZYChooseTemporaryTimePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    self.contentView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    [self.thirtyMinutesButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    [self.sixtyMinutesButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    [self.ninetyMinutesButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    
    [self.thirtyMinutesButton addTarget:self action:@selector(thirtyMinutesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.sixtyMinutesButton addTarget:self action:@selector(sixtyMinutesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.ninetyMinutesButton addTarget:self action:@selector(ninetyMinutesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTemporaryTimePopViewTap)]];
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTap)]];
}

#pragma mark - 显示视图
- (void)showChooseTemporaryTimePopView {
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
- (void)hiddenChooseTemporaryTimePopView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    self.alpha = 1.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 0.0;
    }];
}

#pragma mark - 处理点击事件
- (void)thirtyMinutesButtonClicked {
    [self hiddenChooseTemporaryTimePopView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(thirtyMinutesButtonEvent)]) {
        [self.delegate thirtyMinutesButtonEvent];
    }
}

- (void)sixtyMinutesButtonClicked {
    [self hiddenChooseTemporaryTimePopView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sixtyMinutesButtonEvent)]) {
        [self.delegate sixtyMinutesButtonEvent];
    }
}

- (void)ninetyMinutesButtonClicked {
    [self hiddenChooseTemporaryTimePopView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ninetyMinutesButtonEvent)]) {
        [self.delegate ninetyMinutesButtonEvent];
    }
}

- (void)chooseTemporaryTimePopViewTap {
    
    [self hiddenChooseTemporaryTimePopView];
}

- (void)contentViewTap {
}

@end
