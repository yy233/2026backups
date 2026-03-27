//
//  AdviceView.m
//  Community
//
//  Created by 余莹 on 2020/12/28.
//

#import "AdviceView.h"

@interface AdviceView ()<UITextViewDelegate>
//@property (nonatomic,strong) UIView *backView;
//@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) UIView *lineView;
//@property (nonatomic,strong) UILabel *textviewTopPlaceholdeLabel;
//@property (nonatomic,strong) BaseTableViewFooterView *footerView;
//@property (nonatomic,strong) UIButton *complaintsBtn;//投诉
//@property (nonatomic,strong) UIButton *adviceBtn;//建议
//@property (nonatomic,strong) UITextView *textView;


 
@end
@implementation AdviceView
 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self addSubview:self.footerView];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.complaintsBtn];
        [self.backView addSubview:self.adviceBtn];
        self.complaintsBtn.selected = YES;
        self.adviceBtn.selected = NO;
        [self.backView addSubview:self.lineView];
        [self.backView addSubview:self.textView];
        [self.textView addSubview:self.textviewTopPlaceholdeLabel];
        [self.backView addSubview:self.allImgBackView];
        [self setUI];
    }
    return self;
}
//状态变
- (void)complaintsBtnAction:(UIButton *)sender{
    if (sender.selected==YES) {
        return;
    }else{
        sender.selected = YES;
        self.adviceBtn.selected = NO;
    }
    
}
- (void)adviceBtnAction:(UIButton *)sender{
    if (sender.selected==YES) {
        return;
    }else{
        sender.selected = YES;
        self.complaintsBtn.selected = NO;
    }
}
#pragma mark === textViewDidChange
- (void)textViewDidChange:(UITextView *)textView{
    if (self.textView.text.length<=0) {
        self.textviewTopPlaceholdeLabel.hidden = NO;
    }else{
        self.textviewTopPlaceholdeLabel.hidden = YES;
    }
}
#pragma mark ===
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView.superview.mas_top).offset(20);
        make.left.equalTo(_backView.superview.mas_left).offset(16);
        make.right.equalTo(_backView.superview.mas_right).offset(-16);
        make.height.equalTo(_backView.superview.mas_height).multipliedBy(0.5);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView.mas_bottom).offset(10);
        make.left.equalTo(_footerView.superview.mas_left).offset(16);
        make.right.equalTo(_footerView.superview.mas_right).offset(-16);
        make.height.offset(80);
    }];
    [self setTopViewUI];
}
- (void)setTopViewUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(10);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(16);
        make.width.equalTo(_titleLabel.superview.mas_width).multipliedBy(0.5);
        make.height.offset(20);
    }];
    [_complaintsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.left.equalTo(_titleLabel.mas_right).offset(10);
        make.width.offset(60);
        make.height.offset(20);
    }];
    [_adviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.left.equalTo(_complaintsBtn.mas_right).offset(10);
        make.width.offset(60);
        make.height.offset(20);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_lineView.superview.mas_left).offset(16);
        make.right.equalTo(_lineView.superview.mas_right).offset(-16);
        make.height.offset(1);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(10);
        make.left.equalTo(_textView.superview.mas_left).offset(16);
        make.right.equalTo(_textView.superview.mas_right).offset(-16);
        make.height.equalTo(_backView.mas_height).multipliedBy(0.4);
    }];
    [_textviewTopPlaceholdeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textviewTopPlaceholdeLabel.superview.mas_top).offset(8);
        make.left.equalTo(_textviewTopPlaceholdeLabel.superview.mas_left).offset(10);
        make.right.equalTo(_textviewTopPlaceholdeLabel.superview.mas_right).offset(-10);
        make.height.offset(15);
    }];
    [_allImgBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).offset(10); 
        make.left.equalTo(_allImgBackView.superview.mas_left).offset(16);
        make.right.equalTo(_allImgBackView.superview.mas_right).offset(-16);
        make.bottom.equalTo(_allImgBackView.superview.mas_bottom);
    }];
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
        _backView.layer.cornerRadius = 10;
    }
    return _backView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 44)];
        [_footerView.footerBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    return _footerView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"评价";
    }
    return _titleLabel;
}
//        Selectgroup_Select_night Selectgroup_Default_night
- (UIButton *)complaintsBtn{
    if (!_complaintsBtn) {
        _complaintsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _complaintsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14]; 
//        [_complaintsBtn setTitle:@"投诉" forState:UIControlStateNormal];
        [_complaintsBtn setTitle:@"好评" forState:UIControlStateNormal];
        [_complaintsBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_complaintsBtn addTarget:self action:@selector(complaintsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([ThemeManager shareManager].type==ThemeType_White) {
            [_complaintsBtn setImage:[UIImage imageNamed:@"Selectgroup_Default_night"] forState:UIControlStateNormal];//whit 待改
            [_complaintsBtn setImage:[UIImage imageNamed:@"Selectgroup_Select_night"] forState:UIControlStateSelected];
        }else{
            [_complaintsBtn setImage:[UIImage imageNamed:@"Selectgroup_Default_night"] forState:UIControlStateNormal];
            [_complaintsBtn setImage:[UIImage imageNamed:@"Selectgroup_Select_night"] forState:UIControlStateSelected];
        }
        [_complaintsBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _complaintsBtn;
}
- (UIButton *)adviceBtn{
    if (!_adviceBtn) {
        _adviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _adviceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//        [_adviceBtn setTitle:@"建议" forState:UIControlStateNormal];
        [_adviceBtn setTitle:@"差评" forState:UIControlStateNormal];
        [_adviceBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_adviceBtn addTarget:self action:@selector(adviceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([ThemeManager shareManager].type==ThemeType_White) {
            [_adviceBtn setImage:[UIImage imageNamed:@"Selectgroup_Default_night"] forState:UIControlStateNormal];//whit 待改
            [_adviceBtn setImage:[UIImage imageNamed:@"Selectgroup_Select_night"] forState:UIControlStateSelected];
        }else{
            [_adviceBtn setImage:[UIImage imageNamed:@"Selectgroup_Default_night"] forState:UIControlStateNormal];
            [_adviceBtn setImage:[UIImage imageNamed:@"Selectgroup_Select_night"] forState:UIControlStateSelected];
        }
        [_adviceBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _adviceBtn;
}

- (UIView *)allImgBackView{
    if (!_allImgBackView) {
        _allImgBackView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, Screen_W-32, 100)];
    }
    return _allImgBackView;
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
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        _textView.textColor = [ThemeManager shareManager].mainTextColor;
        _textView.layer.cornerRadius = 5;
        _textView.delegate = self;
    }
    return _textView;
}
- (UILabel *)textviewTopPlaceholdeLabel {
    if (!_textviewTopPlaceholdeLabel) {
        _textviewTopPlaceholdeLabel = [[UILabel alloc]init];
        _textviewTopPlaceholdeLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _textviewTopPlaceholdeLabel.text = @"请输入您的评价";
        _textviewTopPlaceholdeLabel.font  = [UIFont systemFontOfSize:13];
    }
    return _textviewTopPlaceholdeLabel;
}
@end
