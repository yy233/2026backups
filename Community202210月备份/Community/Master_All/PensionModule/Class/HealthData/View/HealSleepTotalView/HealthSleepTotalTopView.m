//
//  HealthSleepTotalTopView.m
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import "HealthSleepTotalTopView.h"
#import "BaseHealthHeader.h"
@implementation HealthSleepTotalTopView

 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backConnectView];
        [self.backConnectView addSubview:self.oneBtn];
        [self.backConnectView addSubview:self.twoBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backConnectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_backConnectView.superview);
        make.width.equalTo(_backConnectView.superview).offset(-32);
        make.height.offset(30);
    }];
    [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_backConnectView);
        make.right.equalTo(_backConnectView.mas_centerX);
    }];
    [_twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_backConnectView);
        make.left.equalTo(_backConnectView.mas_centerX);
    }];
}
#pragma mark ===
- (UIView *)backConnectView{
    if (!_backConnectView) {
        _backConnectView = [[UIView alloc]init];
        _backConnectView.layer.cornerRadius = 5;
        _backConnectView.layer.masksToBounds = YES;
        _backConnectView.layer.borderColor = Color_HealthMainGreenColor.CGColor;
        _backConnectView.layer.borderWidth = 2;
    }
    return _backConnectView;
}

- (UIButton *)oneBtn{
    if (!_oneBtn) {
        _oneBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_oneBtn newAnBtnWithTextStr:@"昨日"];
        [_oneBtn newAnBtnWithFont:[PensionThemeManager shareManager].Pension_TextFont_15];
        [_oneBtn newAnBtnWithBackColor:Color_HealthMainGreenColor];
        [_oneBtn newAnBtnWithTextColorNomal:Color_HealthMainGreenColor  withTextColorSelected:[UIColor whiteColor]];
        _oneBtn.selected = YES;
        [_oneBtn addTarget:self action:@selector(oneBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneBtn;
}
- (UIButton *)twoBtn{
    if (!_twoBtn) {
        _twoBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_twoBtn newAnBtnWithTextStr:@"周统计"];
        [_twoBtn newAnBtnWithFont:[PensionThemeManager shareManager].Pension_TextFont_15];
        [_twoBtn newAnBtnWithBackColor:[UIColor whiteColor]];
        [_twoBtn newAnBtnWithTextColorNomal:Color_HealthMainGreenColor  withTextColorSelected:[UIColor whiteColor]];
        _twoBtn.selected = NO;
        [_twoBtn addTarget:self action:@selector(twoBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _twoBtn;
}
- (void)oneBtnBtnAction{
    if (self.oneBtn.selected) {
        return;
    }
    self.oneBtn.selected = YES;
    self.oneBtn.backgroundColor = Color_HealthMainGreenColor;
    self.twoBtn.selected = NO;
    self.twoBtn.backgroundColor = [UIColor whiteColor];
    if (isNotNil(_chooseTypeBlock)) {
        self.chooseTypeBlock(SleepTotalTopView_SubBtn_Choose_Type_OneDay);
    }
}
- (void)twoBtnBtnAction{
    if (self.twoBtn.selected) {
        return;
    }
    self.twoBtn.selected = YES;
    self.twoBtn.backgroundColor = Color_HealthMainGreenColor;
    self.oneBtn.selected = NO;
    self.oneBtn.backgroundColor = [UIColor whiteColor];
    if (isNotNil(_chooseTypeBlock)) {
        self.chooseTypeBlock(SleepTotalTopView_SubBtn_Choose_Type_OneWeak);
    }
}
@end
