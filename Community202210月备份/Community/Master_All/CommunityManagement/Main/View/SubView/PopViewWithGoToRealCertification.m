//
//  PopViewWithGoToRealCertification.m
//  Community
//
//  Created by 余莹 on 2021/3/22.
//

#import "PopViewWithGoToRealCertification.h"
#define Self_Center_View_W      (Screen_W*0.6)
@implementation PopViewWithGoToRealCertification
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.subMainBackView addSubview:self.centerBackView];
        [self.centerBackView addSubview:self.imgView];
        [self.centerBackView addSubview:self.centerLabel];
        [self.centerBackView addSubview:self.centerContentLabel];
        [self.centerBackView addSubview:self.baseFooterView];
        [self.subMainBackView addSubview:self.bottomCloseBtn];
        [self setUI];
        self.subMainBackView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
 
- (void)showInViewEditCellIndex:(NSInteger)index andWithArray:(NSMutableArray *)timeArr{
    [self showInView:self.superview thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
    //up ui
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H;
}
#pragma mark ==
- (void)setUI{
    [_centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_centerBackView.superview);
        make.width.equalTo(_centerBackView.superview).multipliedBy(0.6);
        make.height.offset(260);
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgView.superview);
        make.width.offset(100);
        make.height.offset(100);
        make.top.equalTo(_imgView.superview.mas_top).offset(20);
    }];
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerLabel.superview);
        make.top.equalTo(_imgView.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    [_centerContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerContentLabel.superview);
        make.top.equalTo(_centerLabel.mas_bottom);
        make.height.offset(20);
    }];
    [_baseFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerContentLabel.mas_bottom);
        make.bottom.equalTo(_baseFooterView.superview.mas_bottom);
        make.centerX.equalTo(_baseFooterView.superview);
        make.width.equalTo(_baseFooterView.superview).offset(-32);
    }];
    //
    [_bottomCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(25);
        make.centerX.equalTo(_centerBackView);
        make.top.equalTo(_centerBackView.mas_bottom).offset(20);
    }];
    
}

- (UIView *)centerBackView{
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc]init];
        _centerBackView.layer.cornerRadius = 7.5;
        _centerBackView.layer.masksToBounds = YES;
        _centerBackView.backgroundColor = [UIColor whiteColor];
    }
    return _centerBackView;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.image = [UIImage imageNamed:@"Tips_Realname"];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}
- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]init];
        _centerLabel.text = @"您还未实名认证";
        _centerLabel.textColor = Color_51BlackColor;
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _centerLabel;
}
- (UILabel *)centerContentLabel{
    if (!_centerContentLabel) {
        _centerContentLabel = [[UILabel alloc]init];
        _centerContentLabel.text = @"实名认证，可享受更多功能";
        _centerContentLabel.textColor = Color_153GrayColor;
        _centerContentLabel.textAlignment = NSTextAlignmentCenter;
        _centerContentLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _centerContentLabel;
}
- (BaseTableViewFooterView *)baseFooterView{
    if (!_baseFooterView) {
        _baseFooterView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0,Self_Center_View_W-32 , 90)];
        [_baseFooterView setBtnFram:CGRectMake(16, 20, Self_Center_View_W-32, 44)];
        [_baseFooterView.footerBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
        [_baseFooterView.footerBtn newAnBtnWithTextStr:@"立即实名认证"];
        [_baseFooterView.footerBtn addTarget:self action:@selector(popViewGotoRealCertificationAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _baseFooterView;
}
- (UIButton *)bottomCloseBtn{
    if (!_bottomCloseBtn) {
        _bottomCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomCloseBtn newAnBtnWithImg:[UIImage imageNamed:@"close"]];
        [_bottomCloseBtn addTarget:self action:@selector(bottomCloseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomCloseBtn;
}
#pragma mark == action
- (void)popViewGotoRealCertificationAction{//去实名认证
    if (_delegate && [_delegate respondsToSelector:@selector(popViewBtnActionWithGoToRealCertificationAction)]) {
        [_delegate popViewBtnActionWithGoToRealCertificationAction];
    }
    //
    [self dismissThePopView];
}
- (void)bottomCloseBtnAction{
    [self dismissThePopView];
}
 
@end
