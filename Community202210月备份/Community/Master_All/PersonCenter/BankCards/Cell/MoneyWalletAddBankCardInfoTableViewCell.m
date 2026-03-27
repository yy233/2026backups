//
//  MoneyWalletAddBankCardInfoTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "MoneyWalletAddBankCardInfoTableViewCell.h"

@implementation MoneyWalletAddBankCardInfoTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.detailL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(10);
        make.left.right.equalTo(_titleL.superview);
        make.height.offset(22);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_detailL.superview);
        make.top.equalTo(_titleL.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FontSize_MoneyWallet_Bold(22);
        _titleL.text = @"完善信息";
    }
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;

    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.font = FontSize_MoneyWallet_Nomail(12);
        _detailL.text = @"请绑定持卡人本人的银行卡";
        _detailL.textColor = Color_153GrayColor;
    }
    _detailL.textColor = [ [ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    return _detailL;
}
@end
