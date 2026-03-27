//
//  MoneyWalletYuEVc.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "MoneyWalletYuEVc.h"
#import "MoneyWalletYuEView.h"
#import "ChongZhiAndTiXianVC.h"
#import "MoneyWalletYuEMingXiListVc.h"
@interface MoneyWalletYuEVc () <YuEMingXiViewDelegate>
@property (nonatomic,strong) MoneyWalletYuEView *subView;
@end

@implementation MoneyWalletYuEVc

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupNavigationBarTextColor:[UIColor blackColor] andBarItemsColor:[UIColor blackColor] andBackViewCustomColor:Color_245Gray];
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        [self setupNavigationBarStyleWithMainColor];
    });
 }
- (void)initView{
    self.title = @"余额";
    [self.view addSubview:self.subView];
    self.bottomTipLabel.hidden = NO;
}
- (void)initData{
    self.subView.moneyL.text = [NSString stringWithFormat:@"%0.2f",self.yuE];
}
#pragma mark ==
- (MoneyWalletYuEView *)subView{
    if (!_subView) {
        _subView = [[MoneyWalletYuEView alloc]initWithFrame:CGRectMake(0,0 , Screen_W, 250)];
        _subView.delegate = self;
    }
    return _subView;
}
#pragma mark ===
- (void)showMingXiAction{
    DLog(@"");
    //明细
    MoneyWalletYuEMingXiListVc *vc = [[MoneyWalletYuEMingXiListVc alloc]init];
    [self pushVc:vc];
}
- (void)tiXianAction{
    DLog(@"tiXianAction");
//    Y_SVP_SHOW_INFO_MES(@"tiXianAction");
    ChongZhiAndTiXianVC *vc = [[ChongZhiAndTiXianVC alloc]init];
    vc.type = TiXianAndChongZhi_Type_tixian;
    [self pushVc:vc];
}
- (void)chongZhiAction{
    DLog(@"chongZhiAction");
//    Y_SVP_SHOW_INFO_MES(@"chongZhiAction");
    ChongZhiAndTiXianVC *vc = [[ChongZhiAndTiXianVC alloc]init];
    vc.type = TiXianAndChongZhi_Type_chognzhi;
    [self pushVc:vc];
}
@end

 
