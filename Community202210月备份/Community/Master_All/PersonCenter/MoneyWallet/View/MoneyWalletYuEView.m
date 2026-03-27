//
//  MoneyWalletYuEView.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "MoneyWalletYuEView.h"

@interface MoneyWalletYuEView ()

@end

@implementation MoneyWalletYuEView
#pragma mark ==
- (void)fillData:(NSDictionary *)dic{
    self.moneyL.text = @"2.00";
}

#pragma mark ==
 /**- (void)chongZhiAction;
 - (void)tiXianAction;
 - (void)showMingXiAction;
 */
#pragma mark ==
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.moneyL];
        [self.backView addSubview:self.goShowMingXiBtn];
        [self.backView addSubview:self.tiXianBtn];
        [self.backView addSubview:self.chongZhiBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(_titleL.superview);
        make.height.offset(20);
        make.top.equalTo(_titleL.superview).mas_offset(30);
    }];
    //
    [_tiXianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tiXianBtn.superview.mas_left).offset(10);
        make.right.equalTo(_tiXianBtn.superview.mas_centerX).offset(-5);
        make.bottom.equalTo(_tiXianBtn.superview.mas_bottom).offset(-20);
        make.height.offset(50);
    }];
    [_chongZhiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_chongZhiBtn.superview.mas_centerX).offset(5);
        make.right.equalTo(_chongZhiBtn.superview.mas_right).offset(-10);
        make.centerY.equalTo(_tiXianBtn.mas_centerY);
        make.height.equalTo(_tiXianBtn.mas_height);
    }];
    //
    [_goShowMingXiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_moneyL);
        make.height.offset(30);
        make.bottom.equalTo(_tiXianBtn.mas_top).offset(-10);
    }];
    //
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
        make.bottom.equalTo(_goShowMingXiBtn.mas_top).offset(-10);
    }];
}
#pragma mark ==

- (UIView *)backView{
   if (!_backView) {
        _backView = [[UIView alloc]init];
       _backView.layer.cornerRadius = 10;
       _backView.layer.masksToBounds = YES;
//       _backView.backgroundColor = [UIColor whiteColor];
   }
    _backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;

   return _backView;
}
 
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"账户余额（元）";
//        _titleL.textColor = Color_51BlackColor;
        _titleL.font = FontSize_MoneyWallet_Nomail(15);
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    return _titleL;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.text = @"0.0";
//        _moneyL.textColor = [UIColor blackColor];
        _moneyL.font = FontSize_MoneyWallet_Bold(36);
        _moneyL.textAlignment = NSTextAlignmentCenter;
    }
    _moneyL.textColor = [ThemeManager shareManager].mainTextColor;
    return _moneyL;
}
//
- (UIButton *)goShowMingXiBtn{
    if (!_goShowMingXiBtn) {
        _goShowMingXiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goShowMingXiBtn addTarget:self action:@selector(goShowMingXiBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_goShowMingXiBtn newAnBtnWithTextStr:@"查看明细"];
        [_goShowMingXiBtn newAnBtnWithImg:[UIImage imageNamed:@"Balance_detailed"]];
        [_goShowMingXiBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
//        [_goShowMingXiBtn newAnBtnWithTextColor: Y_RGBA(187, 187, 187, 1)];
        [_goShowMingXiBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(13)];
    }
    [_goShowMingXiBtn newAnBtnWithTextColor: [ThemeManager shareManager].mainTextColor ];
    return _goShowMingXiBtn;
}
- (UIButton *)tiXianBtn{
    if (!_tiXianBtn) {
        _tiXianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tiXianBtn addTarget:self action:@selector(tiXianBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_tiXianBtn newAnBtnWithTextColor:Color_51BlackColor withBackColor:Color_238GrayColor withFont:FontSize_MoneyWallet_Bold(15) withLayerCorNerNum:7.5 withLayerLineWidth:0 withLayerLineColor:nil];
        [_tiXianBtn newAnBtnWithTextStr:@"提现"];
    }
    return _tiXianBtn;
}
- (UIButton *)chongZhiBtn{
    if (!_chongZhiBtn) {
        _chongZhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chongZhiBtn addTarget:self action:@selector(chongZhiBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_chongZhiBtn newAnBtnWithTextColor:[UIColor whiteColor] withBackColor:Y_RGBA(38, 114, 249, 1) withFont:FontSize_MoneyWallet_Bold(15) withLayerCorNerNum:7.5 withLayerLineWidth:0 withLayerLineColor:nil];
        [_chongZhiBtn newAnBtnWithTextStr:@"充值"];
    }
    return _chongZhiBtn;
}
#pragma mark ==
- (void)chongZhiBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(chongZhiAction)]) {
        [_delegate chongZhiAction];
    }
}
- (void)tiXianBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(tiXianAction)]) {
        [_delegate tiXianAction];
    }
}
- (void)goShowMingXiBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(showMingXiAction)]) {
        [_delegate showMingXiAction];
    }
}
@end
