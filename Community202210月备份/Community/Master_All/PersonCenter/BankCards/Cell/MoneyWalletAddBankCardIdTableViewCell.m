//
//  MoneyWalletAddBankCardIdTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "MoneyWalletAddBankCardIdTableViewCell.h"

@implementation MoneyWalletAddBankCardIdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleL.text = @"银行卡号";
        [self.rightBtn newAnBtnWithImg:[UIImage imageNamed:@"Add_Bankcard_scan"]];
        [self.backView addSubview:self.bankTypeBottomShowBtn];
        [self setBtnUI];
    }
    return self;
}
- (void)setBtnUI{
    [_bankTypeBottomShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField);
        make.top.equalTo(self.textField.mas_bottom).offset(5);
        make.height.offset(20);
    }];
}
- (UIButton *)bankTypeBottomShowBtn{
    if (!_bankTypeBottomShowBtn) {
        _bankTypeBottomShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bankTypeBottomShowBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(12)];
        [_bankTypeBottomShowBtn newAnBtnWithTextColor:Color_138GrayColor];
        [_bankTypeBottomShowBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    return _bankTypeBottomShowBtn;
}
@end
