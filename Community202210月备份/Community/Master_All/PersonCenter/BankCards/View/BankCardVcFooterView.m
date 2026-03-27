//
//  BankCardVcFooterView.m
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import "BankCardVcFooterView.h"

@implementation BankCardVcFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 180);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.detailL];
        [self.backView addSubview:self.footerBtnView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_detailL.superview);
        make.height.offset(20);
        make.centerY.equalTo(_detailL.superview.mas_centerY).offset(-20);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_detailL);
        make.top.equalTo(_titleL.superview);
        make.bottom.equalTo(_detailL.mas_top);
    }];
    [_footerBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_footerBtnView.superview);
        make.top.equalTo(_detailL.mas_bottom);
    }];
}
//

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 7.5;
        _backView.layer.masksToBounds = YES;
    }
    _backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;

    return _backView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = FontSize_MoneyWallet_Bold(20);
        _titleL.text = @"添加银行卡·安全 便捷";
    }
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL =  [[UILabel alloc]init];
        _detailL.textAlignment = NSTextAlignmentCenter;
        _detailL.font = FontSize_MoneyWallet_Nomail(12);
//        _detailL.textColor = Color_138GrayColor;
        _detailL.text = @"支持快速绑卡，无需手动输入卡号";
    }
    _detailL.textColor = [ [ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    return _detailL;
}
- (BaseTableViewFooterView *)footerBtnView{
    if (!_footerBtnView) {
        _footerBtnView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectZero];
        [_footerBtnView.footerBtn newAnBtnWithTextStr:@"添加银行卡"];
        [_footerBtnView setBtnFram:CGRectMake(16, 0, Screen_W-32-32, 50)];
    }
    return _footerBtnView;
}
@end
