//
//  IssueHouseManagerVcChooseHouseOrBuniessSectionView.m
//  Community
//
//  Created by 余莹 on 2021/7/10.
//

#import "IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderView.h"

@implementation IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 50);
    self = [super initWithFrame:frame];
    if (self) {
         /**
          @property (nonatomic,strong) UIButton *buniessBtn;
          @property (nonatomic,strong) UIButton *houseBtn;
          */
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self addSubview:self.buniessBtn];
        [self addSubview:self.houseBtn];
        [self addSubview:self.lineV];
        self.buniessBtn.selected = NO;
        self.houseBtn.selected = YES;//初始化显示已发房屋
        [self setUI];
        self.buniessBtn.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        self.houseBtn.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW; 
    }
    return self;
}
- (void)setUI{
    [_houseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buniessBtn.superview).offset(16);
        make.top.bottom.equalTo(_buniessBtn.superview);
        make.right.equalTo(_buniessBtn.superview.mas_centerX).offset(-0.5);
    }];
    [_buniessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_buniessBtn.superview).offset(-16);
        make.top.bottom.equalTo(_houseBtn.superview);
        make.left.equalTo(_houseBtn.superview.mas_centerX).offset(0.5);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_buniessBtn).multipliedBy(0.5);
        make.width.offset(0.5);
        make.centerX.centerY.equalTo(_lineV.superview);
    }];

}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = Y_ColorWith16FromRGB(0xC5C9D4);
    }
    return _lineV;
}
- (UIButton *)buniessBtn{
    if (!_buniessBtn) {
        _buniessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buniessBtn.backgroundColor = [UIColor whiteColor];
        _buniessBtn.layer.cornerRadius = 7.5;
//        [_buniessBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15]];
        [_buniessBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
        [_buniessBtn newAnBtnWithTextStr:@"商铺"];
//        [_buniessBtn newAnBtnWithTextColorNomal:[ThemeManager shareManager].mainTextColor withTextColorSelected:Color_38BlueColor];
        [_buniessBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor ];

        //下图颜色
        UIImage *nomalImg = [ImgSetSize setimageSize:[UIImage imageWithColor:[UIColor clearColor]] width:80 height:3];
        UIImage *selectedImg = [ImgSetSize setimageSize:[UIImage imageWithColor:Color_38BlueColor] width:80 height:3];
        [_buniessBtn setImage:nomalImg forState:UIControlStateNormal];
        [_buniessBtn setImage:selectedImg forState:UIControlStateSelected];
        //图上文下
        [_buniessBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleBottom imageTitleSpace:10];
        [_buniessBtn addTarget:self action:@selector(buniessBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buniessBtn;
}
- (UIButton *)houseBtn{
    if (!_houseBtn) {
        _houseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _houseBtn.backgroundColor = [UIColor whiteColor];
        _houseBtn.layer.cornerRadius = 7.5;
        [_houseBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15]];
        [_houseBtn newAnBtnWithTextStr:@"房屋"];
//        [_houseBtn newAnBtnWithTextColorNomal:[ThemeManager shareManager].mainTextColor withTextColorSelected:Color_38BlueColor];
        [_houseBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor ];

        //下图颜色
        UIImage *nomalImg = [ImgSetSize setimageSize:[UIImage imageWithColor:[UIColor clearColor]] width:80 height:3];
        UIImage *selectedImg = [ImgSetSize setimageSize:[UIImage imageWithColor:Color_38BlueColor] width:80 height:3];
        [_houseBtn setImage:nomalImg forState:UIControlStateNormal];
        [_houseBtn setImage:selectedImg forState:UIControlStateSelected];
        //图上文下
        [_houseBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleBottom imageTitleSpace:10];
//        [_houseBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [_houseBtn addTarget:self action:@selector(houseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _houseBtn;
}
#pragma mark ==
- (void)buniessBtnAction{
    [self delegateChooseBool:YES];
    [_buniessBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15]];
    [_houseBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
}
- (void)houseBtnAction{
    [self delegateChooseBool:NO];
    [_buniessBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
    [_houseBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15]];
}
- (void)delegateChooseBool:(BOOL)isShowBuniessList{
    if (_delegate && [_delegate respondsToSelector:@selector(chooseHouseOrBuniessSectionHeaderViewWithIsShowBuniessListBool:)]) {
        [_delegate chooseHouseOrBuniessSectionHeaderViewWithIsShowBuniessListBool:isShowBuniessList];
    }
    
}

@end
