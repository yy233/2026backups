//
//  ChongzhiTixianVcTextFieldTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import "ChongzhiTixianVcTextFieldTableViewCell.h"

@implementation ChongzhiTixianVcTextFieldTableViewCell

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
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        [self.backView addSubview:self.leftL];
        [self.backView addSubview:self.textField];
        [self.backView addSubview:self.lineV];
        [self.backView addSubview:self.bottomTipL];
        [self.backView addSubview:self.allTixianBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(_lineV.superview);
        make.height.offset(1);
    }];
    //
    [_leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_leftL.superview);
        make.width.offset(20);
        make.bottom.equalTo(_lineV.mas_top);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftL.mas_right);
        make.right.top.equalTo(_textField.superview);
        make.bottom.equalTo(_lineV.mas_top);
    }];
    //
    [_bottomTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineV.mas_bottom);
        make.left.bottom.equalTo(_bottomTipL.superview);
    }];
    [_allTixianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_bottomTipL);
        make.left.equalTo(_bottomTipL.mas_right).offset(10);
        make.width.offset(70);
    }];
    
}
- (UILabel *)leftL{
    if (!_leftL) {
        _leftL = [[UILabel alloc]init];
        _leftL.text = @"¥";
//        _leftL.textColor = [UIColor blackColor];
        _leftL.font = FontSize_MoneyWallet_Bold(20);
        _leftL.textAlignment = NSTextAlignmentCenter;
    }
    _leftL.textColor = [ThemeManager shareManager].mainTextColor;

    return _leftL;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
//        _textField.placeholder = @"请输入金额";
    }
    _textField.textColor = [ThemeManager shareManager].mainTextColor;
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入金额" attributes:@{NSForegroundColorAttributeName: [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]}];
    _textField.attributedPlaceholder = placeholderString;
    return _textField;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = [ThemeManager shareManager].themeLineColor;
    }
    return _lineV;
}
- (UILabel *)bottomTipL{
    if (!_bottomTipL) {
        _bottomTipL = [[UILabel alloc]init];
        _bottomTipL.textColor = COlor_Red255;
        _bottomTipL.font = FontSize_Vip_Nomail(12);
    }
    return _bottomTipL;
}
- (UIButton *)allTixianBtn{
    if (!_allTixianBtn) {
        _allTixianBtn = [[UIButton alloc]init];
        [_allTixianBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(12)];
        [_allTixianBtn newAnBtnWithTextStr:@"全部提现"];
//        [_allTixianBtn addTarget:self action:@selector(allTixianBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
//    [_allTixianBtn newAnBtnWithTextColor:Y_RGBA(125, 138, 162, 1)];
    [_allTixianBtn newAnBtnWithTextColor: [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]];

    return _allTixianBtn;
}
@end
