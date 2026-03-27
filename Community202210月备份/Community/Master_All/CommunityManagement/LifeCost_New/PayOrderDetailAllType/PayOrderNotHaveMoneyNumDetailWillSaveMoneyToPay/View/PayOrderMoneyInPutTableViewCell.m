//
//  PayOrderMoneyInPutTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/1/8.
//

#import "PayOrderMoneyInPutTableViewCell.h"

#define H_SubBtn   (35)
#define W_SubBtn   (80)
@implementation PayOrderMoneyInPutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 @property (nonatomic,strong) UIView *lineV;
 @property (nonatomic,strong) UILabel *leftL;
 @property (nonatomic,strong) UITextField *textField;
 @property (nonatomic,strong) UIView *lineVCenter;
 //
 @property (nonatomic,strong) UIView *subMoneyNumBtnsBackView;
 
 */

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.lineV];
        [self.contentView addSubview:self.lineVCenter];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.leftL];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.subMoneyNumBtnsBackView];
        [self setUI];
        [self subMoneyNumBtnsBackViewUI];//固定金额按钮

    }
    return self;
}
- (void)subBtnAction:(UIButton *)sender{
    NSInteger index = sender.tag-200;
    NSArray *moneyOnlyHaveNumArr = @[@"50",@"100",@"150"];
    //UI
    for (UIButton *subBtn in self.subMoneyNumBtnsBackView.subviews) {
        if (subBtn.tag == sender.tag) {
            subBtn.selected = YES;
        }else{
            subBtn.selected = NO;
        }
    }
    //协议
    if (_delegate && [_delegate respondsToSelector:@selector(touchMoneyNumBtnWithMoneyStr:)]) {
        [_delegate touchMoneyNumBtnWithMoneyStr: moneyOnlyHaveNumArr[index]];
    }
}
- (void)subMoneyNumBtnsBackViewUI{
    [self.subMoneyNumBtnsBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *moneyNumArr = @[@"50元",@"100元",@"150元"];
    for (int i = 0; i < moneyNumArr.count ; i++) {
        UIButton *baseBtn = [self baseBtn];
        baseBtn.tag = 200+i;
        baseBtn.frame = CGRectMake(16+(W_SubBtn+10)*i, 25, W_SubBtn, H_SubBtn);
        [baseBtn newAnBtnWithTextStr: moneyNumArr[i]];
        [self.subMoneyNumBtnsBackView addSubview:baseBtn];
    }
}
 
- (UIButton *)baseBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn newAnBtnWithFont: [UIFont boldSystemFontOfSize:15.0]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:Color_Blue] forState:UIControlStateSelected];
    [btn setTitleColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    btn.layer.borderColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 2.5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    return btn;
}
- (void)setUI{
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineV.superview).offset(15);
        make.right.equalTo(_lineV.superview).offset(-15);
        make.top.equalTo(_lineV.superview);
        make.height.offset(1);
    }];
    //
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineV);
        make.top.equalTo(_lineV.mas_bottom).offset(10);
        make.height.offset(20);
        make.width.offset(100);
    }];
    //
    [_leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineV);
        make.top.equalTo(_titleL.mas_bottom).offset(20);
        make.width.height.offset(20);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftL.mas_right);
        make.right.equalTo(_textField.superview);
        make.height.offset(35);
        make.centerY.equalTo(_leftL);
    }];
    //
    [_lineVCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_lineV);
        make.top.equalTo(_textField.mas_bottom).offset(15);
        make.height.offset(0.5);
    }];
    [_subMoneyNumBtnsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineVCenter.mas_bottom);
        make.left.right.bottom.equalTo(_subMoneyNumBtnsBackView.superview);
    }];
}
#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"输入金额";
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:15.0];
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}

- (UILabel *)leftL{
    if (!_leftL) {
        _leftL = [[UILabel alloc]init];
        _leftL.text = @"¥";
        _leftL.textColor = [ThemeManager shareManager].mainTextColor;
        _leftL.font =  [UIFont boldSystemFontOfSize:20.0];
        _leftL.textAlignment = NSTextAlignmentCenter;
    }
    return _leftL;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.textColor = [ThemeManager shareManager].mainTextColor;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入缴费金额" attributes:@{NSForegroundColorAttributeName: [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]}];
        _textField.attributedPlaceholder = placeholderString;
     }
    return _textField;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = [ThemeManager shareManager].themeLineColor;
    }
    return _lineV;
}
- (UIView *)lineVCenter{
    if (!_lineVCenter) {
        _lineVCenter = [[UIView alloc]init];
        _lineVCenter.backgroundColor = [ThemeManager shareManager].themeLineColor;
    }
    return _lineVCenter;
}
- (UIView *)subMoneyNumBtnsBackView{
    if (!_subMoneyNumBtnsBackView) {
        _subMoneyNumBtnsBackView = [[UIView alloc]init];
    }
    return _subMoneyNumBtnsBackView;
}
@end
