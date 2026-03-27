//
//  ParkingMonthlyTenancyPayRenewalPopDatePickView.m
//  Community
//
//  Created by 余莹 on 2021/8/7.
//

#import "ParkingMonthlyTenancyPayRenewalPopDatePickView.h"

@implementation ParkingMonthlyTenancyPayRenewalPopDatePickView

#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.35;
}
#pragma mark == 边角 重写
- (void)changMainBackViewCornerRadius{
    self.subMainBackView.layer.cornerRadius = 0;
}
 
#pragma mark == UI
#pragma mark ==
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.pickV];
    [self.subMainBackView addSubview:self.cancelBtn];
    [self.subMainBackView addSubview:self.yesBtn];
   
}
- (void)setUI{
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_cancelBtn.superview);
        make.width.height.offset(50);
    }];
    [_yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(_yesBtn.superview);
        make.width.height.offset(50);
    }];
    [_pickV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cancelBtn.mas_bottom);
        make.left.right.bottom.equalTo(_pickV.superview);
    }];
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn newAnBtnWithTextStr:@"取消"];
        [_cancelBtn newAnBtnWithTextColor:Color_38BlueColor];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)yesBtn{
    if (!_yesBtn) {
        _yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yesBtn newAnBtnWithTextStr:@"确认"];
        [_yesBtn newAnBtnWithTextColor:Color_38BlueColor];
        [_yesBtn addTarget:self action:@selector(yesBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yesBtn;
}

- (UIDatePicker *)pickV{
    if (!_pickV) {
        _pickV = [[UIDatePicker alloc]init]; 
     }
    return _pickV;
}
#pragma mark ==
- (void)cancelAction{
    [self dismissThePopView];
}
- (void)yesBtnAction{
    NSString *dataShowStr = [NSString stringWithFormat:@"%@",self.pickV.date];
    self.yesBlock(dataShowStr);
}
@end
