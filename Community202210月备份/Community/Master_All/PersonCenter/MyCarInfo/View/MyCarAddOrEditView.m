//
//  MyCarAddOrEditView.m
//  Community
//
//  Created by 余莹 on 2021/8/5.
//

#import "MyCarAddOrEditView.h"

@interface MyCarAddOrEditView ()

 
@end

@implementation MyCarAddOrEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.textFieldBackV];
        [self.textFieldBackV addSubview:self.textF];
        [self.textFieldBackV addSubview:self.textFTopTuchBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView.superview).offset(20);
        make.left.equalTo(_backView.superview).offset(16);
        make.right.equalTo(_backView.superview).offset(-16);
        make.height.offset(120);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.left.equalTo(_titleL.superview).offset(20);
        make.right.equalTo(_titleL.superview).offset(-20);
        make.top.equalTo(_titleL.superview).offset(10);
    }];
    [_textFieldBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(36);
        make.left.equalTo(_textFieldBackV.superview).offset(20);
        make.right.equalTo(_textFieldBackV.superview).offset(-20);
        make.bottom.equalTo(_textFieldBackV.superview).offset(-20);
    }];
    [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textF.superview).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    [_textFTopTuchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textF);
    }];
}
#pragma mark ==
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
//        _backView.backgroundColor = Color_11BlueColor;
        _backView.layer.cornerRadius = 5;
    }
    _backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    return _backView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:15];
        _titleL.text = @"请输入有效车牌";
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleL;
}
- (UIView *)textFieldBackV{
    if (!_textFieldBackV) {
        _textFieldBackV = [[UIView alloc]init];
        _textFieldBackV.layer.cornerRadius = 5;
        _textFieldBackV.layer.borderWidth = 1;
        _textFieldBackV.layer.borderColor = Y_ColorWith16FromRGB(0x486AAA).CGColor;
    }
    return _textFieldBackV;
}
- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.clearButtonMode = UITextFieldViewModeWhileEditing;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入有效的车牌号" attributes:@{NSForegroundColorAttributeName:  Y_ColorWith16FromRGB(0xA8BCDE) }];
        _textF.attributedPlaceholder = placeholderString;
        _textF.font  = [UIFont systemFontOfSize:15];
        _textF.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _textF;
}
- (UIButton *)textFTopTuchBtn{
    if (!_textFTopTuchBtn) {
        _textFTopTuchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _textFTopTuchBtn;
}
@end
