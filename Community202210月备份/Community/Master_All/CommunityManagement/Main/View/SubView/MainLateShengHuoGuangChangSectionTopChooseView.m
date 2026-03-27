//
//  MainLateShengHuoGuangChangSectionTopChooseView.m
//  Community
//
//  Created by 余莹 on 2021/8/2.
//

#import "MainLateShengHuoGuangChangSectionTopChooseView.h"

@implementation MainLateShengHuoGuangChangSectionTopChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.oneBtn];
        [self addSubview:self.twoBtn];
        [self setUI];
        self.oneBtn.selected = YES;
        self.twoBtn.selected = NO;
    }
    return self;
}
 
- (void)setTheme{
    [_oneBtn newAnBtnWithTextColorNomal:[ThemeManager shareManager].mainTextColor withTextColorSelected:Color_38BlueColor];
    [_twoBtn newAnBtnWithTextColorNomal:[ThemeManager shareManager].mainTextColor withTextColorSelected:Color_38BlueColor];

}
- (void)setUI{
    [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_oneBtn.superview);
        make.width.equalTo(_oneBtn.superview).multipliedBy(0.3);
        make.height.equalTo(_oneBtn.superview);
        make.left.equalTo(_oneBtn.superview);
    }];
    [_twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_twoBtn.superview);
        make.width.equalTo(_twoBtn.superview).multipliedBy(0.3);
        make.height.equalTo(_twoBtn.superview);
        make.left.equalTo(_oneBtn.mas_right);
    }];
}
- (UIButton *)oneBtn{
    if (!_oneBtn) {
        _oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneBtn newAnBtnWithTextStr:@"租房"];
        [_oneBtn addTarget:self action:@selector(oneTouchAction) forControlEvents:UIControlEventTouchUpInside];
        //下图颜色
        UIImage *nomalImg = [ImgSetSize setimageSize:[UIImage imageWithColor:[UIColor clearColor]] width:20 height:3];
        UIImage *selectedImg = [ImgSetSize setimageSize:[UIImage imageWithColor:Color_38BlueColor] width:20 height:3];
        [_oneBtn setImage:nomalImg forState:UIControlStateNormal];
        [_oneBtn setImage:selectedImg forState:UIControlStateSelected];
        //图上文下
        [_oneBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleBottom imageTitleSpace:10];
    }
    [_oneBtn newAnBtnWithTextColorNomal:[ThemeManager shareManager].mainTextColor withTextColorSelected:Color_38BlueColor];

    return _oneBtn;
}

- (UIButton *)twoBtn{
    if (!_twoBtn) {
        _twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twoBtn newAnBtnWithTextStr:@"集市"];
        [_twoBtn addTarget:self action:@selector(twoTouchAction) forControlEvents:UIControlEventTouchUpInside];
        
        //下图颜色
        UIImage *nomalImg = [ImgSetSize setimageSize:[UIImage imageWithColor:[UIColor clearColor]] width:20 height:3];
        UIImage *selectedImg = [ImgSetSize setimageSize:[UIImage imageWithColor:Color_38BlueColor] width:20 height:3];
        [_twoBtn setImage:nomalImg forState:UIControlStateNormal];
        [_twoBtn setImage:selectedImg forState:UIControlStateSelected];
        //图上文下
        [_twoBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleBottom imageTitleSpace:5];
    }
    [_twoBtn newAnBtnWithTextColorNomal:[ThemeManager shareManager].mainTextColor withTextColorSelected:Color_38BlueColor];

    return _twoBtn;
}
- (void)oneTouchAction{
    if (_oneBtn.selected) {
        return;
    }
    [self fillTypeWithIsZuFangOneBtnSelectedBoolShow:YES];

    self.btnTouchBlock(MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang);
}
- (void)twoTouchAction{
    if (_twoBtn.selected) {
        return;
    }
    [self fillTypeWithIsZuFangOneBtnSelectedBoolShow:NO];
    self.btnTouchBlock(MainLateShengHuoGuangChangCell_TopHeader_Type_ErShou);
}

#pragma mark ==
- (void)fillTypeWithIsZuFangOneBtnSelectedBoolShow:(BOOL)isZuFangBool{
    if (isZuFangBool) {
        _oneBtn.selected = YES;
        _twoBtn.selected = NO;
    }else{
        _twoBtn.selected = YES;
        _oneBtn.selected = NO;
    }
}
@end
