//
//  ZYParkingMonthCardPayDetailVc.m
//  Community
//
//  Created by ZY on 2022/5/9.
//

#import "ZYParkingMonthCardPayDetailVc.h"
#import "ZYParkingMonthCardPaySuccessVc.h"
#import "ZYParkingMonthCardPayDetailCell.h"
#import "ZYParkingMonthCardPayBottomView.h"
#import "ZYParkingMonthCardPayWayPopView.h"
#import "ZYParkingMonthCardPayData.h"

static NSString * const ZYParkingMonthCardPayDetailCellID = @"ZYParkingMonthCardPayDetailCell";
#define kZYParkingMonthCardPayDetailCellHeight 50
#define kZYParkingMonthCardPayBottomViewHeight 55+button_bottom_height

@interface ZYParkingMonthCardPayDetailVc () <UITableViewDataSource, UITableViewDelegate, ZYParkingMonthCardPayBottomViewDelegate, ZYParkingMonthCardPayWayPopViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYParkingMonthCardPayBottomView *bottomView;

@property (nonatomic, strong) ZYParkingMonthCardPayWayPopView *popView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 订单号
@property (nonatomic, copy) NSString *orderNumber;

// 支付方式
@property (nonatomic, assign) ZYSmallShop_Pay_Way_Type payType;

// 是否支付成功
@property (nonatomic, assign) BOOL isPaySuccess;

@end

@implementation ZYParkingMonthCardPayDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付详情";
    [self setUI];
    [self customTableView];
    [self initData];
    // 注册支付通知
    [self addNoticeOfPay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.orderNumber.length > 0 && !self.isPaySuccess) {
        NSLog(@"取消订单");
        [self initCancelOrderData];
    }
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
    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"PARKING_MONTHCARD_SUCCESS_BACK");
    self.isPaySuccess = YES;
    ZYParkingMonthCardPaySuccessVc *vc = [[ZYParkingMonthCardPaySuccessVc alloc] init];
    [self pushVc:vc];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kZYParkingMonthCardPayBottomViewHeight);
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
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (ZYParkingMonthCardPayBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYParkingMonthCardPayBottomView" owner:nil options:nil].lastObject;
        NSString *decimalsPrice = [NSString stringWithFormat:@"￥%.2lf", [self.uploadModel.monthCardPrice floatValue] * self.uploadModel.monthNumber];
        _bottomView.priceLabel.text = decimalsPrice;
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData {
    self.payType = ZYSmallShop_Pay_Way_Type_WeChat;
    self.popView.type = self.payType;
    NSString *decimalsPrice = [NSString stringWithFormat:@"%.2lf", [self.uploadModel.monthCardPrice floatValue] * self.uploadModel.monthNumber];
    self.popView.priceLabel.text = decimalsPrice;
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    NSString *relevantTitle;
    NSString *relevantContent;
    if (self.uploadModel.groundUpAndDown == 0) {
        relevantTitle = @"关联车辆";
        relevantContent = self.uploadModel.carNumber;
    }else {
        relevantTitle = @"关联车位";
        relevantContent = self.uploadModel.carPositionNumber;
    }
    NSArray *titlesArray = @[@"所属房屋", @"场地名称", @"车位位置", relevantTitle, @"月租时长", @"起始日期", @"截至日期"];
    NSArray *contentsArray = @[self.uploadModel.belongHouse, self.uploadModel.siteClassificationName, self.uploadModel.carAddressName, relevantContent, [NSString stringWithFormat:@"%ld个月", self.uploadModel.monthNumber], self.uploadModel.startDate, self.uploadModel.endDate];
    for (int i = 0; i < titlesArray.count; i++) {
        ZYParkingMonthCardRenewalModel *model = [[ZYParkingMonthCardRenewalModel alloc] init];
        model.title = titlesArray[i];
        model.content = contentsArray[i];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

// 提交购买月卡数据
- (void)uploadMonthCardData {
    NSDictionary *params = [self.uploadModel yy_modelToJSONObject];
    NSString *urlStr;
    if (self.type == ZYParking_MonthCard_Type_Add) {
        urlStr = Y_BASEURL(kAddParkingMonthCardUrl);
    }else {
        urlStr = Y_BASEURL(kParkingMonthCardRenewalUrl);
    }
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:urlStr withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.orderNumber = responsObject[@"data"];
                [self.popView showParkingMonthCardPayWayPopView];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载取消订单数据
- (void)initCancelOrderData {
    NSDictionary *params = @{@"orderNumber" : self.orderNumber};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kParkingMonthCardCancelOrderUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSLog(@"订单取消成功");
                }
            }
        });
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYParkingMonthCardPayDetailCellID bundle:nil] forCellReuseIdentifier:ZYParkingMonthCardPayDetailCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYParkingMonthCardPayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYParkingMonthCardPayDetailCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    if (indexPath.row == self.dataArray.count - 1) {
        cell.lineView.hidden = YES;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYParkingMonthCardPayDetailCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - ZYParkingMonthCardPayBottomViewDelegate
// 立即支付
- (void)payButtonEvent {
    NSLog(@"立即支付");
    WEAKSELF
    [GotoRealNameAuthenticationCardVcTool needGotoRealNameAuthenticationCardVcWithNowVcType:GotoRealNameAuthenticationCardVc_NowVcType_Nomal withBlock:^(BOOL needGotoRealNameVcBool, ZYElectroniNewRealNameAuthenticationCardVcLate * _Nonnull realNameVc) {
        if (needGotoRealNameVcBool) {
            // 支付实名
            [weakSelf pushVc:realNameVc];
        }else {
            if (!weakSelf.orderNumber.length) {
                [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
                [weakSelf uploadMonthCardData];
            }else {
                [weakSelf.popView showParkingMonthCardPayWayPopView];
            }
        }
    }];
}

#pragma mark - ZYParkingMonthCardPayWayPopViewDelegate
- (void)okButtonEvent {
    NSLog(@"确认付款");
    [self.popView hiddenParkingMonthCardPayWayPopView];
    if (self.payType == ZYSmallShop_Pay_Way_Type_WeChat) {
        [ZYParkingMonthCardPayData weChatPayWithOrderNum:self.orderNumber];
    }else if (self.type == ZYSmallShop_Pay_Way_Type_Alipay) {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"暂未实现" toView:self.view];
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

@end
