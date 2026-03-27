//
//  MoneyWalletAddBankCardPhoneNumTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "MoneyWalletAddBankCardPhoneNumTableViewCell.h"

@implementation MoneyWalletAddBankCardPhoneNumTableViewCell

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
        self.titleL.text = @"银行卡预留手机号";
//        self.textField.placeholder = @"申请人银行预留手机号";
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"申请人银行预留手机号" attributes:@{NSForegroundColorAttributeName: [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]}];
        self.textField.attributedPlaceholder = placeholderString; 
        [self upNewUI];
    }
    return self;
}
- (void)upNewUI{
    [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(130);
    }];
}
@end
