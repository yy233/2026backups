//
//  PopTimeSubBtnView.m
//  Community
//
//  Created by 余莹 on 2020/12/7.
//

#import "PopTimeSubBtnView.h"
#define BtnTextColor_Nomal Y_RGBA(170, 174, 185, 1)
#define BtnTextColor_Selecd [UIColor whiteColor]
#define BtnTextColor_Highlighted  Y_RGBA(43, 44, 47, 1)

#define BtnBackColor_Nomal [UIColor clearColor]
#define BtnBackColor_Selecd Y_RGBA(38, 114, 249, 1)
#define BtnBackColor_Highlighted Y_RGBA(235, 241, 253, 1)
@interface PopTimeSubBtnView  ()
@property (nonatomic,strong) UIView *backView;
//@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *endTitleLabel;
@end
@implementation PopTimeSubBtnView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.btn];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.endTitleLabel];
        [self setUI];
    }
    return self;
}
#pragma mark ====
- (void)setBtnViewType:(PopTimeSubBtnView_Type)type{
    if (type==PopTimeSubBtnView_Type_Nomal) {
        _backView.backgroundColor = [UIColor whiteColor];
        [_btn setTitleColor:BtnTextColor_Nomal forState:UIControlStateNormal];
        [_btn setBackgroundImage:[UIImage imageWithColor:BtnBackColor_Nomal] forState:UIControlStateNormal];
        _titleLabel.hidden = YES;
        _endTitleLabel.hidden = YES;
    }else if (type==PopTimeSubBtnView_Type_Seleced_Begin){
        self.backView.backgroundColor = [UIColor whiteColor];
        [_btn setTitleColor:BtnTextColor_Selecd forState:UIControlStateSelected];
        [_btn setBackgroundImage:[UIImage imageWithColor:BtnBackColor_Selecd] forState:UIControlStateSelected];
        _titleLabel.hidden = NO;
        _endTitleLabel.hidden = YES;
    }else if (type==PopTimeSubBtnView_Type_Seleced_End){
        _backView.backgroundColor = [UIColor whiteColor];
        [_btn setTitleColor:BtnTextColor_Selecd forState:UIControlStateSelected];
        [_btn setBackgroundImage:[UIImage imageWithColor:BtnBackColor_Selecd] forState:UIControlStateSelected];
        _titleLabel.hidden = YES;
        _endTitleLabel.hidden = NO;
    }else if (type==PopTimeSubBtnView_Type_HeightLight){
        _backView.backgroundColor = BtnBackColor_Highlighted;
        [_btn setTitleColor:BtnTextColor_Highlighted forState:UIControlStateHighlighted];//高亮状态 多选的状态 中间部分days颜色
        [_btn setBackgroundImage:[UIImage imageWithColor:BtnBackColor_Highlighted] forState:UIControlStateHighlighted];
        _titleLabel.hidden = YES;
        _endTitleLabel.hidden = YES;
    }
    
}
#pragma mark ====
- (void)setUI{
    _titleLabel.hidden = YES;
    _endTitleLabel.hidden = YES;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_btn.superview);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top);
        make.left.equalTo(_titleLabel.superview.mas_left);
        make.right.equalTo(_titleLabel.superview.mas_right);
        make.height.equalTo(_titleLabel.superview.mas_height).multipliedBy(0.4);
    }];
    [_endTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endTitleLabel.superview.mas_top);
        make.left.equalTo(_endTitleLabel.superview.mas_left);
        make.right.equalTo(_endTitleLabel.superview.mas_right);
        make.height.equalTo(_endTitleLabel.superview.mas_height).multipliedBy(0.4);
    }];
}
#pragma marlk ==
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor  = [UIColor whiteColor];
    }
    return _backView;
}
- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_btn setTitle:@"" forState:UIControlStateNormal];
//        [_btn setTitle:@"" forState:UIControlStateSelected];
        [_btn setTitleColor:BtnTextColor_Nomal forState:UIControlStateNormal];
        [_btn setTitleColor:BtnTextColor_Selecd forState:UIControlStateSelected];
        [_btn setTitleColor:BtnTextColor_Highlighted forState:UIControlStateHighlighted];//高亮状态 多选的状态 中间部分days颜色
        [_btn setBackgroundImage:[UIImage imageWithColor:BtnBackColor_Nomal] forState:UIControlStateNormal];
        [_btn setBackgroundImage:[UIImage imageWithColor:BtnBackColor_Selecd] forState:UIControlStateSelected];
        [_btn setBackgroundImage:[UIImage imageWithColor:BtnBackColor_Highlighted] forState:UIControlStateHighlighted];
        _btn.titleLabel.font = [UIFont systemFontOfSize:15];
        _btn.layer.cornerRadius = 10;
        _btn.layer.masksToBounds = YES;
    }
    return _btn;
}
 
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"访客";//
        _titleLabel.font = [UIFont systemFontOfSize:9];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.tag = 150;
    }
    return _titleLabel;
}
- (UILabel *)endTitleLabel{
    if (!_endTitleLabel) {
        _endTitleLabel = [[UILabel alloc]init];
        _endTitleLabel.text = @"结束";//结束
        _endTitleLabel.font = [UIFont systemFontOfSize:9];
        _endTitleLabel.textColor = [UIColor whiteColor];
        _endTitleLabel.textAlignment = NSTextAlignmentCenter;
        _endTitleLabel.tag = 151;
    }
    return _endTitleLabel;
}

@end
