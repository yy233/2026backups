//
//  MoeyWalletAddBankScanCardVC.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//  扫描页

#import "MoeyWalletAddBankScanCardVC.h"

@interface MoeyWalletAddBankScanCardVC ()
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *cardTopImgV;
@property (nonatomic,strong) UILabel *personNameL;
@end

@implementation MoeyWalletAddBankScanCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";//扫码
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupNavigationBarWhiteStyle];
}
- (void)initView{
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.cardTopImgV];
    [self.view addSubview:self.personNameL];
    [self.view addSubview:self.footerView];
    [_cardTopImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_cardTopImgV.superview);
        make.centerY.equalTo(_cardTopImgV.superview).multipliedBy(0.3);
        make.height.offset(26);
        make.width.offset(35);
    }];
    [_personNameL mas_makeConstraints:^(MASConstraintMaker *make) { 
        make.left.right.centerX.equalTo(_personNameL.superview);
        make.height.offset(20);
        make.top.equalTo(_cardTopImgV.mas_bottom).offset(15);
    }];
    [_footerView.footerBtn newAnBtnWithBackColor:[UIColor clearColor]];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_footerView.superview);
        make.height.offset(90);
    }];
    //扫描框 暂无
    
    //
    self.personNameL.text = @"持卡人：*德化";
}
#pragma mark ==
- (void)footerBtnGoBack{
    [self popVC];
}
#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W- 32, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"切换手动输入"];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0.5 withLayerLineColor:[UIColor whiteColor]];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnGoBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (UIImageView *)cardTopImgV{
    if (!_cardTopImgV) {
        _cardTopImgV = [[UIImageView alloc]init];
        _cardTopImgV.image = [UIImage imageNamed:@"Add_scan"];
        _cardTopImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cardTopImgV;
}
- (UILabel *)personNameL{
    if (!_personNameL) {
        _personNameL = [[UILabel alloc]init];
        _personNameL.textColor = [UIColor whiteColor];
        _personNameL.font = FontSize_MoneyWallet_Nomail(15);
        _personNameL.textAlignment = NSTextAlignmentCenter;
    }
    return _personNameL;
}
@end
