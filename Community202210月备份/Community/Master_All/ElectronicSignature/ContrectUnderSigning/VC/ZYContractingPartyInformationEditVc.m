//
//  ZYContractingPartyInformationEditVc.m
//  Community
//
//  Created by ZY on 2021/5/18.
//

#import "ZYContractingPartyInformationEditVc.h"
#import "ZYContractingPartyInformationSearchVc.h"
#import "ZYContractSignCompleteVc.h"
#import "ZYContractingPartyInformationEditTopCell.h"
#import "ZYContractingPartyInformationEditCell.h"
#import "ZYContractingPartyInformationEditBottomView.h"
#import "ZYContractingPartyInformationEditModel.h"
#import "ZYContractingPartyInformationSearchModel.h"
#import "ZYContrectUnderSigningUploadModel.h"
#import "ZYSignPasswordView.h"
#import "ZYFillSignPasswordView.h"
#import "ZYElectronicSignatureModelData.h"
// 支付密码
#import "PayPasswordSetVC.h"

static NSString * const contractingPartyInformationEditTopCellID = @"ZYContractingPartyInformationEditTopCell";
static NSString * const contractingPartyInformationEditCellID = @"ZYContractingPartyInformationEditCell";
#define kContractingPartyInformationEditTopCellHeight 10
#define kContractingPartyInformationEditCellHeight 60

@interface ZYContractingPartyInformationEditVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYContractingPartyInformationEditBottomView *bottomView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ZYContractingPartyInformationSearchModel *searchModel;

@property (nonatomic, strong) ZYContrectUnderSigningUploadModel *signingUploadModel;

@property (nonatomic, strong) ZYSignPasswordView *signPasswordView;

@property (nonatomic, strong) ZYFillSignPasswordView *fillSignPasswordView;

// 设置密码
@property (nonatomic, assign) BOOL isShowPWView;

@property (nonatomic, copy) NSString *pwStr;

@property (nonatomic, copy) NSString *pwVerifyStr;

// 签署密码
@property (nonatomic, assign) BOOL isShowSignPWView;

@property (nonatomic, copy) NSString *signPWStr;

@end

@implementation ZYContractingPartyInformationEditVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写签约信息";
    self.isShowPWView = NO;
    self.isShowSignPWView = NO;
    [self setUI];
    [self customTableView];
    [self initData];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contractingPartyInformationSreachBack:) name:@"CONTANCT_PARTY_INFO_SEARCH_BACK" object:nil];
    // 注册签署密码设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signPasswordSettingBack) name:@"SIGN_PASSWORD_SETTING_BACK" object:nil];
    // 注册键盘通知
    [self registerForKeyboardNotifications];
    
    [self getIPAddress];
    [self getLocationInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
    
    [self getIPAddress];
    [self getLocationInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

// 通知回调
- (void)contractingPartyInformationSreachBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.searchModel = noti.object;
        ZYContractingPartyInformationEditModel *editModel = self.dataArray[3];
        editModel.content = self.searchModel.idCardName;
        [self.tableView reloadData];
    });
}

- (void)signPasswordSettingBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showSignPWView];
    });
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CONTANCT_PARTY_INFO_SEARCH_BACK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SIGN_PASSWORD_SETTING_BACK" object:nil];
}

- (void)setUI {
    
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bottomView.superview);
        make.bottom.equalTo(_bottomView.superview).offset(-bottom_height);
        make.height.offset(100);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    
    [self.view addSubview:self.signPasswordView];
    [_signPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_signPasswordView.superview);
    }];
    
    [self.view addSubview:self.fillSignPasswordView];
    [_fillSignPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_fillSignPasswordView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
}

- (ZYContractingPartyInformationEditBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYContractingPartyInformationEditBottomView" owner:nil options:nil].lastObject;
        [_bottomView.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _bottomView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (ZYContrectUnderSigningUploadModel *)signingUploadModel {
    if (!_signingUploadModel) {
        _signingUploadModel = [[ZYContrectUnderSigningUploadModel alloc] init];
    }
    
    return _signingUploadModel;
}

- (ZYFillSignPasswordView *)fillSignPasswordView {
    if (!_fillSignPasswordView) {
        _fillSignPasswordView = [[NSBundle mainBundle] loadNibNamed:@"ZYFillSignPasswordView" owner:nil options:nil].lastObject;
        _fillSignPasswordView.hidden = YES;
        _fillSignPasswordView.contentViewBottomConstraint.constant = kScreenH / 2 - 115;
        _fillSignPasswordView.titleLabel.text = @"发起签约";
        _fillSignPasswordView.pwTF.delegate = self;
        _fillSignPasswordView.pwTF.tag = 2000;
        _fillSignPasswordView.iconImageView.image = [UIImage imageNamed:@"ic_sign_f"];
        _fillSignPasswordView.nameLabel.text = [ShareUserInfo sharedUserInfo].userInfo.realName;
        [_fillSignPasswordView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fillSignPasswordViewTap)]];
        [_fillSignPasswordView.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_fillSignPasswordView.okButton setTitle:@"立即签约" forState:UIControlStateNormal];
        [_fillSignPasswordView.okButton addTarget:self action:@selector(signOkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fillSignPasswordView;
}

- (ZYSignPasswordView *)signPasswordView {
    if (!_signPasswordView) {
        _signPasswordView = [[NSBundle mainBundle] loadNibNamed:@"ZYSignPasswordView" owner:nil options:nil].lastObject;
        _signPasswordView.hidden = YES;
        _signPasswordView.pwViewBottomConstraint.constant = 0;
        _signPasswordView.titleLabel.text = @"设置签署密码";
        _signPasswordView.pwTF.delegate = self;
        _signPasswordView.pwTF.tag = 3000;
        _signPasswordView.okButton.hidden = YES;
        [_signPasswordView.okButton addTarget:self action:@selector(pwOkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _signPasswordView;
}

#pragma mark - 加载数据
- (void)initData {
    
    if (self.rentSignInfoModel.assetId.length > 0 && [self.contractTemplatesDataListModel.type isEqual:@"temp_type_rent"]) {
        self.searchModel = [[ZYContractingPartyInformationSearchModel alloc] init];
        self.searchModel.uuid = self.rentSignInfoModel.tenantUid;
        self.searchModel.idCardName = self.rentSignInfoModel.tenantName;
    }
    NSArray *titleArray = @[@"签约主题", @"发起方信息", @"发起时间", @"签约方信息", @"签约截止日期"];
    NSArray *typeArray;
    if (self.rentSignInfoModel.assetId.length > 0 && [self.contractTemplatesDataListModel.type isEqual:@"temp_type_rent"]) {
        typeArray = @[@"TF", @"TF", @"TF", @"TF", @"TF"];
    }else {
        typeArray = @[@"TF", @"TF", @"TF", @"select", @"date"];
    }
    for (int i = 0; i < titleArray.count; i++) {
        ZYContractingPartyInformationEditModel *model = [[ZYContractingPartyInformationEditModel alloc] init];
        model.title = titleArray[i];
        model.type = typeArray[i];
        model.index = i;
        if (i == 0) {
            model.content = self.contractTemplatesDataListModel.name;
        }else if (i == 1) {
            model.content = [ShareUserInfo sharedUserInfo].userInfo.realName;
        }else if (i == 2) {
            // 格式化时间
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
            model.content = dateStr;
        }else if (i == 3) {
            if (self.rentSignInfoModel.assetId.length > 0 && [self.contractTemplatesDataListModel.type isEqual:@"temp_type_rent"]) {
                model.content = self.searchModel.idCardName;
            }
        }else if (i == 4) {
            if (self.rentSignInfoModel.assetId.length > 0 && [self.contractTemplatesDataListModel.type isEqual:@"temp_type_rent"]) {
                model.content = self.rentSignInfoModel.signingDeadline.xh_format_yyyy_MM_dd_HH_mm;
            }
        }
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

// 发起签约数据
- (void)initInitiateSignData {
    NSDictionary *dict = [self.signingUploadModel yy_modelToJSONObject];
    NSString *jsonStr = [dict yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractInitiationUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.fillSignPasswordView.hidden = YES;
                ZYContractSignCompleteVc *vc = [[ZYContractSignCompleteVc alloc] init];
                vc.rentSignInfoModel = self.rentSignInfoModel;
                [self pushVc:vc];
            }else {
                [self.fillSignPasswordView clearText];
                self.signPWStr = @"";
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            [self.fillSignPasswordView clearText];
            self.signPWStr = @"";
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 签署密码是否存在数据
- (void)initIsSignPasswordData {
    [ZYElectronicSignatureModelData isSignPasswordCompletion:^(id  _Nullable responsObject, BOOL success) {
        if (success) {
            NSDictionary *dict = responsObject;
            BOOL status = [dict[@"status"] boolValue];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if (status) {
                [self showSignPWView];
                [userDefaults setValue:@"1" forKey:@"isSignPassword"];
            }else {
                [self showPWView];
                [userDefaults setValue:@"" forKey:@"isSignPassword"];
            }
            [userDefaults synchronize];
        }
    }];
}

// 设置签署密码数据
- (void)initSetSignPasswordData {
    NSDictionary *parms = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid, @"password" : self.pwStr};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractSetSignPasswordUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                [self showSignPWView];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 处理发起签约数据
- (void)handleSignData {
    
    // 合同类型 1:双方合同
    self.signingUploadModel.contractType = 1;
    // 发起方设备详细信息
    self.signingUploadModel.deviceInfo = [ZYDeviceInfoTool getDeviceInfo];
    for (int i = 0; i < self.dataArray.count; i++) {
        ZYContractingPartyInformationEditModel *editModel = self.dataArray[i];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        if (i == 0) {
            // 合同主题
            self.signingUploadModel.subject = editModel.content;
        }else if (i == 1) {
            // 发起人
            self.signingUploadModel.organizerId = [ShareUserInfo sharedUserInfo].userInfo.uid;
        }else if (i == 2) {
            // 合同创建时间
            self.signingUploadModel.createTime = [dateFormatter stringFromDate:[NSDate date]];
        }else if (i == 3) {
            // 签署人
            self.signingUploadModel.signatoryId = self.searchModel.uuid;
        }else if (i == 4) {
            if (self.rentSignInfoModel.assetId.length > 0 && [self.contractTemplatesDataListModel.type isEqual:@"temp_type_rent"]) {
                // 签约截止日期
                self.signingUploadModel.signingDeadline = self.rentSignInfoModel.signingDeadline;
            }else {
                NSDate *signingDeadlineDate = [NSDate xh_dateWithFormat_yyyy_MM_dd_HH_mm_string:editModel.content];
                NSString *signingDeadlineTime = [dateFormatter stringFromDate:signingDeadlineDate];
                // 签约截止日期
                self.signingUploadModel.signingDeadline = signingDeadlineTime;
            }
        }
    }
    // 发起人认证方式
    self.signingUploadModel.organAuthType = @"pass_auth";
    // 发起人密码/人脸数据/短信验证码
    self.signingUploadModel.organAuth = self.signPWStr;
    // 发起方印章
    ZYContractTemplateUploadTempParamModel *paramModel = [self.contractParams lastObject];
    NSString *jsonStr = paramModel.tValue;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                           options:NSJSONReadingMutableContainers
                                                             error:nil];
    self.signingUploadModel.organizerSealId = dict[@"uuid"];
    // 乙方是否必须手写
    self.signingUploadModel.partBMustHand = false;
    // 描述-说明
    self.signingUploadModel.remark = @"";
    // 短信验证码，本人操作验证
    self.signingUploadModel.smsCode = @"";
    // 合同模板id
    self.signingUploadModel.templateId = self.contractTemplatesDataListModel.uuid;
    // 附件
    self.signingUploadModel.annexFileId = self.sealImageDataModel.uuid;
    
    // 租赁签约信息
    // 签约id
    self.signingUploadModel.id = [self.rentSignInfoModel.contractId integerValue];
    // 房屋id
    self.signingUploadModel.assetId = self.rentSignInfoModel.assetId;
    // 资产类型
    self.signingUploadModel.assetType = self.rentSignInfoModel.assetType;
    // 是否需要支付
    self.signingUploadModel.isOnlinePayment = self.rentSignInfoModel.isOnlinePayment;
    
    // 合同内容
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    for (ZYContractTemplateUploadTempParamModel *tempModel in self.contractParams) {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:tempModel.tValue forKey:tempModel.tKey];
        [mDict addEntriesFromDictionary:dict];
    }
    self.signingUploadModel.contractParams = [mDict copy];
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 设置tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYContractingPartyInformationEditTopCell" bundle:nil] forCellReuseIdentifier:contractingPartyInformationEditTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYContractingPartyInformationEditCell" bundle:nil] forCellReuseIdentifier:contractingPartyInformationEditCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }else {
        
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ZYContractingPartyInformationEditTopCell *cell = [tableView dequeueReusableCellWithIdentifier:contractingPartyInformationEditTopCellID forIndexPath:indexPath];
        cell.bgView.backgroundColor = [UIColor clearColor];
        
        return cell;
    }else {
        ZYContractingPartyInformationEditCell *cell = [tableView dequeueReusableCellWithIdentifier:contractingPartyInformationEditCellID forIndexPath:indexPath];
        ZYContractingPartyInformationEditModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        cell.contentTF.tag = 100 + indexPath.row;
        cell.contentTF.delegate = self;
        cell.selectView.tag = 200 + indexPath.row;
        if (indexPath.row == 1 || indexPath.row == 2) {
            cell.contentTF.userInteractionEnabled = NO;
        }
        if (self.rentSignInfoModel.assetId.length > 0 && [self.contractTemplatesDataListModel.type isEqual:@"temp_type_rent"]) {
            if (indexPath.row == 3 || indexPath.row == 4) {
                cell.contentTF.userInteractionEnabled = NO;
            }
        }else {
            [cell.selectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewTap:)]];
        }
        if (indexPath.row == (self.dataArray.count - 1)) {
            cell.lineView.hidden = YES;
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return kContractingPartyInformationEditTopCellHeight;
    }else {
        
        return kContractingPartyInformationEditCellHeight;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    if (textField.tag == 2000) {
        if (textField.text.length < 6) {
            self.signPWStr = @"";
        }
    }else if (textField.tag == 3000) {
        if (textField.text.length < 6) {
            self.pwVerifyStr = @"";
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag != 5000) {
        ZYContractingPartyInformationEditModel *model = self.dataArray[textField.tag - 100];
        model.content = textField.text;
        // 有用户交互的输入框中，刷新tableView要用以下方法，为了避免输入框失去第一响应
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark - 监听键盘
- (void)registerForKeyboardNotifications {

    //使用NSNotificationCenter 键盘弹出时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillChangeFrameNotification object:nil];

    //使用NSNotificationCenter 键盘隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification*)aNotification {
    
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if (self.isShowPWView) {
        //输入框位置动画加载
        [UIView animateWithDuration:duration animations:^{
            self.signPasswordView.pwViewBottomConstraint.constant = keyboardSize.height - 24;
            [self.view layoutIfNeeded];
        }];
    }else if (self.isShowSignPWView) {
        [UIView animateWithDuration:duration animations:^{
            self.fillSignPasswordView.contentViewBottomConstraint.constant = keyboardSize.height + 20;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (self.isShowPWView) {
        [UIView animateWithDuration:duration animations:^{
            self.signPasswordView.pwViewBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }else if (self.isShowSignPWView) {
        [UIView animateWithDuration:duration animations:^{
            self.fillSignPasswordView.contentViewBottomConstraint.constant = kScreenH / 2 - 115;
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - 显示密码设置界面
- (void)showPWView {
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    self.isShowPWView = YES;
    self.isShowSignPWView = NO;
    self.signPasswordView.hidden = NO;
    self.fillSignPasswordView.hidden = YES;
    [self.signPasswordView.pwTF becomeFirstResponder];
    __weak typeof(self) weakSelf = self;
    self.signPasswordView.block = ^(NSString * _Nullable pwStr) {
        if (weakSelf.pwStr.length > 0) {
            weakSelf.pwVerifyStr = pwStr;
        }else {
            weakSelf.pwStr = pwStr;
            [weakSelf.signPasswordView clearText];
            weakSelf.signPasswordView.titleLabel.text = @"确认签署密码";
            weakSelf.signPasswordView.okButton.hidden = NO;
            [weakSelf.view reloadInputViews];
        }
    };
}

#pragma mark - 显示填写签署密码界面
- (void)showSignPWView {
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    self.isShowSignPWView = YES;
    self.isShowPWView = NO;
    self.fillSignPasswordView.hidden = NO;
    self.signPasswordView.hidden = YES;
    [self.fillSignPasswordView.pwTF becomeFirstResponder];
    __weak typeof(self) weakSelf = self;
    self.fillSignPasswordView.block = ^(NSString * _Nullable pwStr) {
        weakSelf.signPWStr = pwStr;
    };
}

#pragma mark - 获取ip地址
- (void)getIPAddress {
    // 发起方IP地址
    [ZYIPAdressTool deviceWANIPAddressBlock:^(NSString * _Nonnull ipAdress) {
        self.signingUploadModel.ipAddr = ipAdress;
    }];
}

#pragma mark - 获取位置信息
- (void)getLocationInfo {
    // 发起方位置
    [ZYPositioningManager startPositioningWithLocationCompletion:^(ZYPositioningModel * _Nullable model, NSError * _Nullable error) {
        if (model) {
            self.signingUploadModel.positionInfo = model.detailAddress;
        }else {
            [[ShareUserInfo sharedUserInfo] getDefaultsPositioningInfo];
            self.signingUploadModel.positionInfo = [ShareUserInfo sharedUserInfo].positioningModel.detailAddress;
        }
    }];
}

#pragma mark - 处理点击事件
// 发起签约
- (void)okButtonClicked {
    
    NSLog(@"发起签约");
    if ([self isContentNoEmptyPrompt]) {
//        [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"签约中..."];
//        [self initIsSignPasswordData];
        // 改用支付密码
        if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
            [self showSignPWView];
        }else {
            PayPasswordSetVC *vc = [[PayPasswordSetVC alloc] init];
            vc.type = Set_Password_Type_Pay;
            [self pushVc:vc];
        }
    }
}

// 提示内容不能为空
- (BOOL)isContentNoEmptyPrompt {
    for (ZYContractingPartyInformationEditModel *model in self.dataArray) {
        if (!(model.content.length > 0)) {
            [ZYProgressHUDTool showCustomHUDTextMessage:[NSString stringWithFormat:@"%@不能为空!", model.title] toView:self.view];
            
            return NO;
        }
    }
    
    return YES;
}

// 选择视图
- (void)selectViewTap:(UITapGestureRecognizer *)tap {
    
    NSInteger index = tap.view.tag - 200;
    if (index == 3) {
        ZYContractingPartyInformationSearchVc *vc = [[ZYContractingPartyInformationSearchVc alloc] init];
        [self pushVc:vc];
    }else if ((index == 4) || (index == 5)) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
        __weak typeof(self) weakSelf = self;
        ZYContractingPartyInformationEditModel *model = weakSelf.dataArray[index];
        [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMDHM title:model.title selectValue:dateStr resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            model.content = selectValue;
            [weakSelf.tableView reloadData];
        }];
    }
}

// 设置签署密码
- (void)pwOkButtonClicked {
    
    NSLog(@"设置签署密码");
    if (self.pwVerifyStr.length > 0) {
        if ([self.pwStr isEqualToString:self.pwVerifyStr]) {
            
            [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"设置中..."];
            [self initSetSignPasswordData];
        }else {
            self.pwStr = @"";
            self.pwVerifyStr = @"";
            self.signPasswordView.titleLabel.text = @"设置签署密码";
            self.signPasswordView.okButton.hidden = YES;
            [self.signPasswordView clearText];
            
            [ZYProgressHUDTool showCustomHUDTextMessage:@"密码和确认密码不一致,请重新设置密码!" toView:self.signPasswordView.hintView delay:3.0];
        }
    }else {
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"确认签署密码不能为空!" toView:self.signPasswordView.hintView delay:2.0];
    }
}

// 立即签约视图
- (void)fillSignPasswordViewTap {
    
    [self.fillSignPasswordView.pwTF becomeFirstResponder];
}

// 立即签约关闭视图
- (void)closeButtonClicked {
    
    [self.view endEditing:YES];
    self.signPWStr = @"";
    [self.fillSignPasswordView clearText];
    self.fillSignPasswordView.hidden = YES;
}

// 立即签约
- (void)signOkButtonClicked {
    
    NSLog(@"立即签约");
    if (self.signPWStr.length > 0) {
        [self handleSignData];
        [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"签约中..."];
        [self initInitiateSignData];
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"签署密码不能为空!" toView:self.fillSignPasswordView.contentView];
    }
}

@end
