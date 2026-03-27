//
//  DeviceScanListShowVcFooterView.m
//  Community
//
//  Created by 余莹 on 2021/11/17.
//

#import "DeviceScanListShowVcFooterView.h"

@implementation DeviceScanListShowVcFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textL];
        [self addSubview:self.footerShowBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_textL.superview);
        make.height.offset(20);
        make.centerY.equalTo(_textL.superview).multipliedBy(0.5);
    }];
    [_footerShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(60);
        make.centerX.equalTo(_footerShowBtn.superview);
        make.top.equalTo(_textL.mas_bottom).offset(40);
    }];
}
#pragma mark ===
- (UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc]init];
        _textL.text = @"没有找到更多智能设备";
        _textL.textColor = Y_ColorWith16FromRGB(0x6E727D);
        _textL.font = [PensionThemeManager shareManager].Pension_TextFont_B13;
    }
    return _textL;
}
- (UIButton *)footerShowBtn{
    if (!_footerShowBtn) {
        _footerShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerShowBtn newAnBtnWithTextStr:@"扫描"];
        [_footerShowBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0x6E727D)];
        [_footerShowBtn newAnBtnWithFont:[PensionThemeManager shareManager].Pension_TextFont_12];
        [_footerShowBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_saomiao"]];
        
        [_footerShowBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:3];
    }
    return _footerShowBtn;
}
 
@end
