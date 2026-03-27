//
//  ZYRentSigningPayVC.m
//  Community
//
//  Created by ZY on 2021/9/14.
//

#import "ZYRentSigningPayVC.h"
#import "ZYRentSigningPayCompleteVC.h"
#import "ZYRentSigningPayContentCell.h"
#import "ZYRentSigningPayWayCell.h"
#import "ZYRentSigningPayBottomView.h"

static NSString * const rentSigningPayContentCellID = @"ZYRentSigningPayContentCell";
static NSString * const rentSigningPayWayCellID = @"ZYRentSigningPayWayCell";
#define kRentSigningPayContentCellHeight 208
#define kRentSigningPayWayCellHeight 45

@interface ZYRentSigningPayVC () <UITableViewDataSource, UITableViewDelegate, ZYRentSigningPayBottomViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYRentSigningPayBottomView *bottomView;

@property (nonatomic, strong) ZYRentSigningPayModel *payModel;

@property (nonatomic, strong) NSMutableArray *payWayArray;

// 选中的支付方式
@property (nonatomic, assign) NSInteger selectedPayType;

@end

@implementation ZYRentSigningPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付";
    [self setUI];
    [self customTableView];
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initHouseLeasePaymentData];
    
    // 注册通知
    [self addNoticeOfPay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)setUI {
    
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(100 + button_bottom_height);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark ======= notice—————————— pay  init
- (void)addNoticeOfPay{
    Y_NSNotificationCenter_Creat_NameAction(PaySuccessedEndInfo_Notice_Name, paySuccessNotice:);
    Y_NSNotificationCenter_Creat_NameAction(PayFailEndInfo_Notice_Name, payFailNotice:);
}

- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(PaySuccessedEndInfo_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(PayFailEndInfo_Notice_Name);
}

#pragma mark ======= notice—————————— pay  get
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
    
    //成功类型 回列表
    // 发送通知
    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"RENT_SIGNING_PAY_BACK")
    ZYRentSigningPayCompleteVC *vc = [[ZYRentSigningPayCompleteVC alloc] init];
    vc.totalPay = self.payModel.totalPayment;
    [self pushVc:vc];
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

- (ZYRentSigningPayBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYRentSigningPayBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (NSMutableArray *)payWayArray {
    if (!_payWayArray) {
        _payWayArray = [NSMutableArray array];
    }
    
    return _payWayArray;
}

#pragma mark - 加载数据
// 加载合同首款数据
- (void)initHouseLeasePaymentData {
    self.tableView.hidden = YES;
    self.bottomView.hidden = YES;
    NSDictionary *parms = @{@"conId" : self.conId};
    NSString *jsonStr = [parms yy_modelToJSONString];
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kHouseLeasePaymentUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                self.payModel = [ZYRentSigningPayModel yy_modelWithJSON:jsonStr];
                self.tableView.hidden = NO;
                self.bottomView.hidden = NO;
                [self initPayWayData];
            }else {
              
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
           
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载支付方式数据
- (void)initPayWayData {
    NSArray *imagesArray = @[@"WeChat", @"Alipay"];
    NSArray *titlesArray = @[@"微信", @"支付宝"];
    NSArray *payTypeArray = @[@"1", @"2"];
    if (self.payWayArray.count > 0) {
        [self.payWayArray removeAllObjects];
    }
    for (int i = 0; i < imagesArray.count; i++) {
        ZYRentSigningPayWayModel *model = [[ZYRentSigningPayWayModel alloc] init];
        model.iconImageName = imagesArray[i];
        model.title = titlesArray[i];
        model.payType = [payTypeArray[i] integerValue];
        if (i == 0) {
            model.isSelected = YES;
            self.selectedPayType = model.payType;
        }
        [self.payWayArray addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYRentSigningPayContentCell" bundle:nil] forCellReuseIdentifier:rentSigningPayContentCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYRentSigningPayWayCell" bundle:nil] forCellReuseIdentifier:rentSigningPayWayCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return 1;
    }else {
        
        return self.payWayArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ZYRentSigningPayContentCell *cell = [tableView dequeueReusableCellWithIdentifier:rentSigningPayContentCellID forIndexPath:indexPath];
        cell.model = self.payModel;
        
        return cell;
    }else {
        ZYRentSigningPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:rentSigningPayWayCellID forIndexPath:indexPath];
        CGRect bounds = CGRectMake(0, 0, kScreenW - 32, kRentSigningPayWayCellHeight);
        if (indexPath.row == 0) {
            [cell.contentV cornerRadiusWithBounds:bounds radius:5 corners:UIRectCornerTopLeft | UIRectCornerTopRight];
        }
        if (indexPath.row == (self.payWayArray.count - 1)) {
            [cell.contentV cornerRadiusWithBounds:bounds radius:5 corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
            cell.lineView.hidden = YES;
        }
        ZYRentSigningPayWayModel *model = self.payWayArray[indexPath.row];
        cell.model = model;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return kRentSigningPayContentCellHeight;
    }else {
        
        return kRentSigningPayWayCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        for (int i = 0; i < self.payWayArray.count; i++) {
            ZYRentSigningPayWayModel *model = self.payWayArray[i];
            if (i == indexPath.row) {
                model.isSelected = YES;
                self.selectedPayType = model.payType;
            }else {
                model.isSelected = NO;
            }
        }
        [self.tableView reloadData];
    }
}

#pragma mark - ZYRentSigningPayBottomViewDelegate
- (void)okButtonEvent {
    WEAKSELF
    [GotoRealNameAuthenticationCardVcTool needGotoRealNameAuthenticationCardVcWithNowVcType:GotoRealNameAuthenticationCardVc_NowVcType_Nomal withBlock:^(BOOL needGotoRealNameVcBool, ZYElectroniNewRealNameAuthenticationCardVcLate * _Nonnull realNameVc) {
        if (needGotoRealNameVcBool) {
            [weakSelf pushVc:realNameVc];
        }else{
            if (weakSelf.selectedPayType == 1) {
                NSLog(@"微信支付");
                [weakSelf goWeChatPay];
            }else if (self.selectedPayType == 2) {
                NSLog(@"支付宝支付");
                [weakSelf goZFBPay];
            }
        }
        }];
    
  
}

#pragma mark - 微信
- (void)goWeChatPay{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    
    //[WeChatPayData weChatPayOfOrderNumStr:self.dataOrderIdStr];//  20220406改版
      
      
      /**
        20220406改版   **/
       
    //
    [WillPayGetOrderViewModel willWeChatPayMoneyNum:[self.payModel.totalPayment doubleValue]  withPayOrderType:payOrder_Type_SigningRent withDescriptionStr:@"租赁缴费" withOrderIdArr:@[self.conId].mutableCopy  withGetOrderInfo:^(WillPayOrderInfoModel * model, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            PayReq *req   = [[PayReq alloc] init];
            req.openID = [TextShowWithModelStr textShowWithModelStr:model.appid] ;                   //商家id
            req.nonceStr  = [TextShowWithModelStr textShowWithModelStr:model.noncestr];
            req.timeStamp = [[TextShowWithModelStr textShowWithModelStr:model.timestamp] intValue];  //时间戳
            req.package   = [TextShowWithModelStr textShowWithModelStr:model.package];
            req.partnerId = [TextShowWithModelStr textShowWithModelStr:model.partnerid];
            req.prepayId  = [TextShowWithModelStr textShowWithModelStr:model.prepayid];
            req.sign      = [TextShowWithModelStr textShowWithModelStr:model.sign];
            dispatch_async( dispatch_get_main_queue(), ^{
                [[WeChatPayManager shareManager] hangleWechatPayWithPayReq:req];  //gowx
            });
        }
    }];
}
#pragma mark - 支付宝
- (void)goZFBPay{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [WillPayGetOrderViewModel willZFBPayMoneyNum:[self.payModel.totalPayment doubleValue] withPayOrderType:payOrder_Type_SigningRent  withOrderIdArr:@[self.conId].mutableCopy   withGetOrderInfo:^(WillPayOrderInfoModel * model, BOOL success) {
        if (success) {
            NSString *zfbOrderStr = [TextShowWithModelStr textShowWithModelStr:model.orderStr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ZfbPayManager shareManager] hangleZFPayOrderStr:zfbOrderStr];
            });
        }
    }];
}

@end
