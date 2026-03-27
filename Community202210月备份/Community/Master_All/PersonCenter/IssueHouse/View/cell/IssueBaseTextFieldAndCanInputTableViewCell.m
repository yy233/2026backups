//
//  IssueBaseTextFieldAndCanInputTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import "IssueBaseTextFieldAndCanInputTableViewCell.h"

@interface IssueBaseTextFieldAndCanInputTableViewCell () <UITextFieldDelegate>

@end

@implementation IssueBaseTextFieldAndCanInputTableViewCell

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
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.textField];
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.top.equalTo(_titleL.superview.mas_top);
        make.bottom.equalTo(_titleL.superview.mas_bottom);
        make.width.offset(80);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_textField.superview.mas_right).offset(-20);
        make.top.equalTo(_textField.superview.mas_top);
        make.bottom.equalTo(_textField.superview.mas_bottom);
        make.left.equalTo(_titleL.mas_right).offset(5);
    }];
}
#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:15];
    }
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    return _titleL;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]}];
        _textField.attributedPlaceholder = placeholderString;
        _textField.delegate = self;
    }
    _textField.textColor = [ThemeManager shareManager].mainTextColor;
    return _textField;
}

#pragma  mark ==
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_delegale && [_delegale respondsToSelector:@selector(cellTextFieldWithTag:andTextFieldStr:)]) {
        [_delegale cellTextFieldWithTag:self.textField.tag andTextFieldStr:textField.text];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_delegale && [_delegale respondsToSelector:@selector(cellTextFieldWithTag:andTextFieldStr:)]) {
        [_delegale cellTextFieldWithTag:self.textField.tag andTextFieldStr:textField.text];
    }
}
//#define Tag_Cell_Sub_TextField_MoneyNum    200

@end
