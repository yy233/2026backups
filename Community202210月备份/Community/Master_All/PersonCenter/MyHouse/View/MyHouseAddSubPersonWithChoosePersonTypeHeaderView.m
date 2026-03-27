//
//  MyHouseAddSubPersonWithChoosePersonTypeHeaderView.m
//  Community
//
//  Created by 余莹 on 2022/4/25.
//

#import "MyHouseAddSubPersonWithChoosePersonTypeHeaderView.h"

static CGFloat selfOneCell_Height = 50.0;
#define TextNoInfo_Color   Y_ColorWith16FromRGB(0xC5C6C8)
@interface MyHouseAddSubPersonWithChoosePersonTypeHeaderView ()
//@property (nonatomic,strong) NSMutableArray *relationTypeArr;

@end

@implementation MyHouseAddSubPersonWithChoosePersonTypeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, selfOneCell_Height);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.centerBackV];
        [self.centerBackV addSubview:self.showPersonTypeL];
        [self.centerBackV addSubview:self.allowImgV];
        [self.centerBackV addSubview:self.touchUseTopBtn];
        [self addSubview:self.relationBackV];
        [self.relationBackV addSubview:self.oneBtn];
        [self.relationBackV addSubview:self.twoBtn];
        [self setUI];
        self.relationBackV.hidden = YES;
    }
    return self;
}

- (void)showChooseViews{
    self.frame = CGRectMake(0, 0, Screen_W, selfOneCell_Height*3);
    self.relationBackV.hidden = NO;
    self.showPersonTypeL.text = @"请选择成员身份";
    self.showPersonTypeL.textColor = TextNoInfo_Color;
}

- (void)hiddenChooseViews{
    self.frame = CGRectMake(0, 0, Screen_W, selfOneCell_Height);
    self.relationBackV.hidden = YES;
    self.showPersonTypeL.textColor = [ThemeManager shareManager].mainTextColor;
}
 
- (void)setUI{
    //
    [_centerBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerBackV.superview);
        make.width.equalTo(_centerBackV.superview).offset(-32);
        make.height.offset(selfOneCell_Height);
        make.top.equalTo(_centerBackV.superview);
    }];
    [_showPersonTypeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_showPersonTypeL.superview);
        make.height.offset(20);
        make.left.equalTo(_showPersonTypeL.superview).offset(15);
    }];
    [_allowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(16);
        make.height.offset(8);
        make.right.equalTo(_allowImgV.superview).offset(-15);
        make.centerY.equalTo(_allowImgV.superview);
    }];
    [_touchUseTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_centerBackV);
    }];
    
    //5的layer 需要遮住
    [_relationBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerBackV);
        make.top.equalTo(_centerBackV.mas_bottom).offset(-5.0);
        make.height.offset(2*selfOneCell_Height+5.0);
    }];
    [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_relationBackV);
        make.height.offset(selfOneCell_Height+5.0);
        make.top.equalTo(_relationBackV);
    }];
    [_twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_oneBtn);
        make.top.equalTo(_oneBtn.mas_bottom);
    }];
}

#pragma mark ==
- (UIView *)centerBackV{
    if (!_centerBackV) {
        _centerBackV = [[UIView alloc]init];
        _centerBackV.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        _centerBackV.layer.cornerRadius = 5.0;
        _centerBackV.layer.masksToBounds = YES;
    }
    return _centerBackV;
}
- (UILabel *)showPersonTypeL{
    if (!_showPersonTypeL) {
        _showPersonTypeL = [[UILabel alloc]init];
        _showPersonTypeL.text = @"请选择成员身份";
        _showPersonTypeL.font = [UIFont systemFontOfSize:15.0];
        _showPersonTypeL.textColor = TextNoInfo_Color;
    }
    return _showPersonTypeL;
}
- (UIImageView *)allowImgV{
    if (!_allowImgV) {
        _allowImgV = [[UIImageView alloc]init];
        _allowImgV.image = [UIImage imageNamed:@"cyxl_icon"];
        
    }
    return _allowImgV;
}
- (UIButton *)touchUseTopBtn{
    if (!_touchUseTopBtn) {
        _touchUseTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _touchUseTopBtn;
}

- (UIView *)relationBackV{
    if (!_relationBackV) {
        _relationBackV = [[UIView alloc]init];
        _relationBackV.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;

    }
    return _relationBackV;
}
- (UIButton *)oneBtn{
    if (!_oneBtn) {
        _oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneBtn newAnBtnWithFont:[UIFont systemFontOfSize:15.0]];
        [_oneBtn newAnBtnWithTextStr:@"家属"];
        [_oneBtn newAnBtnWithTextColor: [ThemeManager shareManager].mainTextColor];
    }
    return _oneBtn;
}
- (UIButton *)twoBtn{
    if (!_twoBtn) {
        _twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twoBtn newAnBtnWithFont:[UIFont systemFontOfSize:15.0]];
        [_twoBtn newAnBtnWithTextStr:@"租客"];
        [_twoBtn newAnBtnWithTextColor: [ThemeManager shareManager].mainTextColor];

    }
    return _twoBtn;
}


@end
