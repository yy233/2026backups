//
//  LifeCosePaymentOnePayChageMoneyEndVC.m
//  Community
//
//  Created by 余莹 on 2021/1/9.
//

#import "LifeCosePaymentOnePayChageMoneyEndVC.h"


@interface LifeCosePaymentOnePayChageMoneyEndVC ()
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *reSultLabel;
@property (nonatomic,strong) UILabel *detailL;
@property (nonatomic,strong) UIButton *finishBtn;
@end

@implementation LifeCosePaymentOnePayChageMoneyEndVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费结果";
    [self initView];
    [self initData];
}
- (void)initData{
    _reSultLabel.text = @"缴费成功";
    _imgV.image = [UIImage imageNamed:@"Paymentresults_Success_night"];
    _detailL.text = @"部分订单可能出现延迟，以实际到账时间为准\n请凭缴费号码到收费单位网点打印发票";
}
- (void)finishBtnAction{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LifeCostVC class]]) {
            LifeCostVC *revise =(LifeCostVC *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
}
#pragma mark ===
- (void)initView{
    [self.view addSubview:self.imgV];
    [self.view addSubview:self.reSultLabel];
    [self.view addSubview:self.detailL];
    [self.view addSubview:self.finishBtn];
    [self setUI];
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgV.superview.mas_centerX);
        make.top.equalTo(_imgV.superview.mas_top).offset(100);
        make.width.offset(90);
        make.height.offset(90);
    }];
    [_reSultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.mas_bottom).offset(5);
        make.left.equalTo(_reSultLabel.superview.mas_left);
        make.right.equalTo(_reSultLabel.superview.mas_right);
        make.height.offset(30);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_reSultLabel.mas_bottom).offset(20);
        make.left.equalTo(_detailL.superview.mas_left);
        make.right.equalTo(_detailL.superview.mas_right);
        make.height.offset(40);
    }];
    [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_finishBtn.superview.mas_centerX);
        make.width.offset(150);
        make.height.offset(35);
        make.bottom.equalTo(_finishBtn.superview.mas_bottom).offset(-50);
    }];
}
#pragma mark ===
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
    }
    return _imgV;
}

- (UILabel *)reSultLabel{
    if (!_reSultLabel) {
        _reSultLabel = [[UILabel alloc]init];
        _reSultLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _reSultLabel.font = [UIFont boldSystemFontOfSize:22];
        _reSultLabel.textAlignment = NSTextAlignmentCenter;
      
    }
    return _reSultLabel;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.font = [UIFont systemFontOfSize:14];
        _detailL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _detailL.numberOfLines = 0;
        _detailL.textAlignment = NSTextAlignmentCenter;
    }
    return _detailL;
}
- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_finishBtn  addTarget:self action:@selector(finishBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _finishBtn.layer.cornerRadius = 12.5;//35_H
        _finishBtn.layer.borderWidth = 1;
        _finishBtn.layer.borderColor = [ThemeManager shareManager].mainTextColor.CGColor;
    }
    return _finishBtn;
}
@end
