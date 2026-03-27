//
//  BaseAddressShowTextTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/2.
//

#import "BaseAddressEditTextTableViewCell.h"

@interface BaseAddressEditTextTableViewCell () <UITextFieldDelegate>
//nowTextFStrChangeBlock
@property (nonatomic,strong) UITextField *textF;

@end

@implementation BaseAddressEditTextTableViewCell

- (void)setTextPStr:(NSString *)pStr{
    if (pStr.length<=0) {//无基础默认数据时。保留初始UI的 ”请输入“。
        return;
    }
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString: [@"可输入｜当前默认为：" stringByAppendingString:pStr] attributes:@{NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0x6E727D)}];
    self.textF.attributedPlaceholder = placeholderString;
}
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
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.textF];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.superview).offset(26);
        make.width.offset(35);
        make.height.offset(20);
        make.centerY.equalTo(_titleL.superview);
    }];
    [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.mas_right).offset(0);
        make.right.equalTo(_textF.superview).offset(-26);
        make.height.offset(30);
        make.centerY.equalTo(_textF.superview);
    }];
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"";
        _titleL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        _titleL.font = [UIFont boldSystemFontOfSize:14.0];
    }
    return _titleL;
}
- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.font = [UIFont systemFontOfSize:14.0];
        _textF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textF.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        //
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
        _textF.attributedPlaceholder = placeholderString;
        _textF.delegate = self;
    }
    return _textF;
}


- (void)textFieldDidChangeSelection:(UITextField *)textField{
    if (isNotNil(self.nowTextFStrChangeBlock)) {
        self.nowTextFStrChangeBlock( [TextShowWithModelStr textShowWithModelStr:textField.text] );
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (isNotNil(self.nowTextFStrChangeBlock)) {
        self.nowTextFStrChangeBlock( [TextShowWithModelStr textShowWithModelStr:textField.text] );
    }
}
@end
