//
//  BaseMoneyWalletVC.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "BaseMoneyWalletVC.h"
 
@interface BaseMoneyWalletVC ()

@end

@implementation BaseMoneyWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = Color_245Gray;
    [self bottomTipLabelViewAdd];
   
}
- (void)bottomTipLabelViewAdd{
    [self.view addSubview:self.bottomTipLabel];
    [_bottomTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomTipLabel.superview.mas_bottom).offset(-20);
        make.height.offset(20);
        make.left.right.equalTo(_bottomTipLabel.superview);
    }];
    _bottomTipLabel.hidden = YES;
}
- (UILabel *)bottomTipLabel{
    if (!_bottomTipLabel) {
        _bottomTipLabel = [[UILabel alloc]init];
        _bottomTipLabel.textAlignment = NSTextAlignmentCenter;
        _bottomTipLabel.textColor = Y_RGBA(187, 187, 187, 1);
        _bottomTipLabel.font = FontSize_MoneyWallet_Nomail(12);
        _bottomTipLabel.text = @"未来物服支付安全保障中";
    }
    return _bottomTipLabel;
}
@end
