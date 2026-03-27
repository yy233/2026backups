//
//  DeviceScanListShowVcHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/11/17.
//

#import "DeviceScanListShowVcHeaderView.h"
#define  Color_TipBackViewColor             Y_ColorWith16FromRGB(0x1EC0A9)
#define  Color_TipRightIndicatorViewColor   Y_ColorWith16FromRGB(0x22D7BB)
 

@implementation DeviceScanListShowVcHeaderView
- (void)showWithEndConnectBool:(BOOL)isEndConnectBool{
    if (isEndConnectBool ) {
        [self.rightIndicatorView stopAnimating];
        self.rightIndicatorView.hidden = YES;
        [self.mainShowBtn newAnBtnWithTextStr:@"可以扫描附近的可添加设备"];
    }else{
        self.rightIndicatorView.hidden = NO;
        [self.rightIndicatorView startAnimating];
        [self.mainShowBtn newAnBtnWithTextStr:@"正在扫描附近的可添加设备"];

    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Color_TipBackViewColor colorWithAlphaComponent:0.1];
        [self addSubview:self.mainShowBtn];
        [self addSubview:self.rightIndicatorView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_mainShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_mainShowBtn.superview);
        make.left.equalTo(_mainShowBtn.superview.mas_left).offset(16);
    }];
    [_rightIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(25);
        make.right.equalTo(_rightIndicatorView.superview.mas_right).offset(-16);
        make.centerY.equalTo(_rightIndicatorView.superview);
    }];
}
#pragma mark ===
- (UIButton *)mainShowBtn{
    if (!_mainShowBtn) {
        _mainShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mainShowBtn newAnBtnWithTextStr:@"可以扫描附近的可添加设备"];
        [_mainShowBtn newAnBtnWithTextColor:Color_51BlackColor];
        [_mainShowBtn newAnBtnWithFont:[PensionThemeManager shareManager].Pension_TextFont_12];
        [_mainShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_equipment"]];
        [_mainShowBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    return _mainShowBtn;
}
- (UIActivityIndicatorView *)rightIndicatorView{
     
    if (!_rightIndicatorView) {
        _rightIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        _rightIndicatorView.color = Color_TipRightIndicatorViewColor;//中心旋转动画
    }
    return _rightIndicatorView;
}

@end
