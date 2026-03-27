//
//  ShippingAddressTextFieldTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "ShippingAddressTextFieldTableViewCell.h"

@interface ShippingAddressTextFieldTableViewCell () <UITextFieldDelegate>

@end


@implementation ShippingAddressTextFieldTableViewCell

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
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.textField];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.equalTo(_titleL.superview);
        make.width.offset(70);
        make.height.offset(30);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textField.superview);
        make.right.equalTo(_textField.superview.mas_right).offset(-30);
        make.left.equalTo(_titleL.mas_right).offset(10);
        make.height.equalTo(_titleL);
    }];
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    _textField.textColor = [ThemeManager shareManager].mainTextColor;
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3]}];
    _textField.attributedPlaceholder =  placeholderString;
    self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
  
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FontSize_Orders_Bold(15);
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}
 
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.placeholder = @"请输入";
        _textField.font = FontSize_Orders_Nomail(15);
        _textField.delegate = self;
    }
    return _textField;
}

//

#pragma mark ==== textFieldDelegate
 
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(getTextFieldTag:withTextStrWithStr:)]) {
        [_textFieldDelegate getTextFieldTag:textField.tag withTextStrWithStr:textField.text];
    }
    //[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
}
@end
