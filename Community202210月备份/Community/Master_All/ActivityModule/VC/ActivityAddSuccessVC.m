//
//  ActivityAddSuccessVC.m
//  Community
//
//  Created by 余莹 on 2022/6/7.
//

#import "ActivityAddSuccessVC.h"


@interface ActivityAddSuccessVC ()
@property (nonatomic,strong) UIButton *centerBtn;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation ActivityAddSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initSubView];
}
- (void)initView{
    [self changeNavBackColorWithDIsCountBlueAndWW];
    self.view.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
}

- (void)initSubView{
    [self.view addSubview:self.centerBtn];
    [self.view addSubview:self.footerView];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(220);
        make.top.equalTo(_centerBtn.superview).offset(80);
        make.centerX.equalTo(_centerBtn.superview);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.top.equalTo(_centerBtn.mas_bottom).offset(0);
        make.height.offset(90);
    }];
    [self.centerBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:20];

}

#pragma mark ===
- (UIButton *)centerBtn{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerBtn newAnBtnWithImg:[UIImage imageNamed:@"pa_success"]];
        [_centerBtn newAnBtnWithTextStr:@"报名成功"];
        [_centerBtn newAnBtnWithTextColor: [ThemeManager shareManager].mainTextColor];
        [_centerBtn newAnBtnWithFont: [UIFont boldSystemFontOfSize:18.0]];
    }
    return _centerBtn;
}
 
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView  alloc]initWithFrame:CGRectMake(0, 0, 128, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"确认"];
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
        if ([vc isKindOfClass: NSClassFromString(@"ActivityInputInfoVC")]) {
            [vcArr removeObject:vc];
            NSLog(@"删除了vc  还剩下vcs%@",vcArr );
            break;
        }
    }
    self.navigationController.viewControllers = vcArr;
}
 
 
@end
