//
//  ContrectAllDetailVc.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "ContrectAllDetailVc.h"
#import "ContrectSignSuccessVc.h"
#import "ZYContractHTMLDetailVc.h"
#import "ZYZhangDrawVC.h"
#import "ZYRentSigningPayVC.h"
#import "ContrectAllDetailTextTableViewCell.h"
#import "ContrectAllDetailPdfDownTableViewCell.h"
#import "ZYContrectAllDetailImgTableViewCell.h"
#import "ZYContractingPartyInformationEditBottomView.h"
#import "ZYZhangManagerModel.h"
#import "ZYContractSignUploadModel.h"
#import "ZYSignPasswordView.h"
#import "ZYFillSignPasswordView.h"
#import "ZYElectronicSignatureModelData.h"
// 支付密码
#import "PayPasswordSetVC.h"

#define  ContrectAllDetailTextTableViewCell_Identifier            @"ContrectAllDetailTextTableViewCell"
#define  ContrectAllDetailPdfDownTableViewCell_Identifier         @"ContrectAllDetailPdfDownTableViewCell"
#define  ZYContrectAllDetailImgTableViewCell_Identifier       @"ZYContrectAllDetailImgTableViewCell"

@interface ContrectAllDetailVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZYZhangDrawVCDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYContractingPartyInformationEditBottomView *bottomView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) BOOL isSystemSeal;

@property (nonatomic, strong) ZYZhangManagerDataModel *currentSealModel;

@property (nonatomic, strong) ZYContractSignUploadModel *contractSignUploadModel;

@property (nonatomic, strong) ZYSignPasswordView *signPasswordView;

@property (nonatomic, strong) ZYFillSignPasswordView *fillSignPasswordView;

@property (nonatomic, strong) ZYContrectAllListDataListModel *detailModel;

// 设置密码
@property (nonatomic, assign) BOOL isShowPWView;

@property (nonatomic, copy) NSString *pwStr;

@property (nonatomic, copy) NSString *pwVerifyStr;

// 签署密码
@property (nonatomic, assign) BOOL isShowSignPWView;

@property (nonatomic, copy) NSString *signPWStr;

@end

@implementation ContrectAllDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写签署信息";
    self.isSystemSeal = NO;
    self.isShowPWView = NO;
    self.isShowSignPWView = NO;
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initContractDetailData];
    
    [self getIPAddress];
    [self getLocationInfo];
    
    // 注册键盘通知
    [self registerForKeyboardNotifications];
    
    // 注册租赁缴费成功通知
    Y_NSNotificationCenter_Creat_NameAction(@"RENT_SIGNING_PAY_BACK", rentSigningPayBack)
    // 注册签署密码设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signPasswordSettingBack) name:@"SIGN_PASSWORD_SETTING_BACK" object:nil];
}

// 通知回调
- (void)rentSigningPayBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.detailModel.canSign = YES;
        [self.tableView reloadData];
//        [self initIsSignPasswordData];
        // 改用支付密码
        if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
            [self showSignPWView];
        }else {
            PayPasswordSetVC *vc = [[PayPasswordSetVC alloc] init];
            vc.type = Set_Password_Type_Pay;
            [self pushVc:vc];
        }
    });
}

- (void)signPasswordSettingBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showSignPWView];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"RENT_SIGNING_PAY_BACK")
    Y_NSNotificationCenter_RemoveNotice_Name(@"SIGN_PASSWORD_SETTING_BACK")
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
    
    [self getIPAddress];
    [self getLocationInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (ZYContractingPartyInformationEditBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYContractingPartyInformationEditBottomView" owner:nil options:nil].lastObject;
        _bottomView.hidden = YES;
        [_bottomView.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _bottomView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"合同名称 :", @"签约发起日期 :", @"合同起止日期 :", @"发起方 :", @"签约方 :", @"签约方印章 :"];
    }
    
    return _titleArray;
}

- (ZYZhangManagerDataModel *)currentSealModel {
    if (!_currentSealModel) {
        _currentSealModel = [[ZYZhangManagerDataModel alloc] init];
    }
    
    return _currentSealModel;
}

- (ZYContractSignUploadModel *)contractSignUploadModel {
    if (!_contractSignUploadModel) {
        _contractSignUploadModel = [[ZYContractSignUploadModel alloc] init];
    }
    
    return _contractSignUploadModel;
}

- (ZYFillSignPasswordView *)fillSignPasswordView {
    if (!_fillSignPasswordView) {
        _fillSignPasswordView = [[NSBundle mainBundle] loadNibNamed:@"ZYFillSignPasswordView" owner:nil options:nil].lastObject;
        _fillSignPasswordView.hidden = YES;
        _fillSignPasswordView.contentViewBottomConstraint.constant = kScreenH / 2 - 115;
        _fillSignPasswordView.titleLabel.text = @"接受签署";
        _fillSignPasswordView.pwTF.delegate = self;
        _fillSignPasswordView.pwTF.tag = 2000;
        _fillSignPasswordView.iconImageView.image = [UIImage imageNamed:@"ic_sign_s"];
        _fillSignPasswordView.nameLabel.text = [ShareUserInfo sharedUserInfo].userInfo.realName;
        [_fillSignPasswordView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fillSignPasswordViewTap)]];
        [_fillSignPasswordView.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_fillSignPasswordView.okButton setTitle:@"立即签署" forState:UIControlStateNormal];
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
                [self.tableView reloadData];
                if (self.detailModel.going == 2) {
                    self.bottomView.hidden = NO;
                    [self initSystemSealData];
                    if (self.detailModel.canSign) {
                        [self.bottomView.okButton setTitle:@"确认签署" forState:UIControlStateNormal];
                    }else {
                        [self.bottomView.okButton setTitle:@"支付并签署" forState:UIControlStateNormal];
                    }
                }
            }else {
              
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
           
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 系统印章数据
- (void)initSystemSealData {
    
    NSString *uuid = [ShareUserInfo sharedUserInfo].userInfo.uid;
    NSDictionary *parms = @{@"userUuid" : uuid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kSystemSealUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.isSystemSeal = YES;
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                self.currentSealModel = [ZYZhangManagerDataModel yy_modelWithJSON:jsonStr];
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 签署数据
- (void)initContractSignData {
    
    NSDictionary *parms = [self.contractSignUploadModel yy_modelToJSONObject];
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractBtoSignUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"CONTRACT_ALL_DETAIL_BACK")
                ContrectSignSuccessVc *vc = [[ContrectSignSuccessVc alloc] init];
                [self pushVc:vc];
            }else {
                [self.fillSignPasswordView clearText];
                self.signPWStr = @"";
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
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

// 租赁合同是否付款数据
- (void)initIsContractPayData {
    NSDictionary *parms = @{@"contractUuid" : self.conId};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kIsContractPayUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                NSLog(@"jsonStr = %@", jsonStr);
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
                BOOL status = [dict[@"status"] boolValue];
                if (status) {
                    NSLog(@"已支付");
//                    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"签署中..."];
//                    [self initIsSignPasswordData];
                    // 改用支付密码
                    if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
                        [self showSignPWView];
                    }else {
                        PayPasswordSetVC *vc = [[PayPasswordSetVC alloc] init];
                        vc.type = Set_Password_Type_Pay;
                        [self pushVc:vc];
                    }
                }else {
                    NSLog(@"未支付");
                    ZYRentSigningPayVC *vc = [[ZYRentSigningPayVC alloc] init];
                    vc.conId = self.conId;
                    [self pushVc:vc];
                }
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 处理合同签署数据
- (void)handleContractSignData {
    
    // 验证方式
    self.contractSignUploadModel.authType = @"pass_auth";
    // 签署密码
    self.contractSignUploadModel.auth = self.signPWStr;
    // 合同管理id
    self.contractSignUploadModel.conId = self.detailModel.conId;
    // 签署方设备详细信息
    self.contractSignUploadModel.deviceInfo = [ZYDeviceInfoTool getDeviceInfo];
    // 描述
    self.contractSignUploadModel.remark = @"";
    // 签署人印章id
    self.contractSignUploadModel.sealId = self.currentSealModel.uuid;
    // 短信验证码
    self.contractSignUploadModel.smsCode = @"";
    // 签署人uid
    self.contractSignUploadModel.userId = [ShareUserInfo sharedUserInfo].userInfo.uid;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ContrectAllDetailPdfDownTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ContrectAllDetailPdfDownTableViewCell_Identifier];
        if (!cell) {
            cell = [[ContrectAllDetailPdfDownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContrectAllDetailPdfDownTableViewCell_Identifier];
        }
        cell.titleL.text = self.titleArray[indexPath.row];
        cell.companyLabel.text = self.detailModel.conName;
        
        return cell;
    }else if (indexPath.row == 1) {
        ContrectAllDetailTextTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ContrectAllDetailTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[ContrectAllDetailTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContrectAllDetailTextTableViewCell_Identifier];
        }
        cell.titleL.text = self.titleArray[indexPath.row];
        cell.detailTitleL.text = self.detailModel.createTime;
        
        return cell;
    }else if (indexPath.row == 2) {
        ContrectAllDetailTextTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ContrectAllDetailTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[ContrectAllDetailTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContrectAllDetailTextTableViewCell_Identifier];
        }
        cell.titleL.text = self.titleArray[indexPath.row];
        cell.detailTitleL.text = [NSString stringWithFormat:@"%@-%@", self.detailModel.startTime.xh_format_yyyyMMdd, self.detailModel.endTime.xh_format_yyyyMMdd];
        
        return cell;
    }else if (indexPath.row == 3) {
        ContrectAllDetailTextTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ContrectAllDetailTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[ContrectAllDetailTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContrectAllDetailTextTableViewCell_Identifier];
        }
        cell.titleL.text = self.titleArray[indexPath.row];
        cell.detailTitleL.text = self.detailModel.partAName;
        
        return cell;
    }else if (indexPath.row == 4) {
        ContrectAllDetailTextTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ContrectAllDetailTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[ContrectAllDetailTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContrectAllDetailTextTableViewCell_Identifier];
        }
        cell.titleL.text = self.titleArray[indexPath.row];
        cell.detailTitleL.text = self.detailModel.partBName;
        
        return cell;
    }else {
        ZYContrectAllDetailImgTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ZYContrectAllDetailImgTableViewCell_Identifier];
        if (!cell) {
            cell = [[ZYContrectAllDetailImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZYContrectAllDetailImgTableViewCell_Identifier];
        }
        cell.titleL.text = self.titleArray[indexPath.row];
        if (self.detailModel.going == 2) {
            if (self.currentSealModel.sealUrl.length > 0) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, self.currentSealModel.sealUrl]];
                [cell.signImageView sd_setImageWithURL:url];
            }
        }else  {
            cell.rightImageView.hidden = YES;
            cell.signImageView.hidden = YES;
            [cell.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.rightImageView.superview).offset(10);
            }];
            [self.view layoutIfNeeded];
            cell.titleL.text = self.titleArray[indexPath.row];
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ZYContractHTMLDetailVc *vc = [[ZYContractHTMLDetailVc alloc] init];
        vc.conId = self.detailModel.conId;
        vc.conName = self.detailModel.conName;
        [self pushVc:vc];
    }
    if (self.detailModel.going == 2) {
        if (indexPath.row == 5) {
            [self signViewTap];
        }
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

#pragma mark - ZYZhangDrawVCDelegate
- (void)zhangDrawWithModel:(ZYZhangManagerDataModel *)model {
    
    self.currentSealModel = model;
    [self.tableView reloadData];
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
    // 签署方IP地址
    [ZYIPAdressTool deviceWANIPAddressBlock:^(NSString * _Nonnull ipAdress) {
        self.contractSignUploadModel.ipAddr = ipAdress;
    }];
}

#pragma mark - 获取位置信息
- (void)getLocationInfo {
    // 签署方位置
    [ZYPositioningManager startPositioningWithLocationCompletion:^(ZYPositioningModel * _Nullable model, NSError * _Nullable error) {
        if (model) {
            self.contractSignUploadModel.positionInfo = model.detailAddress;
        }else {
            [[ShareUserInfo sharedUserInfo] getDefaultsPositioningInfo];
            self.contractSignUploadModel.positionInfo = [ShareUserInfo sharedUserInfo].positioningModel.detailAddress;
        }
    }];
}

#pragma mark - 处理点击事件
// 印章
- (void)signViewTap {
    
    [BRStringPickerView showPickerWithTitle:nil dataSourceArr:@[@"个人系统印章", @"手写印章"] selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
        if (resultModel.index == 0) {
            
            NSLog(@"个人系统印章");
            if (!self.isSystemSeal) {
                [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
                [self initSystemSealData];
            }
        }else if (resultModel.index == 1) {
            
            NSLog(@"手写印章");
            self.isSystemSeal = NO;
            ZYZhangDrawVC *vc = [[ZYZhangDrawVC alloc] init];
            vc.delegate = self;
            [self pushVc:vc];
        }
    }];
}

// 确认签署
- (void)okButtonClicked {
    
    NSLog(@"确认签署");
    if (self.currentSealModel.sealUrl.length > 0) {
        if ([self isRentPay]) {
//            [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"签署中..."];
//            [self initIsSignPasswordData];
            // 改用支付密码
            if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
                [self showSignPWView];
            }else {
                PayPasswordSetVC *vc = [[PayPasswordSetVC alloc] init];
                vc.type = Set_Password_Type_Pay;
                [self pushVc:vc];
            }
        }else {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
            [self initIsContractPayData];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"签约方印章不能为空!" toView:self.view];
    }
}

// 是否支付判断
- (BOOL)isRentPay {
    
    if (self.detailModel.isOnlinePayment) {
        if (!self.detailModel.canSign) {
            
            return NO;
        }
    }
    
    return YES;
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
        [self handleContractSignData];
        [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"签署中..."];
        [self initContractSignData];
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"签署密码不能为空!" toView:self.fillSignPasswordView.contentView];
    }
}

@end
