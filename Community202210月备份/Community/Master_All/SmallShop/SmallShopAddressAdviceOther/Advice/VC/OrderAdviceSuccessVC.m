//
//  OrderAdviceSuccessVC.m
//  Community
//
//  Created by 余莹 on 2022/3/3.
//

#import "OrderAdviceSuccessVC.h"
#import "OrderAdviceSuccessView.h"
#import "OrderAdviceVC.h"

@interface OrderAdviceSuccessVC ()
@property (nonatomic,strong) OrderAdviceSuccessView *centerView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;

@end

@implementation OrderAdviceSuccessVC
- (OrderAdviceSuccessView *)centerView{
    if (!_centerView) {
        _centerView = [[OrderAdviceSuccessView alloc]init];
    }
    return _centerView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView  alloc]initWithFrame:CGRectMake(0, 0, Screen_W-100, 120)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:20.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_footerView.footerBtn newAnBtnWithTextStr:@"完成"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (void)footerBtnAction{
    [self popVC];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //删除投诉建议vc //在pop时直接回到订单详情
    NSMutableArray *vcArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in vcArr) {
        if ([vc isKindOfClass:[OrderAdviceVC class]]) {
            [vcArr removeObject:vc];
            NSLog(@"删除了OrderAdviceVC  还剩下vcs%@",vcArr );
            break;
        }
    }
    self.navigationController.viewControllers = vcArr;
}
#pragma mark ==
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈成功";
    [self initView];
}

- (void)initView{
    [self.view addSubview:self.centerView];
    self.centerView.layer.cornerRadius = 10;
    
    self.centerView.clipsToBounds = YES;
    [self.view addSubview:self.footerView];
     [self.footerView.footerBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0x22D1AD)];
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_centerView.superview).offset(-32);
        make.top.equalTo(_centerView.superview).offset(20);
        make.centerX.equalTo(_centerView.superview);
        make.height.equalTo(_centerView.mas_width).offset(-50);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.bottom.equalTo(_footerView.superview).offset(-20-kGHSafeAreaBottomHeight);
        make.height.offset(120);
    }];
 
}

@end
