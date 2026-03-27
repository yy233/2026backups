//
//  MyHouseAddSubPersonTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/4.
//

#import "MyHouseAddSubPersonTableViewCell.h"


@implementation MyHouseAddSubPersonTableViewCell

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
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
//        self.backView.backgroundColor = Color_11BlueColor;
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;

        [self.backView addSubview:self.titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleL.superview).offset(16);
            make.top.bottom.equalTo(_titleL.superview);
            make.width.offset(75);
        }];
    }
    return self;
}
- (void)prepareForReuse{
    [super prepareForReuse];
    self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    return _titleL;
}
@end
@interface MyHouseAddSubPersonTableViewCellTextFeild () <UITextFieldDelegate>

@end
@implementation MyHouseAddSubPersonTableViewCellTextFeild
 
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
        [self.backView addSubview:self.textField];
        WEAKSELF
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleL.mas_right).offset(1);
            make.top.bottom.equalTo(weakSelf.titleL);
            make.right.equalTo(_textField.superview).offset(-16-10);
//            make.width.greaterThanOrEqualTo(_textField.superview).multipliedBy(0.6);
        }];
    }
    return self;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textColor = [ThemeManager shareManager].mainTextColor;
        _textField.textAlignment = NSTextAlignmentRight;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]}];
        _textField.attributedPlaceholder = placeholderString;
        _textField.delegate = self;
    }
    return _textField;
}
//
- (void)setTextShowBeginLeft{ 
    self.textField.textAlignment  = NSTextAlignmentLeft;
}

- (void)setTextFiePstr:(NSString *)pStr{
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:pStr attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]}];
    _textField.attributedPlaceholder = placeholderString;
}
#pragma mark ==== textFieldDelegate
 
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTextFieldWithTag:andTextFieldStr:)]) {
        [_delegate cellTextFieldWithTag:self.textField.tag andTextFieldStr:textField.text];
    }
}
#pragma  mark ==
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTextFieldWithTag:andTextFieldStr:)]) {
        [_delegate cellTextFieldWithTag:self.textField.tag andTextFieldStr:textField.text];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTextFieldWithTag:andTextFieldStr:)]) {
        [_delegate cellTextFieldWithTag:self.textField.tag andTextFieldStr:textField.text];
    }
}
@end


@implementation  MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn

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
        [self.backView addSubview:self.rightImgV];
        [self.backView addSubview:self.viewTopChooseBtn];
        WEAKSELF
        [_viewTopChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.textField);
        }];
        [_rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_rightImgV.superview);
            make.width.offset(5);
            make.right.equalTo(_rightImgV.superview).offset(-16);
        }];
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请选择" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]}];
        self.textField.attributedPlaceholder = placeholderString;
    }
    return self;
}
//
- (UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc]init];
        _rightImgV.image = [UIImage imageNamed:@"rightSkip"];
        _rightImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImgV;
}
- (UIButton *)viewTopChooseBtn{
    if (!_viewTopChooseBtn) {
        _viewTopChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_viewTopChooseBtn addTarget:self action:@selector(textFieldTopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewTopChooseBtn;
}
//
- (void)textFieldTopBtnAction{
    self.touchBtnBlock(); 
}
@end


@implementation BaseShowRedRightTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField.textColor = COlor_Red255;
        self.textField.font = [UIFont systemFontOfSize:17];
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.userInteractionEnabled = NO;//仅用于展示
    }
    return self;
}
@end

 


