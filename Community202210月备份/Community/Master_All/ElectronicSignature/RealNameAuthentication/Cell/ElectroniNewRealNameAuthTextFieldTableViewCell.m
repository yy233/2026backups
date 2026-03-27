//
//  ElectroniNewRealNameAuthTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ElectroniNewRealNameAuthTextFieldTableViewCell.h"

@implementation ElectroniNewRealNameAuthTextFieldTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.textField]; 
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(15);
        make.height.offset(20);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_textField.superview).insets(UIEdgeInsetsMake(40, 16, 5, 16));//h 20+空5空5
        make.top.equalTo(_textField.superview).offset(40);
        make.left.equalTo(_textField.superview).offset(16);
        make.bottom.equalTo(_textField.superview).offset(-5);
        make.right.equalTo(_textField.superview).offset(-16);
    }];
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.placeholder = @"请输入";
        _textField.font = FontSize_ElectronicSignature_Nomail(18);// [UIFont systemFontOfSize:18];
    }
    return _textField;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor =  Y_RGBA(136, 136, 136, 1);
        _titleL.font =  FontSize_ElectronicSignature_Nomail(15);
    }
    return _titleL;
}
@end
