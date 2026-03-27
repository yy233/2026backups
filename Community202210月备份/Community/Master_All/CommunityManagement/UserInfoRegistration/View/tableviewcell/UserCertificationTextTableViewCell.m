//
//  UserCertificationTextTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/11/23.
//

#import "UserCertificationTextTableViewCell.h"

@interface UserCertificationTextTableViewCell ()


@end
@implementation UserCertificationTextTableViewCell

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
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.textField];
        [self.backView addSubview:self.textFieldRightBtn];
        [self.backView addSubview:self.lineView];
        [self.backView addSubview:self.subShowChooseBtn];
        [self setTextLabelModuleUI];
 
    }
    return self;
}
- (void)setTextLabelModuleUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleL.superview.mas_centerY);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.height.offset(20);
        make.width.offset(60);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textField.superview.mas_centerY);
        make.left.equalTo(_titleL.mas_right).offset(1);
        make.right.equalTo(_textField.superview.mas_right).offset(-36);//16+6+间隔
        make.height.offset(30);
    }];
    [_textFieldRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textFieldRightBtn.superview.mas_centerY);
        make.left.equalTo(_textField.mas_right).offset(0);
        make.right.equalTo(_textFieldRightBtn.superview.mas_right).offset(-16);
        make.width.offset(5);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_lineView.superview.mas_bottom);
        make.left.equalTo(_titleL.mas_left).offset(0);;
        make.right.equalTo(_textFieldRightBtn.mas_right).offset(0);
        make.height.offset(1);
    }];
    [_subShowChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textField);
    }];
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
//        _backView.backgroundColor = [ThemeManager shareManager].mainContentBackgroundColor;
//        _backView.layer.cornerRadius = 5;//
//        _backView.layer.masksToBounds = YES;
    }
    return _backView;
    
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleL;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.textColor = [ThemeManager shareManager].mainTextColor;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textAlignment = NSTextAlignmentRight;
    }
    return _textField;
}
- (UIButton *)textFieldRightBtn{//展示尖头img
    if (!_textFieldRightBtn) {
        _textFieldRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_textFieldRightBtn setImage:[ThemeImg mainModulethemeImageWithBaseName:@"rightSkip"] forState:UIControlStateNormal];
        [_textFieldRightBtn setImage:[UIImage imageNamed:@"rightSkip"] forState:UIControlStateNormal];
    }
    return _textFieldRightBtn;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [ThemeManager shareManager].mainContentLineColor;
    }
    return _lineView;
}

- (UIButton *)subShowChooseBtn{
    if (!_subShowChooseBtn) {
        _subShowChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subShowChooseBtn addTarget:self.superview action:@selector(subShowChooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subShowChooseBtn;
}
@end

#pragma mark +++++++++++++++++++++++++++++//车辆信息车牌号cell ++++++++++++++++++++


@interface UserCertificationTextWithOtherRightImgTableViewCell ()
@end
@implementation UserCertificationTextWithOtherRightImgTableViewCell

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
    }
    return self;
}
 
- (void)setTextLabelModuleUI{//

    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView.superview);
    }];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL.superview.mas_centerY);
        make.left.equalTo(self.titleL.superview.mas_left).offset(16);
        make.height.offset(20);
        make.width.offset(60);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textField.superview.mas_centerY);
        make.left.equalTo(self.titleL.mas_right).offset(5);
        make.right.equalTo(self.textField.superview.mas_right).offset(-50);//16+6+间隔+15的右边按钮扩大
        make.height.offset(30);
        make.width.offset(100);
    }];
    [self.textFieldRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.mas_right);
        make.right.equalTo(self.textFieldRightBtn.superview.mas_right).offset(-16);
        make.width.offset(20);
        make.height.equalTo(self.textFieldRightBtn.superview.mas_height);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView.superview.mas_bottom);
        make.left.equalTo(self.titleL.mas_left).offset(0);;
        make.right.equalTo(self.textFieldRightBtn.mas_right).offset(0);
        make.height.offset(1);
    }];
    [self.subShowChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textFieldRightBtn);
    }];
    self.subShowChooseBtn.hidden = NO;
    [self.textFieldRightBtn setImage:[UIImage imageNamed:@"camera_night"] forState:UIControlStateNormal];
}

@end
 
 
 
 
