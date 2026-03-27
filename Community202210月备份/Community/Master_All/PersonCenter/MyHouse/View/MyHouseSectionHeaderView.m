//
//  MyHouseSectionView.m
//  Community
//
//  Created by 余莹 on 2021/8/3.
//

#import "MyHouseSectionHeaderView.h"

@implementation MyHouseSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = Color_11BlueColor;
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self addSubview:self.titleL];
        [self addSubview:self.managerDeletBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_titleL.superview).offset(16);
        make.top.bottom.equalTo(_titleL.superview);
        make.width.offset(100);
    }];
    [_managerDeletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_managerDeletBtn.superview);
        make.right.equalTo(_managerDeletBtn.superview).offset(-16);
    }];
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"关系列表";
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    return _titleL;
}

- (UIButton *)managerDeletBtn{
    if (!_managerDeletBtn) {
        _managerDeletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_managerDeletBtn newAnBtnWithTextStr:@"管理"];
//        [_managerDeletBtn newAnBtnWithTextColorNomal:Color_38BlueColor withTextColorSelected:Color_38BlueColor];// Y_ColorWith16FromRGB(0x255FFF)];
        _managerDeletBtn.selected = NO;
        [_managerDeletBtn addTarget:self action:@selector(chooseManagerBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    [_managerDeletBtn newAnBtnWithTextColor:[ThemeManager shareManager].themeTextMainColor];

    return _managerDeletBtn;
}
- (void)chooseManagerBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.managerBtnTouchUpSelectedBool(sender.selected);
}
@end

