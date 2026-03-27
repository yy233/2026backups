//
//  ZYCarInvitePayVc.m
//  Community
//
//  Created by ZY on 2022/5/18.
//

#import "ZYCarInvitePayVc.h"
#import "ZYCarInvitePaySuccessVc.h"
#import "ZYCarInvitePayHeaderView.h"
#import "ZYCarInvitePayFooterView.h"
#import "ZYCarInvitePayBottomView.h"
#import "ZYCarInvitePayCell.h"
#import "ZYParkingMonthCardPayWayPopView.h"

static NSString * const ZYCarInvitePayCellID = @"ZYCarInvitePayCell";
#define kZYCarInvitePayHeaderViewHeight 98/375.0*kScreenW
#define kZYCarInvitePayFooterViewHeight 20
#define kZYCarInvitePayBottomViewHeight 55+button_bottom_height
#define kZYCarInvitePayCellHeight 264

@interface ZYCarInvitePayVc () <UITableViewDataSource, UITableViewDelegate, ZYCarInvitePayBottomViewDelegate, ZYParkingMonthCardPayWayPopViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYCarInvitePayHeaderView *headerView;

@property (nonatomic, strong) ZYCarInvitePayFooterView *footerView;

@property (nonatomic, strong) ZYCarInvitePayBottomView *bottomView;

@property (nonatomic, strong) ZYParkingMonthCardPayWayPopView *popView;

// 订单号
@property (nonatomic, copy) NSString *orderNumber;

// 支付方式
@property (nonatomic, assign) ZYSmallShop_Pay_Way_Type payType;

// 是否支付成功
@property (nonatomic, assign) BOOL isPaySuccess;

@end

@implementation ZYCarInvitePayVc

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"临停缴费";
    [self setUI];
    [self customTableView];
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
    
//    if (self.orderNumber.length > 0 && !self.isPaySuccess) {
//        NSLog(@"取消订单");
//        [self initCancelOrderData];
//    }
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
    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"CARINVITE_PAY_SUCCESS_BACK");
    self.isPaySuccess = YES;
    ZYCarInvitePaySuccessVc *vc = [[ZYCarInvitePaySuccessVc alloc] init];
    [self pushVc:vc];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kZYCarInvitePayBottomViewHeight);
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

- (ZYCarInvitePayHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYCarInvitePayHeaderView" owner:nil options:nil].lastObject;
    }
    
    return _headerView;
}

- (ZYCarInvitePayFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:@"ZYCarInvitePayFooterView" owner:nil options:nil].lastObject;
    }
    
    return _footerView;
}

- (ZYCarInvitePayBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYCarInvitePayBottomView" owner:nil options:nil].lastObject;
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

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYCarInvitePayCellID bundle:nil] forCellReuseIdentifier:ZYCarInvitePayCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYCarInvitePayCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCarInvitePayCellID forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYCarInvitePayCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kZYCarInvitePayHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return kZYCarInvitePayFooterViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return self.footerView;
}

#pragma mark - ZYCarInvitePayBottomViewDelegate
// 立即支付
- (void)payButtonEvent {
    NSLog(@"立即支付");
    [self.popView showParkingMonthCardPayWayPopView];
}

#pragma mark - ZYParkingMonthCardPayWayPopViewDelegate
- (void)okButtonEvent {
    NSLog(@"确认付款");
    [self.popView hiddenParkingMonthCardPayWayPopView];
    ZYCarInvitePaySuccessVc *vc = [[ZYCarInvitePaySuccessVc alloc] init];
    [self pushVc:vc];
//    if (self.payType == ZYSmallShop_Pay_Way_Type_WeChat) {
//        [ZYParkingMonthCardPayData weChatPayWithOrderNum:self.orderNumber];
//    }else if (self.type == ZYSmallShop_Pay_Way_Type_Alipay) {
//        [ZYProgressHUDTool showCustomHUDTextMessage:@"暂未实现" toView:self.view];
//    }
}

- (void)weixinViewEvent {
    NSLog(@"微信");
//    self.payType = ZYSmallShop_Pay_Way_Type_WeChat;
//    self.popView.type = self.payType;
//    [self.popView reloadInputViews];
}

- (void)zhifubaoVieEvent {
    NSLog(@"支付宝");
//    self.payType = ZYSmallShop_Pay_Way_Type_Alipay;
//    self.popView.type = self.payType;
//    [self.popView reloadInputViews];
}

@end
