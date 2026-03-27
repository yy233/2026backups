//
//  HouseRepairEditCellSubTextFieldTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import "HouseRepairEditCellSubTextFieldTableViewCell.h"

@implementation HouseRepairEditCellSubTextFieldTableViewCell

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
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.lineView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(0);
        make.bottom.equalTo(_titleLabel.superview.mas_bottom).offset(0);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(10);
        make.width.offset(70);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {//statusBtn_W
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_textField.superview.mas_right).offset(-10);
        make.height.equalTo(_titleLabel.mas_height);
        make.left.equalTo(_titleLabel.mas_right).offset(1);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(-1);
        make.left.equalTo(_lineView.superview.mas_left).offset(10);
        make.right.equalTo(_lineView.superview.mas_right).offset(-10);
        make.height.offset(1);
    }];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        if ([ThemeManager shareManager].type==ThemeType_White) {
            _lineView.backgroundColor = Y_RGBA(240, 241, 246, 1);
        }else{
            _lineView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        }
    }
    return _lineView;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = [ThemeManager shareManager].mainTextColor;
        _textField.textAlignment = NSTextAlignmentRight;
    }
    return _textField;
}
@end

#pragma mark =================================================================================================
@implementation HouseRepairEditCellSubTextFieldAndChooseBtnTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textField addSubview:self.textFieldTopChooseBtn];
        [self.contentView addSubview:self.textFieldRightImg];
        [self cellHaverChooseBtnUI];
    }
    return self;
}
- (void)cellHaverChooseBtnUI{
    [_textFieldTopChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textFieldTopChooseBtn.superview);
    }];
    [_textFieldRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textFieldRightImg.mas_centerY);
        make.right.equalTo(_textFieldRightImg.superview.mas_right).offset(-10);
        make.height.equalTo(_textFieldRightImg.superview.mas_height);
        make.width.offset(5);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.equalTo(self.titleLabel.mas_height);
        make.left.equalTo(self.titleLabel.mas_right).offset(1);
        make.right.equalTo(_textFieldRightImg.mas_left).offset(-2);
    }];
    
}
- (UIButton *)textFieldTopChooseBtn{
    if (!_textFieldTopChooseBtn) {
        _textFieldTopChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _textFieldTopChooseBtn.backgroundColor = [UIColor clearColor];
    }
    return _textFieldTopChooseBtn;
}
- (UIImageView *)textFieldRightImg{
    if (!_textFieldRightImg) {
        _textFieldRightImg = [[UIImageView alloc]init];
        _textFieldRightImg.contentMode = UIViewContentModeScaleAspectFit;
        if ([ThemeManager shareManager].type==ThemeType_White) {
            _textFieldRightImg.image= [UIImage imageNamed:@"rightSkip"];
        }else{
            _textFieldRightImg.image= [UIImage imageNamed:@"rightSkip_white"];
        }
    }
    return _textFieldRightImg;
}
@end


#pragma mark =================================================================================================
@implementation HouseRepairEditCellSubTextFieldOnlyShowTitleTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField.hidden = YES;
        self.lineView.hidden = YES;
    }
    return self;
}
@end

#pragma mark =================================================================================================
@implementation HouseRepairEditCellSubTwoChooseBtnTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineView.hidden = NO;
        [self.contentView addSubview:self.personTypeBtn];
        [self.contentView addSubview:self.publishTypeBtn];
        [self btnsUI];
        self.personTypeBtn.selected = YES;
        self.publishTypeBtn.selected = NO;
        
    }
    return self;
}
- (void)btnsUI{
    [_publishTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textField.mas_right);
        make.height.centerY.equalTo(self.textField);
        make.width.offset(80);
    }];
    [_personTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(_publishTypeBtn);
        make.right.equalTo(_publishTypeBtn.mas_left).offset(-20);
    }];
}

#pragma mark ==
- (UIButton *)personTypeBtn{
    if (!_personTypeBtn) {
        _personTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_personTypeBtn newAnBtnWithFont:[UIFont systemFontOfSize:12]];
        [_personTypeBtn newAnBtnWithTextColor:[ [ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]];
        [_personTypeBtn newAnBtnWithTextStr:@"个人报修"];
        [_personTypeBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"category_default"] selectedImg:[UIImage imageNamed:@"category_Select"]];
        [_personTypeBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        _personTypeBtn.tag = 200;
        [_personTypeBtn addTarget:self action:@selector(changeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _personTypeBtn;
}
- (UIButton *)publishTypeBtn{
    if (!_publishTypeBtn) {
        _publishTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publishTypeBtn newAnBtnWithFont:[UIFont systemFontOfSize:12]];
        [_publishTypeBtn newAnBtnWithTextColor:[ [ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]];
        [_publishTypeBtn newAnBtnWithTextStr:@"公共报修"];
        [_publishTypeBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"category_default"] selectedImg:[UIImage imageNamed:@"category_Select"]];
        [_publishTypeBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        _publishTypeBtn.tag = 201;
        [_publishTypeBtn addTarget:self action:@selector(changeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishTypeBtn;
}
- (void)changeTypeAction:(UIButton *)sender{
    if (sender.selected==YES) {
        return;
    }
    NSInteger indx = sender.tag-200;
    if (indx==0) {//个人
        _personTypeBtn.selected = YES;
        _publishTypeBtn.selected = NO;
    }else{ //公共
        _personTypeBtn.selected = NO;
        _publishTypeBtn.selected = YES;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chooseBtnWithRepairType:)]) {
        [_delegate chooseBtnWithRepairType:indx];
    }
}

@end




