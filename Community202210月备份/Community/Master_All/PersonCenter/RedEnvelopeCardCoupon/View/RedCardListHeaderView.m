//
//  RedCardListHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import "RedCardListHeaderView.h"

@implementation RedCardListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftBtn];
        [self addSubview:self.centerBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.leftNumL];
        [self addSubview:self.centerNumL];
        [self addSubview:self.rightsNumL];
        [self setUI];
        self.leftBtn.selected = YES;
        self.centerBtn.selected = NO;
        self.rightBtn.selected = NO;
    }
    return self;
}
- (void)setUI{
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftBtn.superview).offset(16);
        make.centerY.equalTo(_leftBtn.superview);
        make.height.offset(30);
        make.width.offset(80);
    }];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftBtn.mas_right);
        make.top.bottom.width.equalTo(_leftBtn);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerBtn.mas_right);
        make.top.bottom.width.equalTo(_leftBtn);
    }];
    //
    [_leftNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftBtn.mas_centerX).offset(20);
        make.top.equalTo(_leftBtn);
        make.height.offset(10);
        make.width.mas_greaterThanOrEqualTo(_leftNumL.mas_height);
    }];
    [_centerNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerBtn.mas_centerX).offset(25);
        make.top.equalTo(_centerBtn);
        make.height.offset(10);
        make.width.mas_greaterThanOrEqualTo(_centerNumL.mas_height);
    }];
    [_rightsNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rightBtn.mas_centerX).offset(20);
        make.top.equalTo(_rightBtn);
        make.height.offset(10);
        make.width.mas_greaterThanOrEqualTo(_rightsNumL.mas_height);
    }];
}

#pragma mark==
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn newAnBtnWithFont:FontSize_Vip_Bold(17)];
        [_leftBtn newAnBtnWithTextStr:@"全部"];
        [_leftBtn newAnBtnWithTextColorNomal:Color_153GrayColor withTextColorSelected:Color_38BlueColor];
        [_leftBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.tag =  RedCardListHeaderView_subType_All+200;
    }
    return _leftBtn;
}
- (UIButton *)centerBtn{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerBtn newAnBtnWithFont:FontSize_Vip_Bold(17)];
        [_centerBtn newAnBtnWithTextStr:@"优惠券"];
        [_centerBtn newAnBtnWithTextColorNomal:Color_153GrayColor withTextColorSelected:Color_38BlueColor];
        [_centerBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _centerBtn.tag =  RedCardListHeaderView_subType_YouhuiQuan+200;
    }
    return _centerBtn;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn newAnBtnWithFont:FontSize_Vip_Bold(17)];
        [_rightBtn newAnBtnWithTextStr:@"卡包"];
        [_rightBtn newAnBtnWithTextColorNomal:Color_153GrayColor withTextColorSelected:Color_38BlueColor];
        [_rightBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.tag =  RedCardListHeaderView_subType_KaQuan+200;
    }
    return _rightBtn;
}
//
- (UILabel *)leftNumL{
    if (!_leftNumL) {
        _leftNumL = [[UILabel alloc]init];
        _leftNumL.textColor = Color_153GrayColor;
        _leftNumL.font = FontSize_Vip_Nomail(10);
    }
    return _leftNumL;
}

- (UILabel *)centerNumL{
    if (!_centerNumL) {
        _centerNumL = [[UILabel alloc]init];
        _centerNumL.textColor = Color_153GrayColor;
        _centerNumL.font = FontSize_Vip_Nomail(10);
    }
    return _centerNumL;
}
- (UILabel *)rightsNumL{
    if (!_rightsNumL) {
        _rightsNumL = [[UILabel alloc]init];
        _rightsNumL.textColor = Color_153GrayColor;
        _rightsNumL.font = FontSize_Vip_Nomail(10);
    }
    return _rightsNumL;
}
#pragma mark ==
- (void)fillData:(NSMutableArray *)dataSourceArr{
    self.leftNumL.text = @"3";
    self.centerNumL.text  = @"2";
    self.rightsNumL.text  = @"1";
}
- (void)subBtnAction:(UIButton *)sender{
    if (sender.selected == YES) {
        return;
    }
    [self subviewsReNewSelectedUIwith:sender];
    if (_delegate &&  [_delegate respondsToSelector:@selector(headerViewChangeTypeWith:)]) {
        [_delegate headerViewChangeTypeWith:(sender.tag-200)];
    }
}
- (void)subviewsReNewSelectedUIwith:(UIButton *)sender{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag==sender.tag) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }
    }]; 
}

@end
