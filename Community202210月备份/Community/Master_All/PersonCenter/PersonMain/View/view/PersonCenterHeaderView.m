//
//  PersonCenterHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/1/18.
//

#import "PersonCenterHeaderView.h"
@interface PersonCenterHeaderView ()
@property (nonatomic,strong) UIImageView *headerV;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *detailL;
@property (nonatomic,strong) UIButton *setBtn;
@property (nonatomic,strong) UIButton *infoBtn;
@property (nonatomic, strong) UIButton *blockchainIDCardButton;
@end

@implementation PersonCenterHeaderView
- (void)fillPersonInfoWithPersonInfoUseModel:(PersonInfoUseModel *)model{
    [ShareUserInfo sharedUserInfo].userInfo.nickname = [TextShowWithModelStr textShowWithModelStr:model.nickname];
    [ShareUserInfo sharedUserInfo].userInfo.avatarUrl = [TextShowWithModelStr textShowWithModelStr:model.avatarUrl];
    [ShareUserInfo sharedUserInfo].userInfo.birthdayTime = [TextShowWithModelStr textShowWithModelStr:model.birthdayTime];
    //
    _nameL.text = [ShareUserInfo sharedUserInfo].userInfo.nickname;
    _detailL.text = [NSString stringWithFormat:@"手机号：%@", [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.mobile]];
    if (model.avatarUrl.length<=0) {
         _headerV.image = [UIImage imageNamed:@"My_headportrait"];
    }else{
        [_headerV sd_setImageWithURL:[UrlWithString getURLWithStr:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    }
//    if ([ShareUserInfo sharedUserInfo].userInfo.isRealAuth == 2) {
//        self.blockchainIDCardButton.hidden = NO;
//    }
}
- (void)headerViewRefreshPersonInfo{
    _nameL.text = [ShareUserInfo sharedUserInfo].userInfo.nickname;
    _detailL.text = [NSString stringWithFormat:@"手机号：%@", [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.mobile]];
    if ([ShareUserInfo sharedUserInfo].userInfo.avatarUrl.length<=0) {
       _headerV.image = [UIImage imageNamed:@"My_headportrait"];
    }else{
        [_headerV sd_setImageWithURL:[UrlWithString getURLWithStr:[ShareUserInfo sharedUserInfo].userInfo.avatarUrl ] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    }
//    if (ZY_IsRealName) {
//        self.blockchainIDCardButton.hidden = NO;
//    }else {
//        self.blockchainIDCardButton.hidden = YES;
//    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headerV];
        [self addSubview:self.nameL];
        [self addSubview:self.detailL];
        [self addSubview:self.blockchainIDCardButton];
        [self addSubview:self.infoBtn];
        [self addSubview:self.setBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
//    _headerV.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    //
    _nameL.text = [ShareUserInfo sharedUserInfo].userInfo.nickname;
    _detailL.text = [NSString stringWithFormat:@"手机号：%@", [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.mobile]];
    if ([ShareUserInfo sharedUserInfo].userInfo.avatarUrl.length<=0) {
       _headerV.image = [UIImage imageNamed:@"My_headportrait"];
    }else{
        [_headerV sd_setImageWithURL:[UrlWithString getURLWithStr:[ShareUserInfo sharedUserInfo].userInfo.avatarUrl ] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    }
    if ([ThemeManager shareManager].type== ThemeType_White) {
    }else{
        UIImage *setImg = [[UIImage imageNamed:@"My_Head_setup"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.setBtn setImage:setImg forState:UIControlStateNormal];
        [self.setBtn.imageView setTintColor:[UIColor whiteColor]];
        UIImage *infoImg;
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            infoImg = [[UIImage imageNamed:@"theme_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }else {
            infoImg = [[UIImage imageNamed:@"theme_dark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        [self.infoBtn setImage:infoImg forState:UIControlStateNormal];
        [self.infoBtn.imageView setTintColor:[UIColor whiteColor]];
    }
   //
    [_headerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headerV.superview.mas_centerY);
        make.left.equalTo(_headerV.superview.mas_left).offset(16);
        make.width.offset(60);
        make.height.offset(60);
    }];
    [_setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_setBtn.superview.mas_right).offset(-16);
        make.top.equalTo(_setBtn.superview.mas_top).offset(10);
        make.width.offset(20);
        make.height.offset(20);
    }];
    [_infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_setBtn.mas_left).offset(-20);
        make.top.equalTo(_infoBtn.superview.mas_top).offset(10);
        make.width.offset(21);
        make.height.offset(21);
    }];
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameL.superview.mas_top).offset(10);
        make.left.equalTo(_headerV.mas_right).offset(10);
        make.width.mas_lessThanOrEqualTo(kScreenW - 200);
        make.height.offset(20);
    }];
    [_blockchainIDCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameL.mas_centerY);
        make.left.equalTo(_nameL.mas_right).offset(4);
        make.width.offset(21);
        make.height.offset(16);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameL.mas_bottom).offset(1);
        make.left.equalTo(_headerV.mas_right).offset(10);
        make.right.equalTo(_setBtn.mas_left).offset(-10);
        make.bottom.equalTo(_detailL.superview.mas_bottom);
    }];
//    if ([ShareUserInfo sharedUserInfo].userInfo.isRealAuth == 2) {
//        self.blockchainIDCardButton.hidden = NO;
//    }
}
- (void)changeThemeWithColorUpData{
    _nameL.textColor = [ThemeManager shareManager].mainTextColor;
    _detailL.textColor = [ThemeManager shareManager].mainTextColor;
    //
    if ([ThemeManager shareManager].type==ThemeType_Drak ) {
        [_setBtn setImage:[UIImage imageNamed:@"My_Head_setup_W"] forState:UIControlStateNormal];
    }else{
        [_setBtn setImage:[UIImage imageNamed:@"My_Head_setup_Night"] forState:UIControlStateNormal];
    }
    //白色的信息图片暂时没找到 用源图
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        [_infoBtn setImage:[[UIImage imageNamed:@"theme_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }else {
        [_infoBtn setImage:[[UIImage imageNamed:@"theme_dark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    _infoBtn.imageView.tintColor =  [ThemeManager shareManager].mainTextColor;//源图附色
 
}
- (UIImageView *)headerV{
    if (!_headerV) {
        _headerV = [[UIImageView alloc]init];
        _headerV.contentMode = UIViewContentModeScaleAspectFill;
        [_headerV zy_cornerRadiusAdvance:30.0f rectCornerType:UIRectCornerAllCorners];
    }
    return _headerV;
}
- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = [ThemeManager shareManager].mainTextColor;
        _nameL.font = [UIFont boldSystemFontOfSize:17];
    }
    return _nameL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _detailL.font = [UIFont systemFontOfSize:12];
    }
    return _detailL;
}
- (UIButton *)setBtn{
    if (!_setBtn) {
        _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setBtn setImage:[UIImage imageNamed:@"My_Head_setup"] forState:UIControlStateNormal];
        _setBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
        [_setBtn addTarget:self action:@selector(setBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setBtn;
}
- (UIButton *)infoBtn{
    if (!_infoBtn) {
        _infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            [_infoBtn setImage:[UIImage imageNamed:@"theme_white"] forState:UIControlStateNormal];
        }else {
            [_infoBtn setImage:[UIImage imageNamed:@"theme_dark"] forState:UIControlStateNormal];
        }
        _infoBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
        [_infoBtn addTarget:self action:@selector(infoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoBtn;
}
- (UIButton *)blockchainIDCardButton {
    if (!_blockchainIDCardButton) {
        _blockchainIDCardButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _blockchainIDCardButton.hidden = YES;
        [_blockchainIDCardButton setImage:[UIImage imageNamed:@"sfz"] forState:UIControlStateNormal];
        _blockchainIDCardButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
        [_blockchainIDCardButton addTarget:self action:@selector(blockchainIDCardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _blockchainIDCardButton;
}
#pragma mark ===
- (void)infoBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(personVcHeaderViewSubInfoBtnTouchUp)]) {
        [_delegate personVcHeaderViewSubInfoBtnTouchUp];
    }
}
- (void)setBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(personVcHeaderViewSubSetBtnTouchUp)]) {
        [_delegate personVcHeaderViewSubSetBtnTouchUp];
    }
}
- (void)blockchainIDCardButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(blockchainIDCardButtonEvent)]) {
        [self.delegate blockchainIDCardButtonEvent];
    }
}
@end
