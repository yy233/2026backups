//
//  ZYRentContractDetailVC.m
//  Community
//
//  Created by ZY on 2021/8/21.
//

#import "ZYRentContractDetailVC.h"
#import "ZYContractHTMLDetailVc.h"
#import "ZYProcessEvidenceVc.h"
#import "ZYMoulageHelperVc.h"
#import "ZYRentContractDetailHouseInfoCell.h"
#import "ZYRentContractDetailCell.h"
#import "ZYRentContractDetailBottomView.h"
#import "ZYFileReceiveEmailView.h"

static CGFloat emailViewDuration = 0.25;
static NSString * const rentContractDetailHouseInfoCellID = @"ZYRentContractDetailHouseInfoCell";
static NSString * const rentContractDetailCellID = @"ZYRentContractDetailCell";

#define kRentContractDetailHouseInfoCellHeight 167
#define kRentContractDetailHouseInfoCellNoTopHeight 134
#define kRentContractDetailCellHeight 248

@interface ZYRentContractDetailVC () <UITableViewDataSource, UITableViewDelegate, ZYRentContractDetailCellDelegate, ZYRentContractDetailBottomViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYRentContractDetailBottomView *bottomView;

@property (nonatomic, strong) ZYFileReceiveEmailView *emailView;

@property (nonatomic, copy) NSString *emailStr;

@property (nonatomic, strong) ZYSigningDetailDataModel *detailModel;

@end

@implementation ZYRentContractDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签约中";
    
    [self setUI];
    [self customTableView];
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    self.tableView.hidden = YES;
    self.bottomView.hidden = YES;
    [self initRentSignDetailData];
    
    // 注册键盘通知
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
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
    
    [self.view addSubview:self.emailView];
    [_emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_emailView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (ZYRentContractDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYRentContractDetailBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (ZYFileReceiveEmailView *)emailView {
    if (!_emailView) {
        _emailView = [[NSBundle mainBundle] loadNibNamed:@"ZYFileReceiveEmailView" owner:nil options:nil].lastObject;
        _emailView.hidden = YES;
        _emailView.contentViewBottomConstraint.constant = kScreenH / 2 - 125;
        [_emailView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailViewTap)]];
        [_emailView.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTap)]];
        [_emailView.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _emailView.emailTF.delegate = self;
        [_emailView.sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _emailView;
}

#pragma mark - 加载数据
// 加载租赁签约详情数据
- (void)initRentSignDetailData {
    
    NSDictionary *params = @{@"id" : self.contractId, @"identityType" : @(self.identityType)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kRentSignDetailUrl] withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYSigningDetailModel *model = [ZYSigningDetailModel yy_modelWithJSON:responsObject];
                self.detailModel = model.data;
                if (self.detailModel.operation == 6) {
                    self.title = @"已签约";
                }
                self.tableView.hidden = NO;
                self.bottomView.hidden = NO;
                [self.tableView reloadData];
                [self initBottomViewData];
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

// 加载房东取消发起合同数据
- (void)initContractCancelData {
    NSDictionary *parms = @{@"userId" : [ShareUserInfo sharedUserInfo].userInfo.uid, @"conId" : self.detailModel.conId};
    NSString *jsonStr = [parms yy_modelToJSONString];
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kRentContractCancelUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.detailModel.operation = 32;
                [self.tableView reloadData];
                [self initBottomViewData];
            }else {
              
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
           
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 重新上链数据
- (void)initSelfTestRetryData {
    
    NSString *uuid =  [ShareUserInfo sharedUserInfo].userInfo.uid;
    NSDictionary *parms = @{@"contractId" : self.detailModel.conId, @"userUuid" : uuid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kSelfTestRetryUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
               
                self.emailView.hidden = YES;
                [ZYProgressHUDTool showCustomHUDTextMessage:@"区块链已重新上链" toView:self.view];
            }else {
                
                self.emailView.hidden = YES;
                [ZYProgressHUDTool showCustomHUDTextMessage:Y_ResponsObject_messageStr toView:self.view];
            }
        }else {
            
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 下载合同数据
- (void)initDownloadContractData {
    
    NSString *uuid =  [ShareUserInfo sharedUserInfo].userInfo.uid;
    NSDictionary *parms = @{@"conId" : self.detailModel.conId, @"userId" : uuid, @"e_mail" : self.emailStr};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractDownloadUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
               
                self.emailView.emailTF.text = @"";
                self.emailStr = @"";
                self.emailView.hidden = YES;
                [ZYProgressHUDTool showCustomHUDTextMessage:@"已发送到您的邮箱,请注意查收!" toView:self.view];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYRentContractDetailHouseInfoCell" bundle:nil] forCellReuseIdentifier:rentContractDetailHouseInfoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYRentContractDetailCell" bundle:nil] forCellReuseIdentifier:rentContractDetailCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ZYRentContractDetailHouseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:rentContractDetailHouseInfoCellID forIndexPath:indexPath];
        cell.model = self.detailModel;
        
        return cell;
    }else {
        ZYRentContractDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:rentContractDetailCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.detailModel;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.detailModel.operation == 32) {
            
            return kRentContractDetailHouseInfoCellHeight;
        }else {
            
            return kRentContractDetailHouseInfoCellNoTopHeight;
        }
    }else {
        
        return kRentContractDetailCellHeight;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    self.emailStr = textField.text;
}

#pragma mark - ZYRentContractDetailCellDelegate
// 查看合同
- (void)nameContentViewTapEvent {
    
    NSLog(@"合同html详情");
    ZYContractHTMLDetailVc *vc = [[ZYContractHTMLDetailVc alloc] init];
    vc.conId = self.detailModel.conId;
    vc.conName = self.detailModel.conName;
    [self pushVc:vc];
}

#pragma mark - ZYRentContractDetailBottomViewDelegate
// 区块链司法存证
- (void)depositCertificateButtonClickedEvent {
    
    NSLog(@"区块链司法存证");
    ZYProcessEvidenceVc *vc = [[ZYProcessEvidenceVc alloc] init];
    vc.conId = self.detailModel.conId;
    [self pushVc:vc];
}

// 下载合同
- (void)downloadContractButtonClickedEvent {
    
    NSLog(@"下载合同");
    self.emailView.hidden = NO;
    [self.emailView.emailTF becomeFirstResponder];
    self.emailView.alpha = 0.0;
    [UIView animateWithDuration:emailViewDuration animations:^{
        self.emailView.alpha = 1.0;
    }];
}

// 点击状态按钮
- (void)statusButtonEventWithIndex:(NSInteger)index {
    
    NSLog(@"index = %ld", index);
    if (index == 6) {
        NSLog(@"区块链司法存证上链中...");
        [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"区块链重新上链中..."];
        [self initSelfTestRetryData];
    }else {
        if (index == 32) {
            NSLog(@"重新发起");
            ZYRentSignInfoModel *model = [[ZYRentSignInfoModel alloc] init];
            model.contractId = self.contractId;
            model.assetId = self.detailModel.assetId;
            model.assetType = self.detailModel.assetType;
            model.isOnlinePayment = YES;
            model.signingDeadline = self.detailModel.countdownFinish;
            model.tenantUid = self.detailModel.tenantUid;
            model.tenantName = self.detailModel.realName;
            ZYMoulageHelperVc *vc = [[ZYMoulageHelperVc alloc] init];
            vc.type = @"在线签约";
            vc.rentSignInfoModel = model;
            [self pushVc:vc];
        }else {
            NSLog(@"取消发起");
            if (self.detailModel.operation == 5) {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"操作失败，租客已付款" toView:self.view];
            }else {
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"取消后需重新拟定合同" message:@"确认取消吗？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"取消");
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"确认");
                    [SVProgressHUD showLoadingCustomHUDWithStatus:@"取消中..."];
                    [self initContractCancelData];
                }];
                [alertVC addAction:cancelAction];
                [alertVC addAction:okAction];
                alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }
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
    [UIView animateWithDuration:duration animations:^{
        if (keyboardSize.height + 10 > kScreenH / 2 - 125) {
            self.emailView.contentViewBottomConstraint.constant = keyboardSize.height + 10;
        }else {
            self.emailView.contentViewBottomConstraint.constant = kScreenH / 2 - 125;
        }
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {

    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.emailView.contentViewBottomConstraint.constant = kScreenH / 2 - 125;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 处理点击事件
// 点击emailView
- (void)emailViewTap {
    [self.view endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(emailViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.emailView.hidden = YES;
    });
    self.emailView.alpha = 1.0;
    [UIView animateWithDuration:emailViewDuration animations:^{
        self.emailView.alpha = 0.0;
    }];
}

// 点击contentView
- (void)contentViewTap {
}

// 关闭
- (void)closeButtonClicked {
    [self.view endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(emailViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.emailView.hidden = YES;
    });
    self.emailView.alpha = 1.0;
    [UIView animateWithDuration:emailViewDuration animations:^{
        self.emailView.alpha = 0.0;
    }];
}

// 发送
- (void)sendButtonClicked {
    
    [self.view endEditing:YES];
    NSLog(@"发送");
    if (self.emailStr.length > 0 && [ZYTextValidationTool validateEmail:[self.emailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
        [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"下载中..."];
        [self initDownloadContractData];
    }else {
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"您输入的邮箱格式不正确" toView:self.view];
    }
}

@end
