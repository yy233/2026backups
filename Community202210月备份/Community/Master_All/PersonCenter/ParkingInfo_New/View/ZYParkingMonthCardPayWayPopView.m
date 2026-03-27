//
//  ZYParkingMonthCardPayWayPopView.m
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import "ZYParkingMonthCardPayWayPopView.h"

static CGFloat popViewDuration = 0.25;
#define kContentViewHeight (340+bottom_height)

@interface ZYParkingMonthCardPayWayPopView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIView *weixinView;

@property (weak, nonatomic) IBOutlet UILabel *weixinTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *weixinButton;

@property (weak, nonatomic) IBOutlet UIView *zhifubaoView;

@property (weak, nonatomic) IBOutlet UILabel *zhifubaoTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *zhifubaoButton;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation ZYParkingMonthCardPayWayPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.priceLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.unitLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.weixinTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.zhifubaoTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    self.contentViewHeightConstraint.constant = kContentViewHeight;
    self.contentViewBottomConstraint.constant = -kContentViewHeight;
    [self.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.weixinView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weixinViewTap)]];
    [self.zhifubaoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhifubaoViewTap)]];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewTap)]];
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTap)]];
    if (kPayMoneyTypeShow_HidenZFB == 1) {//2.4.0版支付宝的付钱还不能用
       self.zhifubaoView.hidden = YES;
    }
}

- (void)setType:(ZYSmallShop_Pay_Way_Type)type {
    _type = type;

    if (_type == ZYSmallShop_Pay_Way_Type_WeChat) {
        self.weixinButton.selected = YES;
        self.zhifubaoButton.selected = NO;
    }else if (_type == ZYSmallShop_Pay_Way_Type_Alipay) {
        self.weixinButton.selected = NO;
        self.zhifubaoButton.selected = YES;
    }
}

#pragma mark - 显示视图
- (void)showParkingMonthCardPayWayPopView {
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
- (void)hiddenParkingMonthCardPayWayPopView {
    self.alpha = 1.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 0.0;
        self.contentViewBottomConstraint.constant = -kContentViewHeight;
        [self layoutIfNeeded];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - 处理点击事件
- (void)closeButtonClicked {
    [self hiddenParkingMonthCardPayWayPopView];
}

- (void)okButtonClicked {
    if (self.delegete && [self.delegete respondsToSelector:@selector(okButtonEvent)]) {
        [self.delegete okButtonEvent];
    }
}

- (void)weixinViewTap {
    if (self.delegete && [self.delegete respondsToSelector:@selector(weixinViewEvent)]) {
        [self.delegete weixinViewEvent];
    }
}

- (void)zhifubaoViewTap {
    if (self.delegete && [self.delegete respondsToSelector:@selector(zhifubaoVieEvent)]) {
        [self.delegete zhifubaoVieEvent];
    }
}

- (void)popViewTap {
    [self hiddenParkingMonthCardPayWayPopView];
}

- (void)contentViewTap {
}

@end
