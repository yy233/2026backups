//
//  AccompanyFooterView.m
//  Community
//
//  Created by 余莹 on 2020/12/8.
//

#import "AccompanyFooterView.h"

@implementation AccompanyFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.footerBackview addSubview:self.deletBtn];
        [self.footerBackview addSubview:self.moreChooseAddbtn];
        [self setAllUI];
    }
    return self;
}
- (void)setAllUI{
    self.deletBtn.hidden = YES;
    self.moreChooseAddbtn.hidden = YES;
    self.footerBtn.hidden = NO;
    [_deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_deletBtn.superview.mas_centerY);
        make.left.equalTo(_deletBtn.superview.mas_left).offset(16);
        make.width.offset(80);
        make.height.offset(44);
    }];
    [_moreChooseAddbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.footerBtn.superview.mas_right).offset(-16);
        make.centerY.equalTo(self.footerBtn.superview.mas_centerY);
        make.height.offset(44);
        make.left.equalTo(_deletBtn.mas_right).offset(15);
    }];
}
//多选状态
- (void)isMoreChooseTypeFooterView{
    self.footerBtn.hidden = YES;
    self.deletBtn.hidden = NO;
    self.moreChooseAddbtn.hidden = NO;
      [_deletBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_deletBtn.superview.mas_centerY);
        make.left.equalTo(_deletBtn.superview.mas_left).offset(16);
        make.width.offset(80);
        make.height.offset(44);
    }];
    [_moreChooseAddbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.footerBtn.superview.mas_right).offset(-16);
        make.centerY.equalTo(self.footerBtn.superview.mas_centerY);
        make.height.offset(44);
        make.left.equalTo(_deletBtn.mas_right).offset(15);
    }];
}
//普通状态
- (void)isNomalNoMoreChooseTypeFooterView{
    self.deletBtn.hidden = YES;
    self.moreChooseAddbtn.hidden = YES;
    self.footerBtn.hidden = NO;
    [self.footerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.footerBtn.superview.mas_centerX);
        make.centerY.equalTo(self.footerBtn.superview.mas_centerY);
        make.width.equalTo(self.footerBtn.superview.mas_width).offset(-32);
        make.height.offset(44);
    }];
    
}
//多选状态
- (UIButton *)deletBtn{
    if (!_deletBtn) {
        _deletBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        [_deletBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deletBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        _deletBtn.layer.cornerRadius = 1;
        _deletBtn.layer.borderWidth = 1;
        _deletBtn.layer.cornerRadius = 5;
        _deletBtn.layer.masksToBounds = YES;
        _deletBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _deletBtn.layer.borderColor = [ThemeManager shareManager].mainTexDetailLightBluetColor.CGColor;
        self.deletBtn.hidden = YES;
    }
    return _deletBtn;
}
- (UIButton *)moreChooseAddbtn{
    if (!_moreChooseAddbtn) {
        _moreChooseAddbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreChooseAddbtn setTitle:@"添加至随行人员" forState:UIControlStateNormal];
//        [_moreChooseAddbtn addTarget:self.superview action:@selector(moreChooseAddbtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreChooseAddbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_moreChooseAddbtn setBackgroundColor:Y_RGBA(38, 114, 249, 1)];
            [_moreChooseAddbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [_moreChooseAddbtn setBackgroundColor:Y_RGBA(17, 41, 87, 1)];
            [_moreChooseAddbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        _moreChooseAddbtn.layer.cornerRadius = 5;
        _moreChooseAddbtn.layer.masksToBounds = YES;
    }
    _moreChooseAddbtn.backgroundColor = [UIColor colorWithRed:38/255.0 green:114/255.0 blue:249/255.0 alpha:1.0];
     return _moreChooseAddbtn;
}

@end
