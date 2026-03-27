//
//  FeedbackTextFieldTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "FeedbackTextFieldTableViewCell.h"

@interface FeedbackTextFieldTableViewCell ()

@property (nonatomic, strong) UIView *contentV;

@end

@implementation FeedbackTextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel.text = @"联系电话:";
        [self.backView addSubview:self.contentV];
        [self.contentV addSubview:self.textField];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [_contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_contentV.superview);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_textField.superview);
        make.left.equalTo(_textField.superview).offset(6);
        make.right.equalTo(_textField.superview).offset(-6);
    }];
}

#pragma mark ==
- (UIView *)contentV {
    if (!_contentV) {
        _contentV = [[UIView alloc] init];
        _contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
        _contentV.layer.cornerRadius = 5;
        _contentV.layer.masksToBounds = YES;
    }
    
    return _contentV;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _textField.keyboardType = UIKeyboardTypePhonePad;
        _textField.font = FontSize_ElectronicSignature_Nomail(14);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //Placeholder
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入联系手机号码" attributes:@{NSForegroundColorAttributeName:[ZYThemeManager shareManager].placeholderThemeColor}]; 
        _textField.attributedPlaceholder = placeholderString;
    }
    
    return _textField;
}

@end
