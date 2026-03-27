//
//  ZYSigningDetailVC.m
//  Community
//
//  Created by ZY on 2021/8/18.
//

#import "ZYSigningDetailVC.h"
#import "ZYElectronicRealNameAuthenticationVc.h"
#import "ZYMoulageHelperVc.h"
#import "ZYRentContractDetailVC.h"
#import "ContrectAllDetailVc.h"
#import "IssueHouseQianYueManagerVC.h"
#import "ZYSigningDetailTopCell.h"
#import "ZYSigningDetailTopRefuseCell.h"
#import "ZYSigningDetailTopCancelCell.h"
#import "ZYSigningDetailHouseInfoCell.h"
#import "ZYSigningDetailUnauthorizedCell.h"
#import "ZYSigningDetailRenterInfoCell.h"
#import "ZYSigningDetailLandlordInfoCell.h"
#import "ZYSigningDetailIntroCell.h"
#import "ZYSigningDetailBottomHintCell.h"
#import "ZYSigningDetailBottomView.h"
#import "ZYContractingPartyInformationSearchModel.h"

static NSString * const signingDetailTopCellID = @"ZYSigningDetailTopCell";
static NSString * const signingDetailTopRefuseCellID = @"ZYSigningDetailTopRefuseCell";
static NSString * const signingDetailTopCancelCellID = @"ZYSigningDetailTopCancelCell";
static NSString * const signingDetailHouseInfoCellID = @"ZYSigningDetailHouseInfoCell";
static NSString * const signingDetailUnauthorizedCellID = @"ZYSigningDetailUnauthorizedCell";
static NSString * const signingDetailRenterInfoCellID = @"ZYSigningDetailRenterInfoCell";
static NSString * const signingDetailLandlordInfoCellID = @"ZYSigningDetailLandlordInfoCell";
static NSString * const signingDetailIntroCellID = @"ZYSigningDetailIntroCell";
static NSString * const signingDetailBottomHintCellID = @"ZYSigningDetailBottomHintCell";

#define kSigningDetailTopCellHeight 140
#define kSigningDetailTopRefuseCellHeight 175
#define kSigningDetailTopCancelCellHeight 145
#define kSigningDetailHouseInfoCellNoTopHeight 120
#define kSigningDetailHouseInfoCellHeight 180
#define kSigningDetailUnauthorizedCellHeight 60
#define kSigningDetailRenterInfoCellNoTopHeight 105
#define kSigningDetailRenterInfoCellHeight 145
#define kSigningDetailLandlordInfoCellHeight 145
#define kSigningDetailIntroCellHeight 105
#define kSigningDetailBottomHintCellHeight 60

@interface ZYSigningDetailVC () <UITableViewDataSource, UITableViewDelegate, ZYSigningDetailBottomViewDelegate, ZYSigningDetailUnauthorizedCellDelegate, ZYSigningDetailBottomHintCellDelegate, ZYSigningDetailRenterInfoCellDelegate, ZYSigningDetailLandlordInfoCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYSigningDetailBottomView *bottomView;

@property (nonatomic, strong) ZYSigningDetailDataModel *detailModel;

// 操作类型
@property (nonatomic, assign) NSInteger operationType;

// 定时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZYSigningDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签约申请";
    [self setUI];
    [self customTableView];
    
    if (self.contractId.length > 0) {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
        [self initRentSignDetailData];
    }else {
        if (self.assetType == 2) {
            if (ZY_IsRealName) {
                self.detailModel.isRealName = YES;
                [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
                [self initRealNameData];
            }else {
                self.detailModel.isRealName = NO;
            }
            self.detailModel.operation = 0;
            self.detailModel.identityType = self.identityType;
            self.detailModel.isRentDetail = self.isRentDetail;
            self.detailModel.title = self.houseDetailModel.houseTitle;
            self.detailModel.houseType = self.houseDetailModel.houseType;
            self.detailModel.directionId = self.houseDetailModel.houseDirection;
            self.detailModel.price = self.houseDetailModel.housePrice;
            self.detailModel.imageUrl = [self.houseDetailModel.houseImage firstObject];
            [self.tableView reloadData];
            [self initBottomViewData];
        }
    }
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"SIGNING_DETAIL_REALNAME_BACK", signingDetailRealNameBack:)
}

// 通知回调
- (void)signingDetailRealNameBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.detailModel.operation = 1;
        [self initRealNameData];
    });
}

// 定时器回调
- (void)notiTimerBack {

    [self.tableView reloadData];
}

- (void)dealloc {
    
    Y_NSNotificationCenter_RemoveNotice_Name(@"SIGNING_DETAIL_REALNAME_BACK")
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
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
        make.height.offset(50 + button_bottom_height);
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
    }
    
    return _tableView;
}

- (ZYSigningDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYSigningDetailBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (ZYSigningDetailDataModel *)detailModel {
    if (!_detailModel) {
        _detailModel = [[ZYSigningDetailDataModel alloc] init];
    }
    
    return _detailModel;
}

#pragma mark - 加载数据
// 加载租赁签约详情数据
- (void)initRentSignDetailData {
    
    self.tableView.hidden = YES;
    self.bottomView.hidden = YES;
    NSDictionary *params = @{@"id" : self.contractId, @"identityType" : @(self.identityType)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kRentSignDetailUrl] withBody:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYSigningDetailModel *model = [ZYSigningDetailModel yy_modelWithJSON:responsObject];
                self.detailModel = model.data;
                self.detailModel.identityType = self.identityType;
                self.detailModel.isRealName = YES;
                self.detailModel.isRentDetail = self.isRentDetail;
                // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起 31:房东已重新发起 32:房东已取消发起
                if (self.detailModel.operation == 1 || self.detailModel.operation == 7 || self.detailModel.operation == 9) {
                    if (self.detailModel.identityType == 2) {
                        self.title = @"签约详情";
                    }
                }
                self.tableView.hidden = NO;
                self.bottomView.hidden = NO;
                [self.tableView reloadData];
                [self initBottomViewData];
                [self initRealNameData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载底部按钮数据
- (void)initBottomViewData {
    
    self.bottomView.model = self.detailModel;
    [self.bottomView reloadInputViews];
}

// 加载已实名数据
- (void)initRealNameData {
    // 租客uid
    NSString *tenantUuid = self.detailModel.tenantUid;
    if (!(tenantUuid.length > 0)) {
        tenantUuid = [ShareUserInfo sharedUserInfo].userInfo.uid;
    }
    NSDictionary *parms = @{@"tUuid" : tenantUuid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kGetUserRealNameUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
              
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                ZYContractingPartyInformationSearchModel *realNameModel = [ZYContractingPartyInformationSearchModel yy_modelWithJSON:jsonStr];
                self.detailModel.realName = realNameModel.idCardName;
                self.detailModel.tenantPhone = realNameModel.telephone;
                self.detailModel.tenantIdCard = realNameModel.idCardNumber;
                [self.tableView reloadData];
            }else {
              
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
           
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载发起签约数据
- (void)initStartContractData {
    NSDictionary *params = @{@"assetId" : self.assetId, @"assetType" : @(self.assetType)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kTenantInitContractUrl] withBody:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.contractId = responsObject[@"data"];
                self.houseDetailModel.contractId = self.contractId;
                [self initRentSignDetailData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载签约相关操作数据(操作类型 7:租客取消申请 8房东拒绝申请 9:租客再次申请 2房东接受申请)
- (void)initOperationContractData {
    NSDictionary *params = @{@"id" : @(self.detailModel.id), @"identityType" : @(self.detailModel.identityType), @"operationType" : @(self.operationType)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kOperationContractUrl] withBody:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self initRentSignDetailData];
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
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSigningDetailTopCell" bundle:nil] forCellReuseIdentifier:signingDetailTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSigningDetailTopRefuseCell" bundle:nil] forCellReuseIdentifier:signingDetailTopRefuseCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSigningDetailTopCancelCell" bundle:nil] forCellReuseIdentifier:signingDetailTopCancelCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSigningDetailHouseInfoCell" bundle:nil] forCellReuseIdentifier:signingDetailHouseInfoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSigningDetailUnauthorizedCell" bundle:nil] forCellReuseIdentifier:signingDetailUnauthorizedCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSigningDetailRenterInfoCell" bundle:nil] forCellReuseIdentifier:signingDetailRenterInfoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSigningDetailLandlordInfoCell" bundle:nil] forCellReuseIdentifier:signingDetailLandlordInfoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSigningDetailIntroCell" bundle:nil] forCellReuseIdentifier:signingDetailIntroCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYSigningDetailBottomHintCell" bundle:nil] forCellReuseIdentifier:signingDetailBottomHintCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起
    if (self.detailModel.operation == 0) {
        
        return 4;
    }else if (self.detailModel.operation == 1 || self.detailModel.operation == 2 || self.detailModel.operation == 9) {
        if (self.detailModel.identityType == 1) {
            
            return 3;
        }else {
            if (self.detailModel.isRentDetail) {
                
                return 4;
            }else {
                
                return 3;
            }
        }
    }else if (self.detailModel.operation == 4 || self.detailModel.operation == 5 || self.detailModel.operation == 6 || self.detailModel.operation == 7 || self.detailModel.operation == 8 || self.detailModel.operation == 10 || self.detailModel.operation == 31 || self.detailModel.operation == 32) {
        
        return 3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起
    if (indexPath.row == 0) {
        if (self.detailModel.operation == 0 || self.detailModel.operation == 1 || self.detailModel.operation == 2 || self.detailModel.operation == 4 || self.detailModel.operation == 5 || self.detailModel.operation == 6 || self.detailModel.operation == 9  || self.detailModel.operation == 31 || self.detailModel.operation == 32) {
            ZYSigningDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailTopCellID forIndexPath:indexPath];
            cell.model = self.detailModel;
            
            return cell;
        }else if (self.detailModel.operation == 7 || self.detailModel.operation == 10) {
            ZYSigningDetailTopCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailTopCancelCellID forIndexPath:indexPath];
            cell.model = self.detailModel;
            
            return cell;
        }else if (self.detailModel.operation == 8) {
            if (self.detailModel.identityType == 1) {
                ZYSigningDetailTopCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailTopCancelCellID forIndexPath:indexPath];
                cell.model = self.detailModel;
                
                return cell;
            }else {
                ZYSigningDetailTopRefuseCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailTopRefuseCellID forIndexPath:indexPath];
                
                return cell;
            }
        }
    }else if (indexPath.row == 1) {
        ZYSigningDetailHouseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailHouseInfoCellID forIndexPath:indexPath];
        if (self.detailModel.operation == 1 || self.detailModel.operation == 2 || self.detailModel.operation == 4 || self.detailModel.operation == 5 || self.detailModel.operation ==  9  || self.detailModel.operation == 31 || self.detailModel.operation == 32) {
            // 开启定时器
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(notiTimerBack) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            }
        }
        cell.model = self.detailModel;
        
        return cell;
    }else if (indexPath.row == 2) {
        if (self.detailModel.operation == 0) {
            if (self.detailModel.isRealName) {
                ZYSigningDetailRenterInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailRenterInfoCellID forIndexPath:indexPath];
                cell.model = self.detailModel;
                
                return cell;
            }else {
                ZYSigningDetailUnauthorizedCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailUnauthorizedCellID forIndexPath:indexPath];
                cell.delegate = self;
                
                return cell;
            }
        }else if (self.detailModel.operation == 1 || self.detailModel.operation == 2 || self.detailModel.operation == 8 || self.detailModel.operation == 9 || self.detailModel.operation == 10) {
            if (self.detailModel.identityType == 1) {
                ZYSigningDetailRenterInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailRenterInfoCellID forIndexPath:indexPath];
                cell.model = self.detailModel;
                
                return cell;
            }else {
                ZYSigningDetailLandlordInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailLandlordInfoCellID forIndexPath:indexPath];
                cell.delegate = self;
                cell.model = self.detailModel;
                
                return cell;
            }
        }else if (self.detailModel.operation == 7) {
            ZYSigningDetailRenterInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailRenterInfoCellID forIndexPath:indexPath];
            cell.delegate  = self;
            cell.model = self.detailModel;
            
            return cell;
        }else if (self.detailModel.operation == 4 || self.detailModel.operation == 5 || self.detailModel.operation == 6  || self.detailModel.operation == 31 || self.detailModel.operation == 32) {
            ZYSigningDetailLandlordInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailLandlordInfoCellID forIndexPath:indexPath];
            cell.model = self.detailModel;
            
            return cell;
        }
    }else if (indexPath.row == 3) {
        if (self.detailModel.operation == 0) {
            ZYSigningDetailIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailIntroCellID forIndexPath:indexPath];
            
            return cell;
        }else if (self.detailModel.operation == 1 || self.detailModel.operation == 2 || self.detailModel.operation == 9) {
            if (self.detailModel.identityType == 2 && self.detailModel.isRentDetail) {
                ZYSigningDetailBottomHintCell *cell = [tableView dequeueReusableCellWithIdentifier:signingDetailBottomHintCellID forIndexPath:indexPath];
                cell.delegate = self;
                
                return cell;
            }
        }
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起
    if (indexPath.row == 0) {
        if (self.detailModel.operation == 0 || self.detailModel.operation == 1 || self.detailModel.operation == 2 || self.detailModel.operation == 4 || self.detailModel.operation == 5 || self.detailModel.operation == 6 || self.detailModel.operation == 9 || self.detailModel.operation == 31 || self.detailModel.operation == 32) {
            
            return kSigningDetailTopCellHeight;
        }else if (self.detailModel.operation == 7 || self.detailModel.operation == 10) {
            
            return kSigningDetailTopCancelCellHeight;
        }else if (self.detailModel.operation == 8) {
            if (self.detailModel.identityType == 1) {
                
                return kSigningDetailTopCancelCellHeight;
            }else {
                
                return kSigningDetailTopRefuseCellHeight;
            }
        }
    }else if (indexPath.row == 1) {
        if (self.detailModel.operation == 0 || self.detailModel.operation == 6 || self.detailModel.operation == 7 || self.detailModel.operation == 8 || self.detailModel.operation == 10) {
            
            return kSigningDetailHouseInfoCellNoTopHeight;
        }else {
            
            return kSigningDetailHouseInfoCellHeight;
        }
    }else if (indexPath.row == 2) {
        if (self.detailModel.operation == 0) {
            if (self.detailModel.isRealName) {
                
                return kSigningDetailRenterInfoCellNoTopHeight;
            }else {
                
                return kSigningDetailUnauthorizedCellHeight;
            }
        }else if (self.detailModel.operation == 1 || self.detailModel.operation == 2 || self.detailModel.operation == 8 || self.detailModel.operation == 9 || self.detailModel.operation == 10) {
            if (self.detailModel.identityType == 1) {
                
                return kSigningDetailRenterInfoCellNoTopHeight;
            }else {
                
                return kSigningDetailLandlordInfoCellHeight;
            }
        }else if (self.detailModel.operation == 7) {
            
            return kSigningDetailRenterInfoCellHeight;
        }else if (self.detailModel.operation == 4 || self.detailModel.operation == 5 || self.detailModel.operation == 6  || self.detailModel.operation == 31 || self.detailModel.operation == 32) {
            
            return kSigningDetailLandlordInfoCellHeight;
        }
    }else if (indexPath.row == 3) {
        if (self.detailModel.operation == 0) {
            
            return kSigningDetailIntroCellHeight;
        }else if (self.detailModel.operation == 1 || self.detailModel.operation == 2 || self.detailModel.operation == 9) {
            if (self.detailModel.identityType == 2 && self.detailModel.isRentDetail) {
                
                return kSigningDetailBottomHintCellHeight;
            }
        }
    }
    
    return 0;
}

#pragma mark - ZYSigningDetailBottomViewDelegate
- (void)signingViewTapEvent {
    
    if (self.detailModel.isRealName) {
        NSLog(@"发起签约");
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"发起中..."];
        [self initStartContractData];
    }else {
        NSLog(@"未认证去认证");
        ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc] init];
        [self pushVc:vc];
    }
}

- (void)refuseButtonClickedEvent {
    
    NSLog(@"拒绝申请");
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认拒接此次申请吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认");
        self.operationType = 8;
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"拒绝中..."];
        [self initOperationContractData];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)acceptButtonnClickedEvent {
    
    NSLog(@"接受申请");
    self.operationType = 2;
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"接受中..."];
    [self initOperationContractData];
}

- (void)againButtonClickedEventWithIndex:(NSInteger)index {
    
    // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起 31:房东拟定发起合同(重新发起合同) 32:房东已取消发起
    if (index == 1 || index == 9) {
        NSLog(@"取消签约");
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认取消签约申请吗？" message:@"确认后申请将失效" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确认");
            self.operationType = 7;
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"取消中..."];
            [self initOperationContractData];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertVC animated:YES completion:nil];
    }else if (index == 2) {
        NSLog(@"拟定合同");
        ZYRentSignInfoModel *model = [[ZYRentSignInfoModel alloc] init];
        model.contractId = self.contractId;
        model.assetId = self.detailModel.assetId;
        model.assetType = self.detailModel.assetType;
        model.isOnlinePayment = YES;
        model.signingDeadline = self.detailModel.countdownFinish;
        model.tenantUid = self.detailModel.tenantUid;
        model.tenantName = self.detailModel.realName;
        ZYMoulageHelperVc *vc = [[ZYMoulageHelperVc alloc] init];
        vc.rentSignInfoModel = model;
        vc.type = @"在线签约";
        [self pushVc:vc];
    }else if (index == 4 || index == 5 || index == 31) {
        NSLog(@"签约合同");
        ContrectAllDetailVc *vc = [[ContrectAllDetailVc alloc] init];
        vc.conId = self.detailModel.conId;
        [self pushVc:vc];
    }else if (index == 32) {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"房东已取消该合同" toView:self.view];
    }else if (index == 6) {
        NSLog(@"查看合同");
        ZYRentContractDetailVC *vc = [[ZYRentContractDetailVC alloc] init];
        vc.contractId = self.contractId;
        vc.identityType = self.identityType;
        [self pushVc:vc];
    }else if (index == 7) {
        NSLog(@"重新发起");
        self.operationType = 9;
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"发起中..."];
        [self initOperationContractData];
    }else if (index == 8) {
        NSLog(@"再次申请");
        self.operationType = 9;
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"发起中..."];
        [self initOperationContractData];
    }
}

#pragma mark - ZYSigningDetailUnauthorizedCellDelegate
- (void)contentViewTapEvent {
    
    NSLog(@"去认证");
    
    ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc] init];
    [self pushVc:vc];
}

#pragma mark - ZYSigningDetailBottomHintCellDelegate
- (void)rentButtonClickedEvent {
    
    NSLog(@"我的租赁");
    NSMutableArray *vcs = [NSMutableArray array];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CommunityManagementMainVcLate class]]) {
            CommunityManagementMainVcLate *vcLate = (CommunityManagementMainVcLate *)vc;
            vcLate.isJumpMyRent = YES;
            [vcs addObject:vc];
        }
    }
    self.navigationController.viewControllers = [vcs copy];
}

#pragma mark - ZYSigningDetailRenterInfoCellDelegate
- (void)landlordTelLabelEvent {
    if (self.detailModel.landlordPhone.length > 0) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            //设备系统为IOS 10.0或者以上的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.detailModel.landlordPhone]] options:@{} completionHandler:nil];
        }else{
            //设备系统为IOS 10.0以下的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.detailModel.landlordPhone]]];
        }
    }
}

#pragma mark - ZYSigningDetailLandlordInfoCellDelegate
- (void)telLabelEvent {
    if (self.detailModel.landlordPhone.length > 0) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            //设备系统为IOS 10.0或者以上的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.detailModel.landlordPhone]] options:@{} completionHandler:nil];
        }else{
            //设备系统为IOS 10.0以下的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.detailModel.landlordPhone]]];
        }
    }
}

@end
