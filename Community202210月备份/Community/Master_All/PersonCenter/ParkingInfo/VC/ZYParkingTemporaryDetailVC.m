//
//  ZYParkingTemporaryDetailVC.m
//  Community
//
//  Created by ZY on 2021/10/26.
//

#import "ZYParkingTemporaryDetailVC.h"
#import "ZYParkingTemporaryDetailCell.h"
#import "ZYParkingTemporaryDetaiBottomView.h"
#import "ParkingCarData.h"
#import "ParkingMonthlyTenancyPayRenewaGoPayingVC.h"

static NSString * const parkingTemporaryDetailCellID = @"ZYParkingTemporaryDetailCell";
#define kParkingTemporaryDetailCellHeight 265

@interface ZYParkingTemporaryDetailVC () <UITableViewDataSource, UITableViewDelegate, ZYParkingTemporaryDetaiBottomViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYParkingTemporaryDetaiBottomView *bottomView;

@property (nonatomic, strong) ZYParkingTemporaryDetailDataModel *detailModel;

@end

@implementation ZYParkingTemporaryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"缴费详情";
    [self setUI];
    [self initParkingTemporaryData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
}

- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bottomView.superview);
        make.bottom.equalTo(_bottomView.superview).offset(-button_bottom_height);
        make.height.offset(64);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (ZYParkingTemporaryDetaiBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYParkingTemporaryDetaiBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

#pragma mark - 加载临时缴费订单详情数据
- (void)initParkingTemporaryData {
    NSDictionary *parms = @{@"id" : self.orderId};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kGetTemporaryOrderDetailUrl] withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYParkingTemporaryDetailModel *model = [ZYParkingTemporaryDetailModel yy_modelWithJSON:responsObject];
                self.detailModel = model.data;
                [self customTableView];
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYParkingTemporaryDetailCell" bundle:nil] forCellReuseIdentifier:parkingTemporaryDetailCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYParkingTemporaryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:parkingTemporaryDetailCellID forIndexPath:indexPath];
    cell.model = self.detailModel;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kParkingTemporaryDetailCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, kScreenW - 56, 30)];
    lable.text = [NSString stringWithFormat:@"温馨提示：缴费成功后车辆可继续停留%@分钟", self.detailModel.retentionMinute];
    lable.textColor = [UIColor zy_colorWithHexString:@"#FF0033"];
    lable.font = [UIFont systemFontOfSize:14];
    [view addSubview:lable];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 30;
}

#pragma mark - ZYParkingTemporaryDetaiBottomViewDelegate
- (void)payButtonEvent {
    
    NSLog(@"去缴费");
    NSString *dataOrderIdStr = self.detailModel.ID;
    double moneyNum = [self.detailModel.money doubleValue];
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
    //支付跳转
        ParkingMonthlyTenancyPayRenewaGoPayingVC *vc = [[ParkingMonthlyTenancyPayRenewaGoPayingVC alloc]init];
        vc.title = @"支付";
        vc.dataOrderIdStr = dataOrderIdStr;
        vc.moneyNum = moneyNum;
        vc.isTempCar = YES;
        [weakSelf pushVc:vc];
    });
 
    
}

@end
