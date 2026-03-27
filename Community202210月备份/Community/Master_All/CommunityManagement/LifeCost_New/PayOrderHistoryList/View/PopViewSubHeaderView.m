//
//  PopViewSubHeaderView.m
//  Community
//
//  Created by 余莹 on 2022/1/6.
//

#import "PopViewSubHeaderView.h"

@implementation PopViewSubHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [ThemeManager shareManager].themeLineColor.CGColor;
        [self addSubview: self.cancelBtn];
        [self addSubview: self.okBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(60);
        make.left.equalTo(_cancelBtn.superview).offset(10);
        make.top.equalTo(_cancelBtn.superview);
        make.height.offset(44);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(60);
        make.right.equalTo(_okBtn.superview).offset(-10);
        make.top.equalTo(_okBtn.superview);
        make.height.offset(44);
    }];
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn newAnBtnWithTextStr:@"取消"];
        [_cancelBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15.0]];
        [_cancelBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
        [_cancelBtn newAnBtnWithBackColor:[ThemeManager shareManager].themeContentBackGroundColor];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn newAnBtnWithTextStr:@"确定"];
        [_okBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15.0]];
        [_okBtn newAnBtnWithTextColor: Y_ColorWith16FromRGB(0x539CFC)];
        [_okBtn newAnBtnWithBackColor:[ThemeManager shareManager].themeContentBackGroundColor];
        [_okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}
- (void)cancelBtnAction{
    if (isNotNil(self.isTouchhOkBtnBoolBlock)) {
        self.isTouchhOkBtnBoolBlock(NO);
    }
    
}
- (void)okBtnAction{
    if (isNotNil(self.isTouchhOkBtnBoolBlock)) {
        self.isTouchhOkBtnBoolBlock(YES);
    }
}
@end
