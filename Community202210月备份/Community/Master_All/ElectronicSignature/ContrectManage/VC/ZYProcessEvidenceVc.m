//
//  ZYProcessEvidenceVc.m
//  Community
//
//  Created by ZY on 2021/5/28.
//

#import "ZYProcessEvidenceVc.h"
#import "ZYProcessEvidenceTopCell.h"
#import "ZYProcessEvidenceCell.h"
#import "ZYProcessEvidencePartiesCell.h"
#import "ZYProcessEvidenceDepositCertificateCell.h"
#import "ZYFileReceiveEmailView.h"

static NSString * const processEvidenceTopCellID = @"ZYProcessEvidenceTopCell";
static NSString * const processEvidenceCellID = @"ZYProcessEvidenceCell";
static NSString * const processEvidencePartiesCellID = @"ZYProcessEvidencePartiesCell";
static NSString * const processEvidenceDepositCertificateCellID = @"ZYProcessEvidenceDepositCertificateCell";
static CGFloat emailViewDuration = 0.25;
#define kProcessEvidenceCellHeight 70

@interface ZYProcessEvidenceVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIButton *navRightBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ZYProcessEvidenceDataModel *dataModel;

@property (nonatomic, strong) ZYFileReceiveEmailView *emailView;

@property (nonatomic, copy) NSString *emailStr;

@end

@implementation ZYProcessEvidenceVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"过程证据";
    
    [self rightBarButtonItemCustom];
    [self setUI];
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initProcessEvidenceData];
    
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

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {

    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navRightBtn setImage:[UIImage imageNamed:@"ic_explain"] forState:UIControlStateNormal];
    self.navRightBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [self.navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.emailView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    [_emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_emailView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
        footView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = footView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
// 过程证据数据
- (void)initProcessEvidenceData {
    
    NSString *uuid =  [ShareUserInfo sharedUserInfo].userInfo.uid;
    NSDictionary *parms = @{@"conId" : self.conId, @"userId" : uuid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kProcessEvidenceUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
               
                [self customTableView];
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                self.dataModel = [ZYProcessEvidenceDataModel yy_modelWithJSON:jsonStr];
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:self.dataModel.processRecordTimestampParamList];
                [self.tableView reloadData];
            }else {
                
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 下载合同数据
- (void)initDownloadContractData {
    
    NSDictionary *parms = @{@"evidenceCode" : self.dataModel.extractionCode, @"e_mail" : self.emailStr};
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestGetURL:kContractDownloadProcUrl withParams:parms.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYProcessEvidenceTopCell" bundle:nil] forCellReuseIdentifier:processEvidenceTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYProcessEvidenceCell" bundle:nil] forCellReuseIdentifier:processEvidenceCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYProcessEvidencePartiesCell" bundle:nil] forCellReuseIdentifier:processEvidencePartiesCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYProcessEvidenceDepositCertificateCell" bundle:nil] forCellReuseIdentifier:processEvidenceDepositCertificateCellID];
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
        ZYProcessEvidenceTopCell *cell = [tableView dequeueReusableCellWithIdentifier:processEvidenceTopCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else {
        ZYProcessEvidenceDataListModel *model = self.dataArray[indexPath.row];
        if (model.dataType == 0) {
            ZYProcessEvidenceCell *cell = [tableView dequeueReusableCellWithIdentifier:processEvidenceCellID forIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            
            return cell;
        }else if (model.dataType == 1) {
            ZYProcessEvidencePartiesCell *cell = [tableView dequeueReusableCellWithIdentifier:processEvidencePartiesCellID forIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            
            return cell;
        }else {
            ZYProcessEvidenceDepositCertificateCell *cell = [tableView dequeueReusableCellWithIdentifier:processEvidenceDepositCertificateCellID forIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            
            return cell;
        }
    }
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYProcessEvidenceTopCell *cell = (ZYProcessEvidenceTopCell *)currentCell;
        [cell.inspectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inspectionViewTap)]];
        [cell.extractButton addTarget:self action:@selector(extractButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        cell.evidenceCodeLabel.text = self.dataModel.extractionCode;
    }else {
        ZYProcessEvidenceDataListModel *model = self.dataArray[indexPath.row];
        if (model.dataType == 0) {
            ZYProcessEvidenceCell *cell = (ZYProcessEvidenceCell *)currentCell;
            cell.partView.tag = 100 + indexPath.row;
            [cell.partView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(partViewTap:)]];
            cell.telButton.tag = 200 + indexPath.row;
            [cell.telButton addTarget:self action:@selector(telButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.model = model.data;
        }else if (model.dataType == 1) {
            ZYProcessEvidencePartiesCell *cell = (ZYProcessEvidencePartiesCell *)currentCell;
            cell.model = model.data;
        }else {
            ZYProcessEvidenceDepositCertificateCell *cell = (ZYProcessEvidenceDepositCertificateCell *)currentCell;
            cell.model = model.data;
        }
    }
}

#pragma mark -  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:processEvidenceTopCellID cacheByIndexPath:indexPath configuration:^(ZYProcessEvidenceTopCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else {
        ZYProcessEvidenceDataListModel *model = self.dataArray[indexPath.row];
        if (model.dataType == 0) {
            if (model.data.isSelected) {
                return [tableView fd_heightForCellWithIdentifier:processEvidenceCellID cacheByIndexPath:indexPath configuration:^(ZYProcessEvidenceCell *cell) {
                    [self configureCell:cell atIndexPath:indexPath];
                }];
            }
            return kProcessEvidenceCellHeight;
        }else if (model.dataType == 1) {
            return [tableView fd_heightForCellWithIdentifier:processEvidencePartiesCellID cacheByIndexPath:indexPath configuration:^(ZYProcessEvidencePartiesCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];
            }];
        }else {
            return [tableView fd_heightForCellWithIdentifier:processEvidenceDepositCertificateCellID cacheByIndexPath:indexPath configuration:^(ZYProcessEvidenceDepositCertificateCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        
        return 20;
    }
    
    return 0;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    self.emailStr = textField.text;
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
// 关于
- (void)navRightBtnAction {
    
    NSLog(@"关于");
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 110)];
    lab.text = @"过程证据是将整个数据过程记录生成的完整证据链条。过程证据确保了电子数据和合同的司法效力，还起到防篡改可追溯的作用。保全成功：暨上链存证成功。已生成唯一存证编号并上链到司法链和其他区块链网络。";
    lab.textColor = [ZYThemeManager shareManager].titleThemeColor;
    lab.font = [UIFont systemFontOfSize:13];
    lab.numberOfLines = 0;
    
    CustomPopOverView *view = [CustomPopOverView popOverView];
    view.style.containerBackgroudColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    view.style.containerBorderColor = [UIColor clearColor];
    view.style.shadowColor = [UIColor clearColor];
    view.style.isNeedAnimate = YES;
    view.content = lab;
    [view showFrom:self.navRightBtn alignStyle:CPAlignStyleRight relativePosition:CPContentPositionAutomaticUpFirst];
}

// 查伪验真
- (void)inspectionViewTap {
    
    NSLog(@"查伪验真");
    self.emailView.hidden = NO;
    [self.emailView.emailTF becomeFirstResponder];
    self.emailView.alpha = 0.0;
    [UIView animateWithDuration:emailViewDuration animations:^{
        self.emailView.alpha = 1.0;
    }];
}

// 复制提取码
- (void)extractButtonClicked {
    
    NSLog(@"复制提取码");
    if (self.dataModel.extractionCode.length > 0) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        pb.string = self.dataModel.extractionCode;
        [ZYProgressHUDTool showCustomHUDTextMessage:@"复制成功" toView:self.view];
    }else {
       
        [ZYProgressHUDTool showCustomHUDTextMessage:@"复制失败" toView:self.view];
    }
}

// 点击partView
- (void)partViewTap:(UITapGestureRecognizer *)tap {
    
    NSLog(@"点击partView %ld", tap.view.tag - 100);
    
    NSInteger index = tap.view.tag - 100;
    ZYProcessEvidenceDataListModel *model = self.dataArray[index];
    if (!model.data.isSelected) {
        model.data.isSelected = YES;
    }else {
        model.data.isSelected = NO;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

// 打电话
- (void)telButtonClicked:(UIButton *)sender {
    
    NSLog(@"打电话 %ld", sender.tag - 200);
    
    NSInteger index = sender.tag - 200;
    ZYProcessEvidenceDataListModel *model = self.dataArray[index];
    if (model.data.phone.length > 0) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            //设备系统为IOS 10.0或者以上的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", model.data.phone]] options:@{} completionHandler:nil];
        }else{
            //设备系统为IOS 10.0以下的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", model.data.phone]]];
        }
    }
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
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
        [self initDownloadContractData];
    }else {
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"您输入的邮箱格式不正确" toView:self.view];
    }
}

@end
