//
//  ZYSmallShopContainerRentOrderVc.m
//  Community
//
//  Created by ZY on 2022/3/21.
//

#import "ZYSmallShopContainerRentOrderVc.h"
#import "ZYSmallShopContainerRentPaySuccessVc.h"
#import "ZYSmallShopContainerRentPayAddressCell.h"
#import "ZYSmallShopContainerRentPayPriceCell.h"
#import "ZYSmallShopContainerRentDetailInfoCell.h"
#import "ZYSmallShopOrderTimeView.h"
#import "ZYSmallShopPayBaseBottomView.h"
#import "ZYSmallShopPayWayPopView.h"
#import "SmallShopAddressData.h"
#import "BaseAddressAndPhoneInfoListVC.h"
#import "ZYSmallShopNavigationView.h"
#import "ZYSmallShopPayData.h"
#import "SmallShopCartData.h"

static NSString * const ZYSmallShopContainerRentPayAddressCellID = @"ZYSmallShopContainerRentPayAddressCell";
static NSString * const ZYSmallShopContainerRentPayPriceCellID = @"ZYSmallShopContainerRentPayPriceCell";
static NSString * const ZYSmallShopContainerRentDetailInfoCellID = @"ZYSmallShopContainerRentDetailInfoCell";
#define kZYSmallShopOrderTimeViewHeight 60
#define kZYSmallShopPayBaseBottomViewHeight button_bottom_height+60
#define kZYSmallShopContainerRentPayPriceCellHeight 77+kZYSmallShopContainerRentPayPriceCollectionViewCell_H
#define kZYSmallShopContainerRentDetailInfoCellHeight 133
#define kZYSmallShopContainerRentDetailInfoCellHiddenDayHeight 110
#define kZYSmallShopNavigationViewHeight status_height+44

@interface ZYSmallShopContainerRentOrderVc () <UITableViewDataSource, UITableViewDelegate, ZYSmallShopContainerRentPayAddressCellDelegate, ZYSmallShopPayBaseViewDelegate, ZYSmallShopPayWayPopViewDelegate, ZYSmallShopNavigationViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYSmallShopOrderTimeView *timeView;

@property (nonatomic, strong) ZYSmallShopPayBaseBottomView *bottomView;

@property (nonatomic, strong) ZYSmallShopPayWayPopView *popView;

@property (nonatomic, strong) ZYSmallShopNavigationView *naviView;

@property (nonatomic, assign) NSInteger cabinetPriceStatus;

@property (nonatomic, assign) ZYSmallShop_Pay_Way_Type type;

@end

@implementation ZYSmallShopContainerRentOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    [self setUI];
    [self customTableView];
    [self initData];
    [self addGestureRecognizer];
    // 注册支付通知
    [self addNoticeOfPay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    [self hiddenNavigationBar];
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initAddressData];
}

// 添加返回手势
- (void)addGestureRecognizer {
    self.transitioningDelegate = self;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].windows.lastObject].x / [UIApplication sharedApplication].windows.lastObject.bounds.size.width);
    if ((edgePan.edges == UIRectEdgeLeft) && (progress > 0.2)) {
        [self showAlert];
    }
}

- (void)showAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"是否退出当前支付页面，退出后订单将取消！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"退出");
        [self orderOutTimeAction];
        [self popVC];
    }];
    UIAlertAction *payAction = [UIAlertAction actionWithTitle:@"继续支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"继续支付");
    }];
    [alertVC addAction:exitAction];
    [alertVC addAction:payAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
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
    
    ZYSmallShopContainerRentPaySuccessVc *vc = [[ZYSmallShopContainerRentPaySuccessVc alloc] init];
    vc.model = self.model;
    vc.price = self.bottomView.priceLabel.text;
    [self pushVc:vc];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.naviView];
    [_naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_naviView.superview);
        make.height.offset(kZYSmallShopNavigationViewHeight);
    }];
    
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kZYSmallShopPayBaseBottomViewHeight);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_naviView.mas_bottom);
        make.left.right.equalTo(_tableView.superview);
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

- (ZYSmallShopOrderTimeView *)timeView {
    if (!_timeView) {
        _timeView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopOrderTimeView" owner:nil options:nil].lastObject;
    }
    
    return _timeView;
}

- (ZYSmallShopPayBaseBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopPayBaseBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
        [_bottomView.payButton setTitle:@"去付款" forState:UIControlStateNormal];
    }
    
    return _bottomView;
}

- (ZYSmallShopPayWayPopView *)popView {
    if (!_popView) {
        _popView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopPayWayPopView" owner:nil options:nil].lastObject;
        _popView.delegete = self;
    }
    
    return _popView;
}

- (ZYSmallShopNavigationView *)naviView {
    if (!_naviView) {
        _naviView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopNavigationView" owner:nil options:nil].lastObject;
        _naviView.delegate = self;
        _naviView.titleLabel.text = @"等待付款";
    }
    
    return _naviView;
}

#pragma mark - 加载数据
- (void)initData {
    self.type = ZYSmallShop_Pay_Way_Type_WeChat;
    self.popView.type = self.type;
    [self.popView reloadInputViews];
    for (ZYSmallShopContainerRentDetailCabinetModel *model in self.model.cabinetPriceDtos) {
        if (model.isSelected) {
            self.bottomView.priceLabel.text = [ZYDecimalNumberTool stringWithDecimalString:model.cabinetPriceSell];
            self.popView.priceLabel.text = [ZYDecimalNumberTool stringWithDecimalString:model.cabinetPriceSell];
        }
    }
    [self.tableView reloadData];
}

// 获取用户地址
- (void)initAddressData {
    WEAKSELF
    [SmallShopAddressData smallShopNomalFirstAddressAndPhoneWithBlock:^(SmallShopAddressInfoModel * _Nonnull addressInfoModel, BOOL isHaveBool) {
        Y_SVP_DISMISS
        if (isHaveBool) {// yes = share 拿到了最新默认值 | no 做暂无
            dispatch_async(dispatch_get_main_queue(), ^{
                self.model.storePhone = addressInfoModel.phone;
                self.model.storeAddress = addressInfoModel.detail;
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

// 订单超时处理
- (void)orderOutTimeAction {
    DLog(@"超时或删除当前订单");
    [SmallShopCartData deletOrderWithOrderStr:self.orderId withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"已经成功取消当前订单。");
            });
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentPayAddressCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopContainerRentPayAddressCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentPayPriceCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopContainerRentPayPriceCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentDetailInfoCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopContainerRentDetailInfoCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYSmallShopContainerRentPayAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopContainerRentPayAddressCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYSmallShopContainerRentPayPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopContainerRentPayPriceCellID forIndexPath:indexPath];
        cell.model = self.model;
        cell.userInteractionEnabled = NO;
        
        return cell;
    }else if (indexPath.row == 2) {
        ZYSmallShopContainerRentDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopContainerRentDetailInfoCellID forIndexPath:indexPath];
        cell.model = self.model;
        
        return cell;
    }
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYSmallShopContainerRentPayAddressCell *cell = (ZYSmallShopContainerRentPayAddressCell *)currentCell;
        cell.delegate = self;
        [cell fillNewAddressStr:self.address andPhoneStr:self.phone];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:ZYSmallShopContainerRentPayAddressCellID configuration:^(ZYSmallShopContainerRentPayAddressCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else if (indexPath.row == 1) {
        
        return kZYSmallShopContainerRentPayPriceCellHeight;
    }else if (indexPath.row == 2) {
        if (self.model.isHiddenRemainDay) {
            
            return kZYSmallShopContainerRentDetailInfoCellHiddenDayHeight;
        }else {
            
            return kZYSmallShopContainerRentDetailInfoCellHeight;
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.timeView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kZYSmallShopOrderTimeViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20;
}

#pragma mark - ZYSmallShopPayWayPopViewDelegate
- (void)okButtonEvent {
    NSLog(@"确认付款");
    
    [self.popView hiddenSmallShopPayWayPopView];
    if (self.type == ZYSmallShop_Pay_Way_Type_WeChat) {
        [ZYSmallShopPayData weChatPayWithOrderNum:self.orderId];
    }else if (self.type == ZYSmallShop_Pay_Way_Type_Alipay) {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"暂未实现" toView:self.view];
    }
}

- (void)weixinViewEvent {
    NSLog(@"微信");
    
    self.type = ZYSmallShop_Pay_Way_Type_WeChat;
    self.popView.type = self.type;
    [self.popView reloadInputViews];
}

- (void)zhifubaoVieEvent {
    NSLog(@"支付宝");
    
    self.type = ZYSmallShop_Pay_Way_Type_Alipay;
    self.popView.type = self.type;
    [self.popView reloadInputViews];
}

#pragma mark - ZYSmallShopContainerRentPayAddressCellDelegate
// 信息修改
- (void)editButtonEvent {
    NSLog(@"信息修改");
    
    BaseAddressAndPhoneInfoListVC *vc = [[BaseAddressAndPhoneInfoListVC alloc] init];
    [self pushVc:vc];
}

#pragma mark - ZYSmallShopContainerRentPayPriceCellDelegate
- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.row);
    ZYSmallShopContainerRentDetailCabinetModel *model = self.model.cabinetPriceDtos[indexPath.row];
    for (ZYSmallShopContainerRentDetailCabinetModel *tempModel in self.model.cabinetPriceDtos) {
        tempModel.isSelected = NO;
    }
    model.isSelected = YES;
    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"%@", [ZYDecimalNumberTool stringWithDecimalString:model.cabinetPriceSell]];
    self.cabinetPriceStatus = model.cabinetPriceStatus;
    [self.tableView reloadData];
}

#pragma mark - ZYSmallShopPayBaseViewDelegate
// 去付款
- (void)payButtonEvent {
    NSLog(@"去付款");
    WEAKSELF
    [GotoRealNameAuthenticationCardVcTool needGotoRealNameAuthenticationCardVcWithNowVcType:GotoRealNameAuthenticationCardVc_NowVcType_Nomal withBlock:^(BOOL needGotoRealNameVcBool, ZYElectroniNewRealNameAuthenticationCardVcLate * _Nonnull realNameVc) {
        if (needGotoRealNameVcBool) {
            [weakSelf pushVc:realNameVc];
        }else{
            [weakSelf.popView showSmallShopPayWayPopView];
        }
    }];
}

#pragma mark - ZYSmallShopNavigationViewDelegate
// 返回
- (void)backButtonEvent {
    [self showAlert];
}

@end
