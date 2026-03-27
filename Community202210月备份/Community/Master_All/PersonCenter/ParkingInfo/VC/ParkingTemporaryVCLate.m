//
//  ParkingTemporaryVCLate.m
//  Community
//
//  Created by 余莹 on 2021/9/27.
//0927 新的临时缴费

#import "ParkingTemporaryVCLate.h"
#import "ParkingTemporaryVcTopViewLate.h"

@interface ParkingTemporaryVCLate ()
@property (nonatomic,strong) ParkingTemporaryVcTopViewLate *topView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation ParkingTemporaryVCLate

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"临时缴费";
    [self initView];
}
#pragma mark ==
- (void)footerBtnActio{
    DLog(@"");
}

#pragma mark == UI
- (void)initView{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.footerView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.superview);
        make.left.right.equalTo(_topView.superview);
        make.height.offset(250);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.bottom.equalTo(_footerView.superview.mas_bottom).offset(-20);
        make.height.offset(100);
    }];
}
#pragma mark ==
- (ParkingTemporaryVcTopViewLate *)topView{
    if (!_topView) {
        _topView = [[ParkingTemporaryVcTopViewLate alloc]init];
    }
    return _topView;
}

- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"查询"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnActio) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

@end
