//
//  MoneyWalletAddBankCardNameTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "MoneyWalletAddBankCardNameTableViewCell.h"

@implementation MoneyWalletAddBankCardNameTableViewCell

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
        [self.backView addSubview:self.textField];
        [self.backView addSubview:self.rightBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(10);
        make.left.equalTo(_titleL.superview);
        make.height.offset(20);
        make.width.offset(80);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightBtn.superview);
        make.width.offset(20);
        make.height.offset(20);
        make.centerY.equalTo(_titleL);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.mas_right).offset(10);
        make.right.equalTo(_rightBtn.mas_left).offset(-10);
        make.height.offset(25);
        make.centerY.equalTo(_titleL);
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FontSize_MoneyWallet_Nomail(15);
        _titleL.text = @"真实姓名";
    }
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    return _titleL;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.textColor = [ThemeManager shareManager].mainTextColor;;
        _textField.font = FontSize_MoneyWallet_Nomail(15);
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName: [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]}];
        _textField.attributedPlaceholder = placeholderString;
    }
    return _textField;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn newAnBtnWithImg:[UIImage imageNamed:@"Add_Name_Tips"]];
    }
    return _rightBtn;
}

@end
