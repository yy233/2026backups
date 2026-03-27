//
//  LifeCosePaymentOnePayInfoChargeMoneyCell.m
//  Community
//
//  Created by 余莹 on 2021/1/9.
//

#import "LifeCosePaymentOnePayInfoChargeMoneyCell.h"

@implementation LifeCosePaymentOnePayInfoChargeMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setD{
    
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.moneyLeftL];
        [self.contentView addSubview:self.textField];
        [self setUI];
        [self setD];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(5);
        make.left.equalTo(_titleL.superview.mas_left).offset(26);
        make.width.offset(70);
        make.height.offset(20);
    }];
    [_moneyLeftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(5);
        make.left.equalTo(_titleL.mas_left);
        make.width.offset(20);
        make.bottom.equalTo(_moneyLeftL.superview.mas_bottom).offset(-5);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(5);
        make.left.equalTo(_moneyLeftL.mas_right).offset(5);
        make.right.equalTo(_textField.superview.mas_right).offset(-26);
        make.bottom.equalTo(_textField.superview.mas_bottom).offset(-5);
    }];
    
}
 
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont systemFontOfSize:15];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.text = @"充值金额";
    }
    return _titleL;
}
- (UILabel *)moneyLeftL{
    if (!_moneyLeftL) {
        _moneyLeftL = [[UILabel alloc]init];
        _moneyLeftL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyLeftL.font = [UIFont boldSystemFontOfSize:23];
        _moneyLeftL.textAlignment = NSTextAlignmentLeft;
        _moneyLeftL.text = @"¥";
    }
    return _moneyLeftL;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:18];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [ThemeManager shareManager].mainTextColor;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入充值金额" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]}];
        _textField.attributedPlaceholder = placeholderString;
    }
    return _textField;
}
@end
