//
//  ZYContractSignCompleteDetailVc.m
//  Community
//
//  Created by ZY on 2021/5/26.
//

#import "ZYContractSignCompleteDetailVc.h"
#import "ZYContractHTMLDetailVc.h"
#import "ZYProcessEvidenceVc.h"
#import "ZYContractSignCompleteDetailCell.h"
#import "ZYContractSignCompleteDetailBottomView.h"
#import "ZYFileReceiveEmailView.h"

static NSString * const contractSignCompleteDetailCellID = @"ZYContractSignCompleteDetailCell";
static CGFloat emailViewDuration = 0.25;
#define kContractSignCompleteDetailCellHeight 406

@interface ZYContractSignCompleteDetailVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZYContractSignCompleteDetailCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYContractSignCompleteDetailBottomView *bottomView;

@property (nonatomic, strong) ZYFileReceiveEmailView *emailView;

@property (nonatomic, copy) NSString *emailStr;

@property (nonatomic, strong) ZYContrectAllListDataListModel *detailModel;

@end

@implementation ZYContractSignCompleteDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"合同详情";
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initContractDetailData];
    
    // 注册键盘通知
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.emailView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(50 + button_bottom_height);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    [_emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_emailView.superview);
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

- (ZYContractSignCompleteDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYContractSignCompleteDetailBottomView" owner:nil options:nil].lastObject;
        if (self.detailModel.blockStatus == 4) {
            _bottomView.depositCertificateHandleButton.hidden = YES;
            _bottomView.depositCertificateButton.hidden = NO;
            _bottomView.downloadContractButton.hidden = NO;
            _bottomView.lineView.hidden = NO;
            [_bottomView.depositCertificateButton addTarget:self action:@selector(depositCertificateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView.downloadContractButton addTarget:self action:@selector(downloadContractButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }else {
            _bottomView.depositCertificateHandleButton.hidden = NO;
            _bottomView.depositCertificateButton.hidden = YES;
            _bottomView.downloadContractButton.hidden = YES;
            _bottomView.lineView.hidden = YES;
            [_bottomView.depositCertificateHandleButton addTarget:self action:@selector(depositCertificateHandleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }
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
// 获取合同详情数据
- (void)initContractDetailData {
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    NSDictionary *parms = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid, @"conId" : self.conId};
    NSString *jsonStr = [parms yy_modelToJSONString];
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractDetailUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                self.detailModel = [ZYContrectAllListDataListModel yy_modelWithJSON:jsonStr];
                [self setUI];
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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYContractSignCompleteDetailCell" bundle:nil] forCellReuseIdentifier:contractSignCompleteDetailCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYContractSignCompleteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:contractSignCompleteDetailCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.detailModel;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kContractSignCompleteDetailCellHeight;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    self.emailStr = textField.text;
}

#pragma mark - ZYContractSignCompleteDetailCellDelegate
- (void)contractViewTapEvent {
    
    NSLog(@"合同html详情");
    ZYContractHTMLDetailVc *vc = [[ZYContractHTMLDetailVc alloc] init];
    vc.conId = self.detailModel.conId;
    vc.conName = self.detailModel.conName;
    [self pushVc:vc];
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
// 区块链存证上链中
- (void)depositCertificateHandleButtonClicked {
    
    NSLog(@"区块链存证上链中");
    
    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"区块链重新上链中..."];
    [self initSelfTestRetryData];
}

// 区块链司法存证
- (void)depositCertificateButtonClicked {
    
    NSLog(@"区块链司法存证");
    
    ZYProcessEvidenceVc *vc = [[ZYProcessEvidenceVc alloc] init];
    vc.conId = self.detailModel.conId;
    [self pushVc:vc];
}

// 下载合同
- (void)downloadContractButtonClicked {
    
    NSLog(@"下载合同");
    self.emailView.hidden = NO;
    [self.emailView.emailTF becomeFirstResponder];
    self.emailView.alpha = 0.0;
    [UIView animateWithDuration:emailViewDuration animations:^{
        self.emailView.alpha = 1.0;
    }];
}

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
