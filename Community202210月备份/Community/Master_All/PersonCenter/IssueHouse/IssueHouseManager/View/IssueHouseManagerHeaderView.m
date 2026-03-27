//
//  IssueHouseManagerHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import "IssueHouseManagerHeaderView.h"
#define    Color_2Green    Y_RGBA(2, 195, 168, 1)

@implementation IssueHouseManagerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame  =  CGRectMake(0, 0, Screen_W, 80);
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor;
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self addSubview:self.headerImgV];
        [self addSubview:self.nameL];
        [self addSubview:self.phoneL];
        [self addSubview:self.changeBtn];
        [self setUI];
        if ([ShareUserInfo sharedUserInfo].userInfo.avatarUrl.length<=0) {
            self.headerImgV.image = [UIImage imageNamed:@"My_headportrait"];
        }else{
            [self.headerImgV sd_setImageWithURL:[UrlWithString getURLWithStr:[ShareUserInfo sharedUserInfo].userInfo.avatarUrl ] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
        }
    }
    return self;
}
- (void)setUI{
    [_headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headerImgV.superview).offset(-10);
        make.width.height.offset(50);
        make.left.equalTo(_headerImgV.superview.mas_left).offset(15);
    }];
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImgV.mas_right).offset(10);
        make.centerY.equalTo(_headerImgV).offset(-10);
    }];
    [_phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImgV.mas_right).offset(10);
        make.centerY.equalTo(_headerImgV).offset(10);
    }];
    [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_changeBtn.superview.mas_right).offset(-15);
        make.width.offset(90);
        make.height.offset(22);
        make.centerY.equalTo(_headerImgV);
    }];
}
#pragma mark ==
- (UIImageView *)headerImgV{
    if (!_headerImgV) {
        _headerImgV = [[UIImageView alloc]init];
//        _headerImgV.layer.cornerRadius = 25;//50
        _headerImgV.image = [UIImage imageNamed:@"My_headportrait.png"];
        _headerImgV.contentMode = UIViewContentModeScaleAspectFill;
        [_headerImgV zy_cornerRadiusAdvance:25 rectCornerType:UIRectCornerAllCorners];

    }
    return _headerImgV;
}
- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.font = [UIFont boldSystemFontOfSize:18];
//        _nameL.textColor = [[UIColor whiteColor]];
    }
    _nameL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    return _nameL;
}
- (UILabel *)phoneL{
    if (!_phoneL) {
        _phoneL = [[UILabel alloc]init];
        _phoneL.font = [UIFont boldSystemFontOfSize:16];
//        _phoneL.textColor = [UIColor whiteColor];
    }
    _phoneL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    return _phoneL;
}
- (UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn newAnBtnWithFont:[UIFont systemFontOfSize:11]];
        [_changeBtn newAnBtnWithTextStrNomal:@"切换为房东" withTextStrSelected:@"切换为租客"];
        [_changeBtn addTarget:self action:@selector(changeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [_changeBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
    [_changeBtn newAnBtnWithLayerCorNerNum:11 withLayerLineWidth:0.5 withLayerLineColor:[ThemeManager shareManager].mainTextColor];
    return _changeBtn;
}
- (void)changeBtnAction{
    self.changeBtn.selected = !self.changeBtn.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(changeManagerVcMyType:)]) {
        if (self.changeBtn.selected==YES) {//业主
            [_delegate changeManagerVcMyType:IssueHouseManagerVC_MyType_FangDong];
        }else{//self.changeBtn.selected==NO; //租客
            [_delegate changeManagerVcMyType:IssueHouseManagerVC_MyType_ZuKe];
        }
       
    }
}

@end
