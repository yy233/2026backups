//
//  ZYMoulageHelperDetailEditVc.m
//  Community
//
//  Created by ZY on 2021/5/7.
//

#import "ZYMoulageHelperDetailEditVc.h"
#import <WebKit/WebKit.h>
#import "ZYMoulageHelperVc.h"
#import "ZYContrectUnderSigningDetailEditVc.h"
#import "ZYContractPdfPreviewVc.h"
#import "ZYMoulageHelperDetailChangedView.h"
#import "ZYMoulageHelperDetailChangedCell.h"
#import "ZYMoulageHelperDetailSignatureChangedCell.h"
#import "ZYMoulageHelperDetailModel.h"
#import "ZYZhangManagerModel.h"
#import "ZYContractTemplateUploadModel.h"
#import "ZYContractTemplateChangedUploadModel.h"

static NSString * const moulageHelperDetailChangedCellID = @"ZYMoulageHelperDetailChangedCell";
static NSString * const moulageHelperDetailSignatureChangedCellID = @"ZYMoulageHelperDetailSignatureChangedCell";
#define kMoulageHelperDetailChangedCellHeight 50
#define kMoulageHelperDetailSignatureChangedCellHeight 115

@interface ZYMoulageHelperDetailEditVc () <UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) WKWebViewConfiguration *webConfig;

@property (nonatomic, strong) ZYMoulageHelperDetailChangedView *moulageHelperDetailChangedView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 是否下拉
@property (nonatomic, assign) BOOL isDropDown;

@property (nonatomic, copy) NSString *templateName;

@end

@implementation ZYMoulageHelperDetailEditVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"模板编辑";
    [self rightBarButtonItemCustom];
    [self setUI];
    self.isDropDown = NO;
    [self webViewloadHTMLStr:self.htmlStr];
    [self customTableView];
    [self initData];
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBarStyleWithThemeColor];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
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

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {

    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [navRightBtn setTitle:@"预览" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[ZYThemeManager shareManager].navigationItemThemeColor forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}

// 预览
- (void)navRightBtnAction {
    
    NSLog(@"预览");
    ZYContractPdfPreviewVc *vc = [[ZYContractPdfPreviewVc alloc] init];
    vc.tempId = self.contractTemplatesDataListModel.uuid;
    vc.conName = self.contractTemplatesDataListModel.name;
    NSMutableArray *mDataArray = [NSMutableArray array];
    [mDataArray addObjectsFromArray:self.dataArray];
    [mDataArray addObjectsFromArray:self.noHandleContractArray];
    NSMutableArray *uploadArray = [NSMutableArray array];
    for (ZYMoulageHelperDetailtParamsModel *tempModel in mDataArray) {
        ZYContractTemplateUploadTempParamModel *model = [[ZYContractTemplateUploadTempParamModel alloc] init];
        model.tKey = tempModel.tKey;
        model.tName = tempModel.tName;
        model.tOrder = tempModel.tOrder;
        model.tType = tempModel.tType;
        model.tValue = tempModel.tValue;
        model.tUid = tempModel.tUid;
        model.tUserId = tempModel.tUserId;
        model.tValueRange = tempModel.tValueRange;
        model.tIsRequired = tempModel.tIsRequired;
        model.tRelyParam = tempModel.tRelyParam;
        model.tRelyCondition = tempModel.tRelyCondition;
        model.tEditableParty = tempModel.tEditableParty;
        [uploadArray addObject:model];
    }
    vc.paramArray = [uploadArray copy];
    [self pushVc:vc];
}

- (void)setUI {
    
    [self.view addSubview:self.moulageHelperDetailChangedView];
    [_moulageHelperDetailChangedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_moulageHelperDetailChangedView.superview);
        make.bottom.equalTo(_moulageHelperDetailChangedView.superview).offset(-button_bottom_height);
        make.height.offset(kScreenH - 44 - status_height - button_bottom_height);
    }];
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_webView.superview);
        make.bottom.equalTo(_moulageHelperDetailChangedView.mas_top);
    }];
}

#pragma mark - 懒加载
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.delegate = self;
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
    }
    
    return _webView;
}

- (WKWebViewConfiguration *)webConfig {
    if (!_webConfig) {
        _webConfig = [[WKWebViewConfiguration alloc] init];
    }
    
    return _webConfig;
}

- (ZYMoulageHelperDetailChangedView *)moulageHelperDetailChangedView {
    if (!_moulageHelperDetailChangedView) {
        _moulageHelperDetailChangedView = [[NSBundle mainBundle] loadNibNamed:@"ZYMoulageHelperDetailChangedView" owner:nil options:nil].lastObject;
        [_moulageHelperDetailChangedView.dropDownView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownViewTap)]];
        self.tableView = _moulageHelperDetailChangedView.tableView;
        [_moulageHelperDetailChangedView.nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_moulageHelperDetailChangedView.saveNewTemplateButton addTarget:self action:@selector(saveNewTemplateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_moulageHelperDetailChangedView.saveTemplateButton addTarget:self action:@selector(saveTemplateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self moulageHelperDetailChangedViewUISetting];
    }
    
    return _moulageHelperDetailChangedView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData {
    
    for (ZYMoulageHelperDetailtParamsModel *tempModel in self.contractArray) {
        ZYMoulageHelperDetailtParamsModel *model = [[ZYMoulageHelperDetailtParamsModel alloc] init];
        model = tempModel;
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

// 另存为新模板
- (void)initSaveNewTemplateData {
    
    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"保存中..."];
    NSMutableArray *mDataArray = [NSMutableArray array];
    [mDataArray addObjectsFromArray:self.dataArray];
    [mDataArray addObjectsFromArray:self.noHandleContractArray];
    NSMutableArray *uploadArray = [NSMutableArray array];
    for (ZYMoulageHelperDetailtParamsModel *tempModel in mDataArray) {
        ZYContractTemplateUploadTempParamModel *model = [[ZYContractTemplateUploadTempParamModel alloc] init];
        model.tUserId = tempModel.tUserId;
        model.tTempId = tempModel.tTempId;
        model.tUid = tempModel.tUid;
        model.tKey = tempModel.tKey;
        model.tName = tempModel.tName;
        model.tOrder = tempModel.tOrder;
        model.tType = tempModel.tType;
        model.tValue = tempModel.tValue;
        model.tValueRange = tempModel.tValueRange;
        model.tIsRequired = tempModel.tIsRequired;
        model.tRelyParam = tempModel.tRelyParam;
        model.tRelyCondition = tempModel.tRelyCondition;
        model.tEditableParty = tempModel.tEditableParty;
        [uploadArray addObject:model];
    }
    
    ZYContractTemplateUploadModel *uploadModel = [[ZYContractTemplateUploadModel alloc] init];
    uploadModel.belongTo = [ShareUserInfo sharedUserInfo].userInfo.uid;
    uploadModel.content = self.htmlStr;
    uploadModel.name = self.templateName;
    uploadModel.type = self.contractTemplatesDataListModel.type;
    uploadModel.signType = self.contractTemplatesDataListModel.signType;
    uploadModel.uploader = [ShareUserInfo sharedUserInfo].userInfo.uid;
    uploadModel.oldTempId = self.contractTemplatesDataListModel.uuid;
    uploadModel.tempParam = uploadArray;
    NSDictionary *parms = [uploadModel yy_modelToJSONObject];
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kSavePersonalTemplateUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {

                [self showAlertVC];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 编辑模板
- (void)initTemplateEditData {
    
    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"保存中..."];
    NSMutableArray *mDataArray = [NSMutableArray array];
    [mDataArray addObjectsFromArray:self.dataArray];
    [mDataArray addObjectsFromArray:self.noHandleContractArray];
    NSMutableArray *uploadArray = [NSMutableArray array];
    for (ZYMoulageHelperDetailtParamsModel *tempModel in mDataArray) {
        ZYContractTemplateUploadTempParamModel *model = [[ZYContractTemplateUploadTempParamModel alloc] init];
        model.tUserId = tempModel.tUserId;
        model.tTempId = tempModel.tTempId;
        model.tUid = tempModel.tUid;
        model.tKey = tempModel.tKey;
        model.tName = tempModel.tName;
        model.tOrder = tempModel.tOrder;
        model.tType = tempModel.tType;
        model.tValue = tempModel.tValue;
        model.tValueRange = tempModel.tValueRange;
        model.tIsRequired = tempModel.tIsRequired;
        model.tRelyParam = tempModel.tRelyParam;
        model.tRelyCondition = tempModel.tRelyCondition;
        model.tEditableParty = tempModel.tEditableParty;
        [uploadArray addObject:model];
    }
    ZYContractTemplateChangedUploadModel *changedUploadModel = [[ZYContractTemplateChangedUploadModel alloc] init];
    changedUploadModel.tempId = self.contractTemplatesDataListModel.uuid;
    changedUploadModel.paramsList = [uploadArray copy];
    NSArray *jsonArray = [changedUploadModel yy_modelToJSONObject];
    NSString *jsonStr = [jsonArray yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kUpdatePersonalTemplateParamsUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {

                [self showAlertVC];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 定制tabbleView
- (void)customTableView {
    
    // 防止tableView刷新漂移问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYMoulageHelperDetailChangedCell" bundle:nil] forCellReuseIdentifier:moulageHelperDetailChangedCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYMoulageHelperDetailSignatureChangedCell" bundle:nil] forCellReuseIdentifier:moulageHelperDetailSignatureChangedCellID];
}

#pragma mark - 加载webView
- (void)webViewloadHTMLStr:(NSString *)htmlStr {
    
    [self.webView loadHTMLString:htmlStr baseURL:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[self.webView.scrollView class]]) {
        //防止左右滚动
        CGPoint point = scrollView.contentOffset;
        scrollView.contentOffset = CGPointMake(0, point.y);
    }
}

#pragma mark - WKNavigationDelegate
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSLog(@"页面加载完成");
    // 通过js注入关闭webView缩放
    NSString*injectionJSString=@"var script = document.createElement('meta');"
                                                "script.name = 'viewport';"
                                                "script.content=\"width=device-width, user-scalable=no\";"
                                                "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    for (ZYMoulageHelperDetailtParamsModel *model in self.dataArray) {
        NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", model.tKey, model.tValue];
        [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
            
            NSLog(@"htmlStr:%@", htmlStr);
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYMoulageHelperDetailChangedCell *cell = [tableView dequeueReusableCellWithIdentifier:moulageHelperDetailChangedCellID forIndexPath:indexPath];
    tableView.bounces = YES;
    cell.contentTF.tag = 100 + indexPath.row;
    cell.contentTF.delegate = self;
    cell.contentLabel.tag = 1000 + indexPath.row;
    [cell.contentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentLabelTap:)]];
    cell.clearButton.tag = 1500 + indexPath.row;
    [cell.clearButton addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    ZYMoulageHelperDetailtParamsModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYMoulageHelperDetailtParamsModel *model = self.dataArray[indexPath.row];
    if ([model.tType isEqual:@"capital"]) {
        
        return 0;
    }
    
    return kMoulageHelperDetailChangedCellHeight;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    ZYMoulageHelperDetailtParamsModel *model = self.dataArray[textField.tag - 100];
    NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText=''", model.tKey];
    [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
        
        NSLog(@"htmlStr:%@", htmlStr);
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // 让cell中输入框失去第一响应
    [self.view endEditing:YES];
    
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    ZYMoulageHelperDetailtParamsModel *model = self.dataArray[textField.tag - 100];
    model.tValue = textField.text;
    [self handleCapitalWithParamsModel:model];
    // 有用户交互的输入框中，刷新tableView要用以下方法，为了避免输入框失去第一响应
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", model.tKey, textField.text];
    [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
        
        NSLog(@"htmlStr:%@", htmlStr);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    ZYMoulageHelperDetailtParamsModel *model = self.dataArray[textField.tag - 100];
    if ([model.tType isEqualToString:@"number"] || [model.tType isEqualToString:@"money"]) {
        
        return [ZYValidInputTextTool isValidAboutInputText:textField shouldChangeCharactersInRange:range replacementString:string decimalNumber:2];
    }else {
        
        return YES;
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
    NSLog(@"keyboardSizeHeight=%lf", keyboardSize.height);
    [_moulageHelperDetailChangedView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_moulageHelperDetailChangedView.superview).offset(-keyboardSize.height + 60);
        make.height.offset(kScreenH - 44 - status_height - keyboardSize.height + 60);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {

    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [_moulageHelperDetailChangedView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_moulageHelperDetailChangedView.superview).offset(-button_bottom_height);
        make.height.offset(kScreenH - 44 - status_height - button_bottom_height);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - 处理点击事件
// 下拉
- (void)dropDownViewTap {
    NSLog(@"下拉");
    
    // 让cell中输入框失去第一响应
    [self.view endEditing:YES];
    if (!self.isDropDown) {
        self.isDropDown = YES;
        self.moulageHelperDetailChangedView.dropDownImageView.image = [UIImage imageNamed:@"ic_up"];
        [_moulageHelperDetailChangedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_moulageHelperDetailChangedView.superview).with.offset(kScreenH - 44 - status_height - button_bottom_height - 40 - button_bottom_height);
        }];
        self.moulageHelperDetailChangedView.contractTopView.hidden = YES;
    }else {
        self.isDropDown = NO;
        self.moulageHelperDetailChangedView.dropDownImageView.image = [UIImage imageNamed:@"ic_xiala"];
        [_moulageHelperDetailChangedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_moulageHelperDetailChangedView.superview).offset(-button_bottom_height);
        }];
        self.moulageHelperDetailChangedView.contractTopView.hidden = NO;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 合同内容
- (void)contractContentViewTap {
    NSLog(@"合同内容");
    
    // 让cell中输入框失去第一响应
    [self.view endEditing:YES];
    [self moulageHelperDetailChangedViewUISetting];
    [self.tableView reloadData];
}

// 印章设置
- (void)signatureSettingViewTap {
    NSLog(@"印章设置");
    
    // 让cell中输入框失去第一响应
    [self.view endEditing:YES];
    [self moulageHelperDetailChangedViewUISetting];
    [self.tableView reloadData];
}

// 设置moulageHelperDetailChangedView的UI
- (void)moulageHelperDetailChangedViewUISetting {
    
    if (self.isSystemTemplate) {
        self.moulageHelperDetailChangedView.nextView.hidden = NO;
        self.moulageHelperDetailChangedView.saveView.hidden = YES;
        [self.moulageHelperDetailChangedView.nextButton setTitle:@"另存为新模板" forState:UIControlStateNormal];
    }else {
        self.moulageHelperDetailChangedView.nextView.hidden = YES;
        self.moulageHelperDetailChangedView.saveView.hidden = NO;
    }
}

// 下一步
- (void)nextButtonClicked {
    
    NSLog(@"另存为新模板");
    [self writeNewTemplateName];
}

// 个人模板新增
- (void)saveNewTemplateButtonClicked {
    
    NSLog(@"个人模板新增");
    [self writeNewTemplateName];
}

// 个人模板编辑
- (void)saveTemplateButtonClicked {
    
    NSLog(@"个人模板编辑");
    if (!self.isSystemTemplate) {
        [self initTemplateEditData];
    }
}

// 提示视图
- (void)showAlertVC {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"合同模板提示" message:@"\n是否使用该模板发起签约" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[ZYMoulageHelperVc class]]) {
                // 发送通知
                NSDictionary *dict = @{@"isSystemTemplate" : @(self.isSystemTemplate)};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TEMPLATE_EDIT_BACK" object:dict];
                [weakSelf.navigationController popToViewController:vc animated:YES];
            }
        }
    }];
    UIAlertAction *signAction = [UIAlertAction actionWithTitle:@"立即签约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf pushContrectUnderSigningDetailEditVC];
    }];
    [alertVC addAction:backAction];
    [alertVC addAction:signAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 填写新模板名称
- (void)writeNewTemplateName {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"新模板名称" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = weakSelf.contractTemplatesDataListModel.name;
        textField.placeholder = @"请输入新模板名称";
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *Action) {
        UITextField *textField = alertVC.textFields.firstObject;
        if (textField.text.length > 0) {
            weakSelf.templateName = textField.text;
            [weakSelf initSaveNewTemplateData];
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"新模板名称不能为空!" toView:self.view];
        }
    }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelButton];
    [alertVC addAction:okButton];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 跳转到在线签约详情编辑界面
- (void)pushContrectUnderSigningDetailEditVC {
    
    ZYContrectUnderSigningDetailEditVc *vc = [[ZYContrectUnderSigningDetailEditVc alloc] init];
    vc.uuid = self.contractTemplatesDataListModel.uuid;
    vc.isImmediatelySign = YES;
    vc.contractTemplatesDataListModel = self.contractTemplatesDataListModel;
    vc.origHtmlStr = self.htmlStr;
    vc.origContractArray = [self.contractArray copy];
    vc.isSystemTemplate = self.isSystemTemplate;
    [self pushVc:vc];
}

// 点击内容视图
- (void)contentLabelTap:(UITapGestureRecognizer *)tap {
    
    // 让cell中输入框失去第一响应
    [self.view endEditing:YES];
    
    ZYMoulageHelperDetailtParamsModel *model = self.dataArray[tap.view.tag - 1000];
    __weak typeof(self) weakSelf = self;
    if ([model.tType isEqualToString:@"time"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
        [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMD title:model.tName selectValue:dateStr resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            model.tValue = selectValue;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tap.view.tag - 1000 inSection:0];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            
            NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", model.tKey, selectValue];
            [weakSelf.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                
                NSLog(@"htmlStr:%@", htmlStr);
            }];
        }];
    }else if ([model.tType isEqualToString:@"option"]) {
        NSArray *array = [self stringToJSON:model.tValueRange];
        [BRStringPickerView showPickerWithTitle:model.tName dataSourceArr:array selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
            model.tValue = resultModel.value;
            [weakSelf handleOptionDataWithParamsModel:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tap.view.tag - 1000 inSection:0];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            
            for (ZYMoulageHelperDetailtParamsModel *model in self.dataArray) {
                NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", model.tKey, model.tValue];
                [weakSelf.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                    
                    NSLog(@"htmlStr:%@", htmlStr);
                }];
            }
        }];
    }
}

// 处理选项数据
- (void)handleOptionDataWithParamsModel:(ZYMoulageHelperDetailtParamsModel *)model {
    
    for (ZYMoulageHelperDetailtParamsModel *tempModel in self.dataArray) {
        if ([model.tKey isEqualToString:tempModel.tRelyParam]) {
            if (![model.tValue isEqualToString:tempModel.tRelyCondition]) {
                tempModel.tEditableParty = 1;
                tempModel.tValue = @"/";
            }else {
                tempModel.tEditableParty = 0;
                tempModel.tValue = @"";
            }
        }
    }
}

// 处理大写数据
- (void)handleCapitalWithParamsModel:(ZYMoulageHelperDetailtParamsModel *)model {
    
    for (ZYMoulageHelperDetailtParamsModel *tempModel in self.dataArray) {
        if ([model.tKey isEqualToString:tempModel.tRelyParam] && [tempModel.tType isEqualToString:@"capital"]) {
            tempModel.tValue = [ZYAmountCapitalTool getAmountInWords:model.tValue];
            NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", tempModel.tKey, tempModel.tValue];
            [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                
                NSLog(@"htmlStr:%@", htmlStr);
            }];
        }
    }
}

// json转数组
- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}

// 清除日期
- (void)clearButtonClicked:(UIButton *)sender {
    
    ZYMoulageHelperDetailtParamsModel *model = self.dataArray[sender.tag - 1500];
    model.tValue = @"";
    if ([model.tType isEqualToString:@"option"]) {
        for (ZYMoulageHelperDetailtParamsModel *tempModel in self.dataArray) {
            if ([model.tKey isEqualToString:tempModel.tRelyParam]) {
                tempModel.tEditableParty = 0;
                tempModel.tValue = @"";
            }
        }
        
        for (ZYMoulageHelperDetailtParamsModel *model in self.dataArray) {
            NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", model.tKey, model.tValue];
            [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                
                NSLog(@"htmlStr:%@", htmlStr);
            }];
        }
    }else {
        NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText=''", model.tKey];
        [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
            
            NSLog(@"htmlStr:%@", htmlStr);
        }];
    }
    [self.tableView reloadData];
}

@end
