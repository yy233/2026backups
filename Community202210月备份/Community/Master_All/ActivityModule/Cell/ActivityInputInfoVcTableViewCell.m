//
//  ActivityInputInfoVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/6/7.
//

#import "ActivityInputInfoVcTableViewCell.h"

@implementation ActivityInputInfoVcTableViewCell

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
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WEAKSELF
        [weakSelf.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        [self.backView addSubview:self.titleL];
        [self setYU];
    }
    return self;
}
- (void)setYU{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerY.equalTo(_titleL.superview);
        make.left.equalTo(_titleL.superview).offset(10);
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:15.0];
    }
    return _titleL;
}
@end

 
@implementation ActivityInputInfoVcTextFieldTableViewCell
 
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)changePlaceholderStrInfoWithStr:(NSString *)pstr{
    
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:pstr attributes:@{NSForegroundColorAttributeName:[ZYThemeManager shareManager].placeholderThemeColor}];
    _textF.attributedPlaceholder = placeholderString;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WEAKSELF
        [weakSelf.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        [self.backView addSubview:self.textF];
        [self.backView addSubview:self.lineV];
        [self setUI]; 
    }
    return self;
}
- (void)setUI{
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(_lineV.superview);
        make.height.offset(0.5);
        make.width.equalTo(_lineV.superview).offset(-20);
    }];
    [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_textF.superview).offset(-1);
        make.width.equalTo(_lineV);
        make.centerY.centerX.equalTo(_textF.superview);
    }];
}
- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc] init];
        _textF.textColor = [ThemeManager shareManager].mainTextColor;
        _textF.font = [UIFont systemFontOfSize:14.0];
        _textF.clearButtonMode = UITextFieldViewModeWhileEditing;
        //Placeholder
//        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入联系手机号码" attributes:@{NSForegroundColorAttributeName:[ZYThemeManager shareManager].placeholderThemeColor}];
//        _textF.attributedPlaceholder = placeholderString;
    }
    return _textF;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = [ThemeManager shareManager].themeLineColor;
    }
    return _lineV;
}
@end

