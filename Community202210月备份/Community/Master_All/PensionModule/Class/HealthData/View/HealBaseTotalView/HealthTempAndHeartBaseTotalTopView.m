//
//  HealthTempTotalTopView.m
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import "HealthTempAndHeartBaseTotalTopView.h"
#import "BaseHealthHeader.h"

@implementation HealthTempAndHeartBaseTotalTopView


- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
       [self addSubview:self.backConnectView];
       [self.backConnectView addSubview:self.oneBtn];
       [self.backConnectView addSubview:self.twoBtn];
       [self.backConnectView addSubview:self.thrBtn];
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
        make.width.equalTo(_backConnectView.mas_width).multipliedBy(0.333);
    }];
    [_thrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_backConnectView);
        make.width.equalTo(_backConnectView.mas_width).multipliedBy(0.333);
    }];
    
    [_twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_backConnectView);
        make.left.equalTo(_oneBtn.mas_right);
        make.right.equalTo(_thrBtn.mas_left);
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
       [_oneBtn newAnBtnWithTextStr:@"当日"];
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
       [_twoBtn newAnBtnWithTextStr:@"本周"];
       [_twoBtn newAnBtnWithFont:[PensionThemeManager shareManager].Pension_TextFont_15];
       [_twoBtn newAnBtnWithBackColor:[UIColor whiteColor]];
       [_twoBtn newAnBtnWithTextColorNomal:Color_HealthMainGreenColor  withTextColorSelected:[UIColor whiteColor]];
       _twoBtn.selected = NO;
       [_twoBtn addTarget:self action:@selector(twoBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
        //三个btn 中间这个btn用layer做分割线 直线 cr=0 w=1
       _twoBtn.layer.cornerRadius = 0.0;
       _twoBtn.layer.borderWidth = 1.0;
       _twoBtn.layer.borderColor = Color_HealthMainGreenColor.CGColor;
   }
   return _twoBtn;
}
- (UIButton *)thrBtn{
   if (!_thrBtn) {
       _thrBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
       [_thrBtn newAnBtnWithTextStr:@"本月"];
       [_thrBtn newAnBtnWithFont:[PensionThemeManager shareManager].Pension_TextFont_15];
       [_thrBtn newAnBtnWithBackColor:[UIColor whiteColor]];
       [_thrBtn newAnBtnWithTextColorNomal:Color_HealthMainGreenColor  withTextColorSelected:[UIColor whiteColor]];
       _thrBtn.selected = NO;
       [_thrBtn addTarget:self action:@selector(thrBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
   }
   return _thrBtn;
}
- (void)oneBtnBtnAction{
    if (self.oneBtn.selected) {
        return;
    }
    self.oneBtn.selected = YES;
    self.oneBtn.backgroundColor = Color_HealthMainGreenColor;
    //
    self.twoBtn.selected = NO;
    self.twoBtn.backgroundColor = [UIColor whiteColor];
    self.thrBtn.selected = NO;
    self.thrBtn.backgroundColor = [UIColor whiteColor];
    if (isNotNil(_chooseTypeBlock)) {
        self.chooseTypeBlock(TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisDay);
    }
}
- (void)twoBtnBtnAction{
    if (self.twoBtn.selected) {
        return;
    }
    self.twoBtn.selected = YES;
    self.twoBtn.backgroundColor = Color_HealthMainGreenColor;
    //
    self.oneBtn.selected = NO;
    self.oneBtn.backgroundColor = [UIColor whiteColor];
    self.thrBtn.selected = NO;
    self.thrBtn.backgroundColor = [UIColor whiteColor];
    if (isNotNil(_chooseTypeBlock)) {
        self.chooseTypeBlock(TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisWeak);
    }
}
- (void)thrBtnBtnAction{
    //
    self.thrBtn.selected = YES;
    self.thrBtn.backgroundColor = Color_HealthMainGreenColor;
    //
    self.oneBtn.selected = NO;
    self.oneBtn.backgroundColor = [UIColor whiteColor];
    self.twoBtn.selected = NO;
    self.twoBtn.backgroundColor = [UIColor whiteColor];
    if (isNotNil(_chooseTypeBlock)) {
        self.chooseTypeBlock(TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisMonth);
    }
}
@end
