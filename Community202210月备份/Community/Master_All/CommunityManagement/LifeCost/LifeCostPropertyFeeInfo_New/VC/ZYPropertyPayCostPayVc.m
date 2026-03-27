//
//  ZYPropertyPayCostPayVc.m
//  Community
//
//  Created by ZY on 2022/5/19.
//

#import "ZYPropertyPayCostPayVc.h"
#import "ZYPropertyPayCostPaySuccessVc.h"
#import "ZYPropertyPayCostPayBottomView.h"
#import "ZYPropertyPayCostPayCell.h"
#import "ZYParkingMonthCardPayWayPopView.h"
#import "ZYPropertyPayCostPayDetailModel.h"

static NSString * const ZYPropertyPayCostPayCellID = @"ZYPropertyPayCostPayCell";
#define kZYPropertyPayCostPayBottomViewHeight 55+button_bottom_height
#define kZYCarInvitePayCellHeight 50

@interface ZYPropertyPayCostPayVc () <UITableViewDataSource, UITableViewDelegate, ZYPropertyPayCostPayBottomViewDelegate, ZYPropertyPayCostPayCellDelegate, ZYParkingMonthCardPayWayPopViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYPropertyPayCostPayBottomView *bottomView;

@property (nonatomic, strong) ZYParkingMonthCardPayWayPopView *popView;

@property (nonatomic, strong) ZYPropertyPayCostPayDetailModel *detailModel;

// 基本数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;

// 订单数据数组
@property (nonatomic, strong) NSMutableArray *orderArray;

// 订单号
@property (nonatomic, copy) NSString *orderNumber;

// 支付方式
@property (nonatomic, assign) ZYSmallShop_Pay_Way_Type payType;

// 支付相关
@property (nonatomic,strong) NSMutableDictionary *parmsDicUseWillSendAdd;//支付成功后add接口所用数据
@property (nonatomic,assign) double payMoeyNumDouble;
@property (nonatomic,strong) NSMutableArray *payOrderIdArrs;

@end

@implementation ZYPropertyPayCostPayVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.pageType == 1) {
        self.title = @"物业管理费";
    }else if (self.pageType == 2) {
        self.title = @"车辆管理费";
    }else if (self.pageType == 3) {
        self.title = @"电梯使用费";
    }
    [self setUI];
    [self customTableView];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initPropertyPayCostData];
    // 注册支付通知
    [self addNoticeOfPay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

#pragma mark - 支付相关方法
- (void)addNoticeOfPay{
    Y_NSNotificationCenter_Creat_NameAction(PaySuccessedEndInfo_Notice_Name, paySuccessNotice:);
    Y_NSNotificationCenter_Creat_NameAction(PayFailEndInfo_Notice_Name, payFailNotice:);
}

- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(PaySuccessedEndInfo_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(PayFailEndInfo_Notice_Name);
}

- (void)payFailNotice:(NSNotification *)notice{
    NSString *failMsg =  [notice.userInfo objectForKey:[notice.userInfo allKeys].firstObject];
    Y_SVP_SHOW_INFO_MES(failMsg);
}

- (void)paySuccessNotice:(NSNotification *)notice{
    NSInteger successInfoWithPayTypeNum =  [[notice.userInfo objectForKey:Pay_Success_PayType_Key] integerValue];
    switch (successInfoWithPayTypeNum) {//parmsDicUseWillSendAdd在第一步处理
        case 1:// 1微信支付
        {
            
        }
            break;
        case 2://2支付宝支付
        {
            
        }
            break;
        default:
            break;
    }
    
    // 发送支付成功通知
    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"PROPERTYPAYCOST_PAY_SUCCESS_BACK");
    ZYPropertyPayCostPaySuccessVc *vc = [[ZYPropertyPayCostPaySuccessVc alloc] init];
    [self pushVc:vc];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        if (self.orderStatus != 0) {
            make.height.offset(0);
        }else {
            make.height.offset(kZYPropertyPayCostPayBottomViewHeight);
        }
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (ZYPropertyPayCostPayBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYPropertyPayCostPayBottomView" owner:nil options:nil].lastObject;
        _bottomView.hidden = YES;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (ZYParkingMonthCardPayWayPopView *)popView {
    if (!_popView) {
        _popView = [[NSBundle mainBundle] loadNibNamed:@"ZYParkingMonthCardPayWayPopView" owner:nil options:nil].lastObject;
        _popView.delegete = self;
    }
    
    return _popView;
}

- (NSMutableDictionary *)parmsDicUseWillSendAdd{
    if (!_parmsDicUseWillSendAdd) {
        _parmsDicUseWillSendAdd = [[NSMutableDictionary alloc] init];
    }
    
    return _parmsDicUseWillSendAdd;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray *)orderArray {
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    
    return _orderArray;
}

#pragma mark - 加载数据
// 加载物业费数据
- (void)initPropertyPayCostData {
    NSDictionary *params = @{@"id" : self.ID, @"orderStatus" : @(self.orderStatus)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kPropertyPayCostDetailUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    self.detailModel = [ZYPropertyPayCostPayDetailModel yy_modelWithJSON:responsObject[@"data"]];
                    if (self.orderStatus == 0) {
                        self.bottomView.hidden = NO;
                        self.bottomView.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.totalMoney]];
                    }
                    [self handlePropertyPayCostData];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

// 处理物业费数据
- (void)handlePropertyPayCostData {
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    if (self.pageType == 1) {
        // 物业管理费
        NSArray *titleArray = @[@"缴费单位", @"缴费用户", @"缴费项目", @"账单开始时间", @"账单结束时间", @"房屋面积", @"单价", @"账单总金额", @"滞纳金", @"优惠", @"合计"];
        NSArray *contentArray = @[self.detailModel.communityName, self.detailModel.address, self.detailModel.feeRuleName, self.detailModel.beginTime, self.detailModel.overTime, self.detailModel.buildArea, self.detailModel.monetaryUnit, [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.propertyFee]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.penalSum]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.coupon]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.totalMoney]]];
        for (int i = 0; i < titleArray.count; i++) {
            ZYPropertyPayCostPayModel *model = [[ZYPropertyPayCostPayModel alloc] init];
            model.order = i;
            model.title = titleArray[i];
            model.content = contentArray[i];
            [self.dataArray addObject:model];
        }
    }else if (self.pageType == 2) {
        // 车辆管理费
        NSArray *titleArray = @[@"缴费单位", @"缴费用户", @"缴费项目", @"车位号", @"账单开始时间", @"账单结束时间", @"单价", @"账单总金额", @"滞纳金", @"优惠", @"合计"];
        NSArray *contentArray = @[self.detailModel.communityName, self.detailModel.address, self.detailModel.feeRuleName, self.detailModel.carPosition, self.detailModel.beginTime, self.detailModel.overTime, self.detailModel.monetaryUnit, [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.propertyFee]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.penalSum]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.coupon]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.totalMoney]]];
        for (int i = 0; i < titleArray.count; i++) {
            ZYPropertyPayCostPayModel *model = [[ZYPropertyPayCostPayModel alloc] init];
            model.order = i;
            model.title = titleArray[i];
            model.content = contentArray[i];
            [self.dataArray addObject:model];
        }
    }else if (self.pageType == 3) {
        // 电梯使用费
        NSArray *titleArray;
        NSArray *contentArray;
        if (!self.detailModel.elevatorUnit.length) {
            self.detailModel.elevatorUnit = @"0元/月";
        }
        if (self.detailModel.houseMemberCount.length > 0) {
            titleArray = @[@"缴费单位", @"缴费用户", @"缴费项目", @"账单开始时间", @"账单结束时间", @"住户数", @"住户单价", @"电梯单价", @"楼层叠加费用", @"账单总金额", @"滞纳金", @"优惠", @"合计"];
            contentArray = @[self.detailModel.communityName, self.detailModel.address, self.detailModel.feeRuleName, self.detailModel.beginTime, self.detailModel.overTime, [NSString stringWithFormat:@"%@人", self.detailModel.houseMemberCount], self.detailModel.monetaryUnit, self.detailModel.elevatorUnit, [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.additionMoney]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.propertyFee]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.penalSum]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.coupon]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.totalMoney]]];
        }else {
            titleArray = @[@"缴费单位", @"缴费用户", @"缴费项目", @"账单开始时间", @"账单结束时间", @"住户单价", @"电梯单价", @"楼层叠加费用", @"账单总金额", @"滞纳金", @"优惠", @"合计"];
            contentArray = @[self.detailModel.communityName, self.detailModel.address, self.detailModel.feeRuleName, self.detailModel.beginTime, self.detailModel.overTime, self.detailModel.monetaryUnit, self.detailModel.elevatorUnit, [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.additionMoney]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.propertyFee]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.penalSum]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.coupon]], [NSString stringWithFormat:@"￥%.2lf", [ZYDecimalNumberTool floatWithDecimalString:self.detailModel.totalMoney]]];
        }
        for (int i = 0; i < titleArray.count; i++) {
            ZYPropertyPayCostPayModel *model = [[ZYPropertyPayCostPayModel alloc] init];
            model.order = i;
            model.title = titleArray[i];
            model.content = contentArray[i];
            [self.dataArray addObject:model];
        }
    }
    
    if (self.orderStatus != 0) {
        if (self.orderArray.count > 0) {
            [self.orderArray removeAllObjects];
        }
        NSArray *titleArray = @[@"支付方式", @"交易时间", @"交易单号"];
        NSString *payName;
        if (self.detailModel.payMethod == 1) {
            payName = @"支付宝支付";
        }else if (self.detailModel.payMethod == 2) {
            payName = @"微信支付";
        }else if (self.detailModel.payMethod == 3) {
            payName = @"银行卡支付";
        }else if (self.detailModel.payMethod == 4) {
            payName = @"余额支付";
        }else {
            payName = @"其它支付";
        }
        NSArray *contentArray = @[payName, self.detailModel.payTime, self.detailModel.tripartiteOrder];
        for (int i = 0; i < titleArray.count; i++) {
            ZYPropertyPayCostPayModel *model = [[ZYPropertyPayCostPayModel alloc] init];
            model.order = i;
            model.title = titleArray[i];
            model.content = contentArray[i];
            [self.orderArray addObject:model];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYPropertyPayCostPayCellID bundle:nil] forCellReuseIdentifier:ZYPropertyPayCostPayCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.orderStatus == 0) {
        
        return 1;
    }else {
        
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderStatus == 0) {
        
        return self.dataArray.count;
    }else {
        if (section == 0) {
            
            return self.dataArray.count;
        }else {
            
            return self.orderArray.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderStatus == 0) {
        ZYPropertyPayCostPayCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYPropertyPayCostPayCellID forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [cell.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, 50) radius:7.5 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
        }
        if (indexPath.row == self.dataArray.count - 1) {
            [cell.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, 50) radius:7.5 corners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
            cell.lineView.hidden = YES;
            cell.contentLabel.textColor = [UIColor zy_colorWithHexString:@"#FF3A3A"];
        }else {
            cell.lineView.hidden = NO;
            cell.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
        }
        if (self.pageType == 3 && indexPath.row == 5 && self.detailModel.houseMemberCount.length > 0) {
            cell.doubtButton.hidden = NO;
            cell.delegate = self;
        }else {
            cell.doubtButton.hidden = YES;
        }
        cell.model = self.dataArray[indexPath.row];
        
        return cell;
    }else {
        if (indexPath.section == 0) {
            ZYPropertyPayCostPayCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYPropertyPayCostPayCellID forIndexPath:indexPath];
            if (indexPath.row == 0) {
                [cell.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, 50) radius:7.5 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
            }
            if (indexPath.row == self.dataArray.count - 1) {
                [cell.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, 50) radius:7.5 corners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
                cell.lineView.hidden = YES;
            }else {
                cell.lineView.hidden = NO;
            }
            if (self.pageType == 3 && indexPath.row == 5 && self.detailModel.houseMemberCount.length > 0) {
                cell.doubtButton.hidden = NO;
                cell.delegate = self;
            }else {
                cell.doubtButton.hidden = YES;
            }
            cell.model = self.dataArray[indexPath.row];
            
            return cell;
        }else {
            ZYPropertyPayCostPayCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYPropertyPayCostPayCellID forIndexPath:indexPath];
            if (indexPath.row == 0) {
                [cell.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, 50) radius:7.5 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
            }
            if (indexPath.row == self.orderArray.count - 1) {
                [cell.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, 50) radius:7.5 corners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
                cell.lineView.hidden = YES;
            }else {
                cell.lineView.hidden = NO;
            }
            cell.model = self.orderArray[indexPath.row];
            
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYCarInvitePayCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.orderStatus == 0) {
        
        return 15;
    }else {
        if (section == 0) {
            
            return 15;
        }else {
            
            return 10;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.orderStatus == 0) {
        
        return 15;
    }else {
        if (section == 0) {
            
            return 0;
        }else {
            
            return 15;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - ZYPropertyPayCostPayCellDelegate
// 住户数疑问
- (void)doubtButtonEvent {
    NSLog(@"住户数疑问");
    [ZYProgressHUDTool showCustomHUDTextMessage:@"指绑定该房屋关系的总住户数" toView:self.view delay:3.0];
}


#pragma mark - ZYPropertyPayCostPayBottomViewDelegate
// 立即支付
- (void)payButtonEvent {
    NSLog(@"立即支付");
    [self.popView showParkingMonthCardPayWayPopView];
}

#pragma mark - ZYParkingMonthCardPayWayPopViewDelegate
- (void)okButtonEvent {
    NSLog(@"确认付款");
    [self.popView hiddenParkingMonthCardPayWayPopView];
    if (self.payType == ZYSmallShop_Pay_Way_Type_WeChat) {
        [self goWeChatPay];
    }else if (self.payType == ZYSmallShop_Pay_Way_Type_Alipay) {
        [self goZFBPay];
    }
}

- (void)weixinViewEvent {
    NSLog(@"微信");
    self.payType = ZYSmallShop_Pay_Way_Type_WeChat;
    self.popView.type = self.payType;
    [self.popView reloadInputViews];
}

- (void)zhifubaoVieEvent {
    NSLog(@"支付宝");
    self.payType = ZYSmallShop_Pay_Way_Type_Alipay;
    self.popView.type = self.payType;
    [self.popView reloadInputViews];
}

#pragma mark ===
- (void)goWeChatPay{
    self.payOrderIdArrs = [NSMutableArray arrayWithObject:self.ID];
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [WeChatPayData  weChatPayOfLiftCostIdStrArr:self.payOrderIdArrs];//  20220406改版
}

#pragma mark ===
- (void)goZFBPay{
    self.payOrderIdArrs = [NSMutableArray arrayWithObject:self.ID];
    self.payMoeyNumDouble = [self.detailModel.totalMoney doubleValue];
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [WillPayGetOrderViewModel willZFBPayMoneyNum:self.payMoeyNumDouble withPayOrderType:PayOrder_Type_LifeCostWuYe  withOrderIdArr:self.payOrderIdArrs withGetOrderInfo:^(WillPayOrderInfoModel * model, BOOL success) {
        if (success) {
            NSString *zfbOrderStr = [TextShowWithModelStr textShowWithModelStr:model.orderStr];
            //orderNum 用于后续的
            [self.parmsDicUseWillSendAdd setValue:[TextShowWithModelStr textShowWithModelStr:model.orderNum] forKey:@"orderNum"];
            [self.parmsDicUseWillSendAdd setValue:@(2)   forKey:@"payTpye"];           // 1微信支付，2支付宝支付，3账户余额，4其他银行卡
            [self.parmsDicUseWillSendAdd setValue:@"支付宝" forKey:@"payTypeName"];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ZfbPayManager shareManager] hangleZFPayOrderStr:zfbOrderStr];//Community //alisdkdemo zhsj_zfb_2021002119679359
            });
        }
    }];
}

@end
