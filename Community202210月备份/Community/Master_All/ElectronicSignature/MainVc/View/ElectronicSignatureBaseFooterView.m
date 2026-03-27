//
//  ElectronicSignatureBaseFooterView.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ElectronicSignatureBaseFooterView.h"

@implementation ElectronicSignatureBaseFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0,0, Screen_W, 90);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.footerBtn];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [_footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_footerBtn.superview);
        make.top.offset(30);
        make.width.offset(Screen_W-2*36);
        make.height.offset(50);
    }];
}
#pragma mark ==
- (UIButton *)footerBtn{
    if (!_footerBtn) {
        _footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerBtn setTitle:@"+ basefooterBtn +" forState:UIControlStateNormal];
        _footerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _footerBtn.layer.cornerRadius = 25;//h 50
        _footerBtn.layer.masksToBounds = YES;
        CGSize size = CGSizeMake(Screen_W-2*36, 50);//w Screen_W-2*36
        _footerBtn.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
    }
     return _footerBtn;
}

@end
