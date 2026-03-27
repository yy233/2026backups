//
//  ZYContrectUnderSigningDetailEditVc.m
//  Community
//
//  Created by ZY on 2021/5/15.
//

#import "ZYContrectUnderSigningDetailEditVc.h"
#import <WebKit/WebKit.h>
#import "ZYMoulageHelperDetailVc.h"
#import "ZYMoulageHelperDetailEditVc.h"
#import "ZYContractingPartyInformationEditVc.h"
#import "ZYZhangDrawVC.h"
#import "ZYContractPdfPreviewVc.h"
#import "ZYContrectUnderSigningDetailEditBottomView.h"
#import "ZYMoulageHelperDetailChangedCell.h"
#import "ZYMoulageHelperDetailSignatureChangedCell.h"
//#import "ZYContrectUnderSigningDetailEditAttachmentUploadCell.h"
#import "ZYZhangManagerModel.h"
#import "ZYSealImageModel.h"
#import "ZYDraftUploadModel.h"
#import "ZYTemplateFillDataModel.h"

typedef enum : NSUInteger {
    Photo_mode_Type_Grapht,
    Photo_mode_Type_Album
} Photo_mode_Type;

static NSString * const moulageHelperDetailChangedCellID = @"ZYMoulageHelperDetailChangedCell";
static NSString * const moulageHelperDetailSignatureChangedCellID = @"ZYMoulageHelperDetailSignatureChangedCell";
//static NSString * const contrectUnderSigningDetailEditAttachmentUploadCellID = @"ZYContrectUnderSigningDetailEditAttachmentUploadCell";
#define kMoulageHelperDetailChangedCellHeight 50
#define kMoulageHelperDetailSignatureChangedCellHeight 115
//#define kContrectUnderSigningDetailEditAttachmentUploadCellHeight ((kScreenW - 80) / 3 + 50)

@interface ZYContrectUnderSigningDetailEditVc () <UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZYZhangDrawVCDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) WKWebViewConfiguration *webConfig;

@property (nonatomic, strong) ZYContrectUnderSigningDetailEditBottomView *contrectUnderSigningDetailEditBottomView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GKPhotoBrowser *browser;

@property (nonatomic, strong) NSMutableArray *contractArray;

@property (nonatomic, strong) ZYMoulageHelperDetailtParamsModel *signatureModel;

// 是否选中合同内容
@property (nonatomic, assign) BOOL isContractContentSelected;

// 是否选中印章设置
@property (nonatomic, assign) BOOL isSignatureSettingSelected;

// 是否选中附件上传
//@property (nonatomic, assign) BOOL isAttachmentUploadSelected;

// 是否下拉
@property (nonatomic, assign) BOOL isDropDown;

@property (nonatomic, copy) NSString *htmlStr;

@property (nonatomic, strong) ZYZhangManagerDataModel *currentSealModel;

@property (nonatomic, strong) NSMutableArray<ZYSealImageDataModel *> *imageArray;

// 当前选择图片
@property (nonatomic, strong) UIImage *currentImage;

//// 当前选中图片model
//@property (nonatomic, strong) ZYSealImageDataModel *selectedImageModel;

// 填充数据数组
@property (nonatomic, strong) NSMutableArray *fillDataArray;

@end

@implementation ZYContrectUnderSigningDetailEditVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"签约模板编辑";
    [self rightBarButtonItemCustom];
    [self setUI];
    self.isContractContentSelected = YES;
    self.isSignatureSettingSelected = NO;
//    self.isAttachmentUploadSelected = NO;
    self.isDropDown = NO;
    self.contrectUnderSigningDetailEditBottomView.hidden = YES;
    [self customTableView];
    [self registerForKeyboardNotifications];
    
    if (self.isImmediatelySign) {
        
        [self initImmediatelyData];
    }else {
        
        [self initData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBarStyleWithThemeColor];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isImmediatelySign) {
        NSMutableArray *vcArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[ZYMoulageHelperDetailVc class]]) {
                [vcArr removeObject:vc];
                break;
            }
        }
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[ZYMoulageHelperDetailEditVc class]]) {
                [vcArr removeObject:vc];
                break;
            }
        }
        self.navigationController.viewControllers = vcArr;
    }
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
    [mDataArray addObjectsFromArray:self.contractArray];
    [mDataArray addObject:self.signatureModel];
    NSMutableArray *uploadArray = [NSMutableArray array];
    for (ZYMoulageHelperDetailtParamsModel *tempModel in mDataArray) {
        ZYContractTemplateUploadTempParamModel *model = [[ZYContractTemplateUploadTempParamModel alloc] init];
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
    vc.paramArray = [uploadArray copy];
    [self pushVc:vc];
}

- (void)setUI {
    
    [self.view addSubview:self.contrectUnderSigningDetailEditBottomView];
    [_contrectUnderSigningDetailEditBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contrectUnderSigningDetailEditBottomView.superview);
        make.bottom.equalTo(_contrectUnderSigningDetailEditBottomView.superview).offset(-button_bottom_height);
        make.height.offset(kScreenH - 44 - status_height - button_bottom_height);
    }];
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_webView.superview);
        make.bottom.equalTo(_contrectUnderSigningDetailEditBottomView.mas_top);
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

- (ZYContrectUnderSigningDetailEditBottomView *)contrectUnderSigningDetailEditBottomView {
    if (!_contrectUnderSigningDetailEditBottomView) {
        _contrectUnderSigningDetailEditBottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYContrectUnderSigningDetailEditBottomView" owner:nil options:nil].lastObject;
        [_contrectUnderSigningDetailEditBottomView.dropDownView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownViewTap)]];
        [_contrectUnderSigningDetailEditBottomView.contractContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contractContentViewTap)]];
        [_contrectUnderSigningDetailEditBottomView.signatureSettingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signatureSettingViewTap)]];
//        [_contrectUnderSigningDetailEditBottomView.attachmentUploadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attachmentUploadViewTap)]];
        self.tableView = _contrectUnderSigningDetailEditBottomView.tableView;
        [_contrectUnderSigningDetailEditBottomView.nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _contrectUnderSigningDetailEditBottomView;
}

- (NSMutableArray *)contractArray {
    if (!_contractArray) {
        _contractArray = [NSMutableArray array];
    }
    
    return _contractArray;
}

- (ZYMoulageHelperDetailtParamsModel *)signatureModel {
    if (!_signatureModel) {
        _signatureModel = [[ZYMoulageHelperDetailtParamsModel alloc] init];
    }
    
    return _signatureModel;
}

- (ZYZhangManagerDataModel *)currentSealModel {
    if (!_currentSealModel) {
        _currentSealModel = [[ZYZhangManagerDataModel alloc] init];
    }
    
    return _currentSealModel;
}

- (NSMutableArray<ZYSealImageDataModel *> *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    
    return _imageArray;
}

- (UIImage *)currentImage {
    if (!_currentImage) {
        _currentImage = [[UIImage alloc] init];
    }
    
    return _currentImage;
}

//- (ZYSealImageDataModel *)selectedImageModel {
//    if (!_selectedImageModel) {
//        _selectedImageModel = [[ZYSealImageDataModel alloc] init];
//    }
//
//    return _selectedImageModel;
//}

- (NSMutableArray *)fillDataArray {
    if (!_fillDataArray) {
        _fillDataArray = [NSMutableArray array];
    }
    
    return _fillDataArray;
}

#pragma mark - 加载数据
- (void)initData {
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    NSDictionary *parms = @{@"tempId" : self.uuid, @"uuid" : [ShareUserInfo sharedUserInfo].userInfo.uid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    NSString *urlStr;
    if (self.isDraft || self.isSystemTemplate) {
        urlStr = kDraftTemplateDetailUrl;
    }else {
        urlStr = kContractTemplateDetailUrl;
    }
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:urlStr withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.contractArray.count > 0) {
                    [self.contractArray removeAllObjects];
                }
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                ZYMoulageHelperDetailModel *model = [ZYMoulageHelperDetailModel yy_modelWithJSON:jsonStr];
                if (isNotNil(model)) {
                    self.contrectUnderSigningDetailEditBottomView.hidden = NO;
                    [self webViewloadHTMLStr:model.content];
                }else {
                    self.contrectUnderSigningDetailEditBottomView.hidden = YES;
                }
                NSArray *array = model.tParams;
                for (ZYMoulageHelperDetailtParamsModel *tempModel in array) {
                    if ([tempModel.tKey isEqualToString:@"signA"]) {
                        self.signatureModel = tempModel;
                        self.signatureModel.tValue = @"";
                    }
                    if ([tempModel.tKey isEqualToString:@"signA"] || [tempModel.tKey isEqualToString:@"signB"] || [tempModel.tKey isEqualToString:@"signingDateA"] || [tempModel.tKey isEqualToString:@"signingDateB"] || [tempModel.tKey isEqualToString:@"contractNo"]) {
                        continue;
                    }
                    [self.contractArray addObject:tempModel];
                }
                [self.tableView reloadData];
                NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').src='%@'", self.signatureModel.tKey, [NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, self.currentSealModel.sealUrl]];
                [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                    NSLog(@"htmlStr:%@", htmlStr);
                }];
                
                // 处理租赁合同填充数据
                [self handleRentContract];
            }else {
              
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
           
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载存储草稿数据
- (void)initSaveDraftDataWithModel:(ZYDraftUploadModel *)model {
    NSDictionary *params = @{@"userId" : model.userId, @"tempId" : model.tempId, @"paramId" : model.paramId, @"value" :model.value, @"editableParty" : @(model.editableParty)};
    NSString *jsonStr = [params yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kSaveTemplateDraftUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSLog(@"草稿数据保存成功");
            }else {
                NSLog(@"草稿数据保存失败");
            }
        }else {
            NSLog(@"草稿数据保存失败");
        }
    }];
}

// 处理填充数据
- (void)handleFillData {
    [self.fillDataArray enumerateObjectsUsingBlock:^(ZYTemplateFillDataModel *fillModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contractArray enumerateObjectsUsingBlock:^(ZYMoulageHelperDetailtParamsModel *paramsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([paramsModel.tKey isEqual:fillModel.key]) {
                paramsModel.tValue = fillModel.value;
            }
        }];
    }];
    [self.contractArray enumerateObjectsUsingBlock:^(ZYMoulageHelperDetailtParamsModel *paramsModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([paramsModel.tType isEqual:@"option"]) {
            for (ZYMoulageHelperDetailtParamsModel *tempModel in self.contractArray) {
                if ([paramsModel.tKey isEqualToString:tempModel.tRelyParam]) {
                    if (![paramsModel.tValue isEqualToString:tempModel.tRelyCondition]) {
                        tempModel.tEditableParty = 1;
                        tempModel.tValue = @"/";
                    }else {
                        tempModel.tEditableParty = 0;
                    }
                }
            }
        }
    }];
    for (ZYMoulageHelperDetailtParamsModel *model in self.contractArray) {
        NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", model.tKey, model.tValue];
        [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {

            NSLog(@"htmlStr:%@", htmlStr);
        }];
    }
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
//    [self.tableView registerNib:[UINib nibWithNibName:@"ZYContrectUnderSigningDetailEditAttachmentUploadCell" bundle:nil] forCellReuseIdentifier:contrectUnderSigningDetailEditAttachmentUploadCellID];
}

#pragma mark - 加载webView
- (void)webViewloadHTMLStr:(NSString *)htmlStr {
    
//    NSString *handleHTMLStr = [self handleHTML:htmlStr];
//    self.htmlStr = handleHTMLStr;
//    [self.webView loadHTMLString:handleHTMLStr baseURL:nil];
    
    self.htmlStr = htmlStr;
    [self.webView loadHTMLString:htmlStr baseURL:nil];
}

#pragma mark - 处理html数据
- (NSString *)handleHTML:(NSString *)htmlStr {
    
    if (isNil(htmlStr)) {
        return @"";
    }
    NSMutableString *mStr = [NSMutableString stringWithString:[self filterHTML:htmlStr]];
    NSMutableArray *mArray = [NSMutableArray array];
    while (1) {
        NSRange startRange = [mStr rangeOfString:@"$"];
        NSRange endRange = [mStr rangeOfString:@"}"];
        if (startRange.location == NSNotFound) {
            break;
        }
        NSRange subRange = NSMakeRange(startRange.location, endRange.location - startRange.location + 1);
        NSString *subStr = [mStr substringWithRange:subRange];
        [mStr deleteCharactersInRange:subRange];
        [mArray addObject:subStr];
    }
    NSMutableString *htmlmStr = [NSMutableString stringWithString:htmlStr];
    for (int i = 0; i < mArray.count; i++) {
        NSRange range = [htmlmStr rangeOfString:mArray[i]];
        [htmlmStr deleteCharactersInRange:range];
    }
    
    return [htmlmStr copy];
}

// 获取HTML标签中的信息
- (NSString *)filterHTML:(NSString *)htmlStr {
    
    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSData *data = [htmlStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attriStr = [[NSAttributedString alloc] initWithData:data options:dic documentAttributes:nil error:nil];
    NSString *str = attriStr.string;
    
    return str;
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
    
    [SVProgressHUD dismiss];
    self.contrectUnderSigningDetailEditBottomView.hidden = NO;
    
    NSLog(@"页面加载完成");
    // 通过js注入关闭webView缩放
    NSString*injectionJSString=@"var script = document.createElement('meta');"
                                                "script.name = 'viewport';"
                                                "script.content=\"width=device-width, user-scalable=no\";"
                                                "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    for (ZYMoulageHelperDetailtParamsModel *model in self.contractArray) {
        NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", model.tKey, model.tValue];
        [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {

            NSLog(@"htmlStr:%@", htmlStr);
        }];
    }
}

- (void)initImmediatelyData {
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    self.htmlStr = self.origHtmlStr;
    [self.webView loadHTMLString:self.htmlStr baseURL:nil];
    [self.contractArray addObjectsFromArray:self.origContractArray];
    [self.tableView reloadData];
}

// 系统印章数据
- (void)initSystemSealData {
    
    NSDictionary *parms = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kSystemSealUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                self.currentSealModel = [ZYZhangManagerDataModel yy_modelWithJSON:jsonStr];
                NSDictionary *dict = @{@"url" : self.currentSealModel.sealUrl, @"uuid" : self.currentSealModel.uuid};
                NSString *sealJsonStr = [dict yy_modelToJSONString];
                self.signatureModel.tValue = sealJsonStr;
                [self.tableView reloadData];
                NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').src='%@'", self.signatureModel.tKey, [NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, self.currentSealModel.sealUrl]];
                [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                    NSLog(@"htmlStr:%@", htmlStr);
                }];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 个人印章数据
- (void)initPersonSealData {
    
    NSDictionary *parms = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kGetPersonalSealUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                self.currentSealModel = [ZYZhangManagerDataModel yy_modelWithJSON:jsonStr];
                NSDictionary *dict = @{@"url" : self.currentSealModel.sealUrl, @"uuid" : self.currentSealModel.uuid};
                NSString *sealJsonStr = [dict yy_modelToJSONString];
                self.signatureModel.tValue = sealJsonStr;
                [self.tableView reloadData];
                NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').src='%@'", self.signatureModel.tKey, [NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, self.currentSealModel.sealUrl]];
                [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                    NSLog(@"htmlStr:%@", htmlStr);
                }];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

//// 附件图片上传
//- (void)initFileImageUploadData {
//    NSDictionary *parms = @{@"description" : @"图片附件"};
//    NSMutableArray *mArray = [NSMutableArray arrayWithObject:self.currentImage];
//    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignature100KBImgFilesWithURL:kFileUploadUrl withParams:parms.mutableCopy fileDataArr:mArray fileNameStr:@"" finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
//        Y_SVP_DISMISS
//        if (isNotNil(responsObject)) {
//            if (Y_IS_Success) {
//
//                if (self.imageArray.count > 0) {
//                    [self.imageArray removeAllObjects];
//                }
//
//                ZYSealImageModel *model = [ZYSealImageModel yy_modelWithJSON:responsObject];
//                [self.imageArray addObject:model.data];
////                if (self.imageArray.count > 2) {
////                    [self->_contrectUnderSigningDetailEditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
////                        make.height.offset(120 + kContrectUnderSigningDetailEditAttachmentUploadCellHeight * 2);
////                    }];
////                }else {
////                    [self->_contrectUnderSigningDetailEditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
////                        make.height.offset(150 + kContrectUnderSigningDetailEditAttachmentUploadCellHeight);
////                    }];
////                }
//                [self.view layoutIfNeeded];
//                [self.tableView reloadData];
//            }else {
//
//                Y_SVP_SHOW_ERR_MESSAGE
//            }
//        }else {
//
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//    }];
//}
//
//// 图片附件删除
//- (void)initFileImageDeleteData {
//    NSDictionary *parms = @{@"uuid" : self.selectedImageModel.uuid};
//    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestGetURL:kFileDeleteUrl withParams:parms.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
//        Y_SVP_DISMISS
//        if (isNotNil(responsObject)) {
//            if (Y_IS_Success) {
//                [self.imageArray removeObject:self.selectedImageModel];
//                [self.tableView reloadData];
//            }else {
//                Y_SVP_SHOW_ERR_MESSAGE
//            }
//        }else {
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//    }];
//}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isContractContentSelected) {
        
        return self.contractArray.count;
    }else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isContractContentSelected) {
        ZYMoulageHelperDetailChangedCell *cell = [tableView dequeueReusableCellWithIdentifier:moulageHelperDetailChangedCellID forIndexPath:indexPath];
        tableView.bounces = YES;
        cell.contentTF.tag = 100 + indexPath.row;
        cell.contentTF.delegate = self;
        cell.contentLabel.tag = 1000 + indexPath.row;
        [cell.contentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentLabelTap:)]];
        cell.clearButton.tag = 1500 + indexPath.row;
        [cell.clearButton addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        ZYMoulageHelperDetailtParamsModel *model = self.contractArray[indexPath.row];
        cell.model = model;
        
        return cell;
    }
    if (self.isSignatureSettingSelected) {
        ZYMoulageHelperDetailSignatureChangedCell *cell = [tableView dequeueReusableCellWithIdentifier:moulageHelperDetailSignatureChangedCellID forIndexPath:indexPath];
        tableView.bounces = NO;
        [cell.signatureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signatureViewTap)]];
        cell.model = self.currentSealModel;
        
        return cell;
    }
//    if (self.isAttachmentUploadSelected) {
//        ZYContrectUnderSigningDetailEditAttachmentUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:contrectUnderSigningDetailEditAttachmentUploadCellID forIndexPath:indexPath];
//        tableView.bounces = NO;
//        cell.delegate = self;
//        cell.imageArray = self.imageArray;
//
//        return cell;
//    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isContractContentSelected) {
        
        ZYMoulageHelperDetailtParamsModel *model = self.contractArray[indexPath.row];
        if ([model.tType isEqual:@"capital"]) {
            
            return 0;
        }
        
        return kMoulageHelperDetailChangedCellHeight;
    }
    if (self.isSignatureSettingSelected) {
        
        return kMoulageHelperDetailSignatureChangedCellHeight;
    }
//    if (self.isAttachmentUploadSelected) {
//
////        if (self.imageArray.count > 2) {
////
////            return kContrectUnderSigningDetailEditAttachmentUploadCellHeight * 2 - 30;
////        }else {
////
////            return kContrectUnderSigningDetailEditAttachmentUploadCellHeight;
////        }
//        return kContrectUnderSigningDetailEditAttachmentUploadCellHeight;
//    }
    
    return 0;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    ZYMoulageHelperDetailtParamsModel *model = self.contractArray[textField.tag - 100];
    model.tValue = @"";
    NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText=''", model.tKey];
    [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
        
        NSLog(@"htmlStr:%@", htmlStr);
    }];
    // 处理大写数据
    [self handleCapitalWithParamsModel:model];
    // 保存草稿数据
    [self saveDraftDataWithParamsModel:model];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // 让cell中输入框失去第一响应
    [self.view endEditing:YES];
    
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    ZYMoulageHelperDetailtParamsModel *model = self.contractArray[textField.tag - 100];
    model.tValue = textField.text;
    // 处理大写数据
    [self handleCapitalWithParamsModel:model];
    // 有用户交互的输入框中，刷新tableView要用以下方法，为了避免输入框失去第一响应
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", model.tKey, textField.text];
    [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
        
        NSLog(@"htmlStr:%@", htmlStr);
    }];
    
    // 保存草稿数据
    [self saveDraftDataWithParamsModel:model];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    ZYMoulageHelperDetailtParamsModel *model = self.contractArray[textField.tag - 100];
    if ([model.tType isEqualToString:@"number"] || [model.tType isEqualToString:@"money"]) {
        
        return [ZYValidInputTextTool isValidAboutInputText:textField shouldChangeCharactersInRange:range replacementString:string decimalNumber:2];
    }else {
        
        return YES;
    }
}

//#pragma mark - UIImagePickerControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//
//    UIImage *photo = info[UIImagePickerControllerOriginalImage];
//    self.currentImage = photo;
//    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"上传中..."];
//    [self initFileImageUploadData];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//#pragma mark - ZYContrectUnderSigningDetailEditAttachmentUploadCellDelegate
//- (void)contrectUnderSigningDetailEditAttachmentUploadCellSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    NSLog(@"%ld", indexPath.row);
//    if (self.imageArray.count == indexPath.row) {
//        [self imageSelectedAlertVC];
//    }else {
//        NSMutableArray *photos = [NSMutableArray array];
//        for (ZYSealImageDataModel *model in self.imageArray) {
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, model.url]];
//            GKPhoto *photoModel = [[GKPhoto alloc] init];
//            photoModel.url = url;
//            photoModel.originUrl = url;
//            [photos addObject:photoModel];
//        }
//        self.browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:indexPath.row];
//        self.browser.showStyle = GKPhotoBrowserShowStyleNone;
//        [self.browser showFromVC:self];
//    }
//}

//- (void)deleteButtonSelectedIndex:(NSInteger)index {
//
//    NSLog(@"%ld", index);
//    self.selectedImageModel = self.imageArray[index];
//    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"删除中..."];
//    [self initFileImageDeleteData];
//}

//// 图片选择AlertVC
//- (void)imageSelectedAlertVC {
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    __weak typeof(self) weakSelf = self;
//    UIAlertAction *photographAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //图片拍照
//        [weakSelf chooseImageWithType:Photo_mode_Type_Grapht];
//    }];
//    UIAlertAction *photoalbumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //图片相册选择
//        [weakSelf chooseImageWithType:Photo_mode_Type_Album];
//    }];
//    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alertVC addAction:photographAction];
//    [alertVC addAction:photoalbumAction];
//    [alertVC addAction:cancleAction];
//    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:alertVC animated:YES completion:nil];
//}

//// 图片选择
//- (void)chooseImageWithType:(Photo_mode_Type)type {
//
//    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
//    pickVC.delegate = self;
//    if (type == Photo_mode_Type_Grapht) {
//
//        pickVC.allowsEditing = NO;
//        pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }else {
//
//        pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    }
//    pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:pickVC animated:YES completion:nil];
//}

#pragma mark - ZYZhangDrawVCDelegate
- (void)zhangDrawWithModel:(ZYZhangManagerDataModel *)model {
    self.currentSealModel = model;
    NSDictionary *dict = @{@"url" : model.sealUrl, @"uuid" : model.uuid};
    NSString *sealJsonStr = [dict yy_modelToJSONString];
    self.signatureModel.tValue = sealJsonStr;
    [self.tableView reloadData];
    NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').src='%@'", self.signatureModel.tKey, [NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, self.currentSealModel.sealUrl]];
    [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
        NSLog(@"htmlStr:%@", htmlStr);
    }];
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
    [_contrectUnderSigningDetailEditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.isContractContentSelected) {
            make.bottom.equalTo(_contrectUnderSigningDetailEditBottomView.superview).offset(-keyboardSize.height + 60);
            make.height.offset(kScreenH - 44 - status_height - keyboardSize.height + 60);
        }
    }];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {

    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [_contrectUnderSigningDetailEditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.isContractContentSelected) {
            make.bottom.equalTo(_contrectUnderSigningDetailEditBottomView.superview).offset(-button_bottom_height);
            make.height.offset(kScreenH - 44 - status_height - button_bottom_height);
        }
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
        self.contrectUnderSigningDetailEditBottomView.dropDownImageView.image = [UIImage imageNamed:@"ic_up"];
        [_contrectUnderSigningDetailEditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//            if (self.isAttachmentUploadSelected) {
////                if (self.imageArray.count > 2) {
////                    make.bottom.equalTo(_contrectUnderSigningDetailEditBottomView.superview).with.offset(60 + kContrectUnderSigningDetailEditAttachmentUploadCellHeight * 2);
////                }else {
////                    make.bottom.equalTo(_contrectUnderSigningDetailEditBottomView.superview).with.offset(110 + kContrectUnderSigningDetailEditAttachmentUploadCellHeight);
////                }
//                make.bottom.equalTo(_contrectUnderSigningDetailEditBottomView.superview).with.offset(110 + kContrectUnderSigningDetailEditAttachmentUploadCellHeight);
//            }else {
//                make.bottom.equalTo(_contrectUnderSigningDetailEditBottomView.superview).with.offset(225);
//            }
            
            make.bottom.equalTo(_contrectUnderSigningDetailEditBottomView.superview).with.offset(kScreenH - 44 - status_height - button_bottom_height - 40 - button_bottom_height);
        }];
        self.contrectUnderSigningDetailEditBottomView.contractTopView.hidden = YES;
    }else {
        self.isDropDown = NO;
        self.contrectUnderSigningDetailEditBottomView.dropDownImageView.image = [UIImage imageNamed:@"ic_xiala"];
        [_contrectUnderSigningDetailEditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_contrectUnderSigningDetailEditBottomView.superview).offset(-button_bottom_height);
        }];
        self.contrectUnderSigningDetailEditBottomView.contractTopView.hidden = NO;
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
    self.isContractContentSelected = YES;
    self.isSignatureSettingSelected = NO;
//    self.isAttachmentUploadSelected = NO;
    [self moulageHelperDetailChangedViewUISetting];
    [self.tableView reloadData];
}

// 印章设置
- (void)signatureSettingViewTap {
    NSLog(@"印章设置");
    
    // 让cell中输入框失去第一响应
    [self.view endEditing:YES];
    if ([self isContractContentNoEmptyPrompt]) {
        self.isContractContentSelected = NO;
        self.isSignatureSettingSelected = YES;
//        self.isAttachmentUploadSelected = NO;
        [self moulageHelperDetailChangedViewUISetting];
        [self.tableView reloadData];
    }
}

//// 附件上传
//- (void)attachmentUploadViewTap {
//
//    // 让cell中输入框失去第一响应
//    [self.view endEditing:YES];
//    if ([self issignatureContentNoEmptyPrompt]) {
//        self.isContractContentSelected = NO;
//        self.isSignatureSettingSelected = NO;
//        self.isAttachmentUploadSelected = YES;
//        [self moulageHelperDetailChangedViewUISetting];
//        [self.tableView reloadData];
//    }
//}

// 设置moulageHelperDetailChangedView的UI
- (void)moulageHelperDetailChangedViewUISetting {
    
    if (self.isContractContentSelected) {
        self.contrectUnderSigningDetailEditBottomView.contractContentLabel.textColor = Y_RGBA(57, 69, 107, 1);
        self.contrectUnderSigningDetailEditBottomView.contractContentLabel.font = [UIFont boldSystemFontOfSize:17];
        self.contrectUnderSigningDetailEditBottomView.contractContentLineView.backgroundColor = Y_RGBA(38, 114, 249, 1);
        
        self.contrectUnderSigningDetailEditBottomView.signatureSettingLabel.textColor = Y_RGBA(102, 102, 102, 1);
        self.contrectUnderSigningDetailEditBottomView.signatureSettingLabel.font = [UIFont systemFontOfSize:17];
        self.contrectUnderSigningDetailEditBottomView.signatureSettingLineView.backgroundColor = [UIColor whiteColor];
        
        self.contrectUnderSigningDetailEditBottomView.attachmentUploadLabel.textColor = Y_RGBA(102, 102, 102, 1);
        self.contrectUnderSigningDetailEditBottomView.attachmentUploadLabel.font = [UIFont systemFontOfSize:17];
        self.contrectUnderSigningDetailEditBottomView.attachmentUploadLineView.backgroundColor = [UIColor whiteColor];
        
        [_contrectUnderSigningDetailEditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(kScreenH - 44 - status_height - button_bottom_height);
        }];
        [self.view layoutIfNeeded];
    }
    if (self.isSignatureSettingSelected){
        self.contrectUnderSigningDetailEditBottomView.contractContentLabel.textColor = Y_RGBA(102, 102, 102, 1);
        self.contrectUnderSigningDetailEditBottomView.contractContentLabel.font = [UIFont systemFontOfSize:17];
        self.contrectUnderSigningDetailEditBottomView.contractContentLineView.backgroundColor = [UIColor whiteColor];
        
        self.contrectUnderSigningDetailEditBottomView.signatureSettingLabel.textColor = Y_RGBA(57, 69, 107, 1);
        self.contrectUnderSigningDetailEditBottomView.signatureSettingLabel.font = [UIFont boldSystemFontOfSize:17];
        self.contrectUnderSigningDetailEditBottomView.signatureSettingLineView.backgroundColor = Y_RGBA(38, 114, 249, 1);
        
        self.contrectUnderSigningDetailEditBottomView.attachmentUploadLabel.textColor = Y_RGBA(102, 102, 102, 1);
        self.contrectUnderSigningDetailEditBottomView.attachmentUploadLabel.font = [UIFont systemFontOfSize:17];
        self.contrectUnderSigningDetailEditBottomView.attachmentUploadLineView.backgroundColor = [UIColor whiteColor];
        
        [_contrectUnderSigningDetailEditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(kScreenH - 44 - status_height - button_bottom_height);
        }];
        [self.view layoutIfNeeded];
    }
//    if (self.isAttachmentUploadSelected) {
//        self.contrectUnderSigningDetailEditBottomView.contractContentLabel.textColor = Y_RGBA(102, 102, 102, 1);
//        self.contrectUnderSigningDetailEditBottomView.contractContentLabel.font = [UIFont systemFontOfSize:17];
//        self.contrectUnderSigningDetailEditBottomView.contractContentLineView.backgroundColor = [UIColor whiteColor];
//
//        self.contrectUnderSigningDetailEditBottomView.signatureSettingLabel.textColor = Y_RGBA(102, 102, 102, 1);
//        self.contrectUnderSigningDetailEditBottomView.signatureSettingLabel.font = [UIFont systemFontOfSize:17];
//        self.contrectUnderSigningDetailEditBottomView.signatureSettingLineView.backgroundColor = [UIColor whiteColor];
//
//        self.contrectUnderSigningDetailEditBottomView.attachmentUploadLabel.textColor = Y_RGBA(57, 69, 107, 1);
//        self.contrectUnderSigningDetailEditBottomView.attachmentUploadLabel.font = [UIFont boldSystemFontOfSize:17];
//        self.contrectUnderSigningDetailEditBottomView.attachmentUploadLineView.backgroundColor = Y_RGBA(57, 69, 107, 1);
//
//        [_contrectUnderSigningDetailEditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.offset(150 + kContrectUnderSigningDetailEditAttachmentUploadCellHeight);
//        }];
//        [self.view layoutIfNeeded];
//    }
    [self.view reloadInputViews];
}

// 下一步
- (void)nextButtonClicked {
    
//    // 让cell中输入框失去第一响应
//    [self.view endEditing:YES];
//    if (self.isContractContentSelected) {
//
//        if ([self isContractContentNoEmptyPrompt]) {
//            self.isContractContentSelected = NO;
//            self.isSignatureSettingSelected = YES;
//            self.isAttachmentUploadSelected = NO;
//            [self moulageHelperDetailChangedViewUISetting];
//            [self.tableView reloadData];
//        }
//    }else if (self.isSignatureSettingSelected) {
//
//        if ([self issignatureContentNoEmptyPrompt]) {
//            self.isContractContentSelected = NO;
//            self.isSignatureSettingSelected = NO;
//            self.isAttachmentUploadSelected = YES;
//            [self moulageHelperDetailChangedViewUISetting];
//            [self.tableView reloadData];
//        }
//    }else {
//        NSLog(@"发起签约");
//
//        ZYContractingPartyInformationEditVc *vc = [[ZYContractingPartyInformationEditVc alloc] init];
//        vc.contractTemplatesDataListModel = self.contractTemplatesDataListModel;
//        vc.htmlStr = self.htmlStr;
//        NSMutableArray *mDataArray = [NSMutableArray array];
//        [mDataArray addObjectsFromArray:self.contractArray];
//        [mDataArray addObject:self.signatureModel];
//        NSMutableArray *uploadArray = [NSMutableArray array];
//        for (ZYMoulageHelperDetailtParamsModel *tempModel in mDataArray) {
//            ZYContractTemplateUploadTempParamModel *model = [[ZYContractTemplateUploadTempParamModel alloc] init];
//            model.tKey = tempModel.tKey;
//            model.tName = tempModel.tName;
//            model.tOrder = tempModel.tOrder;
//            model.tType = tempModel.tType;
//            model.tValue = tempModel.tValue;
//            model.tValueRange = tempModel.tValueRange;
//            model.tIsRequired = tempModel.tIsRequired;
//            model.tRelyParam = tempModel.tRelyParam;
//            model.tRelyCondition = tempModel.tRelyCondition;
//            model.tEditableParty = tempModel.tEditableParty;
//            [uploadArray addObject:model];
//        }
//        vc.contractParams = [uploadArray copy];
//        ZYSealImageDataModel *sealImageDataModel = [self.imageArray firstObject];
//        vc.sealImageDataModel = sealImageDataModel;
//        [self pushVc:vc];
//    }
    
    // 让cell中输入框失去第一响应
    [self.view endEditing:YES];
    if (self.isContractContentSelected) {
        
        if ([self isContractContentNoEmptyPrompt]) {
            self.isContractContentSelected = NO;
            self.isSignatureSettingSelected = YES;
            [self moulageHelperDetailChangedViewUISetting];
            [self.tableView reloadData];
        }
    }else {

        if ([self issignatureContentNoEmptyPrompt]) {
            NSLog(@"发起签约");
            ZYContractingPartyInformationEditVc *vc = [[ZYContractingPartyInformationEditVc alloc] init];
            vc.contractTemplatesDataListModel = self.contractTemplatesDataListModel;
            vc.htmlStr = self.htmlStr;
            NSMutableArray *mDataArray = [NSMutableArray array];
            [mDataArray addObjectsFromArray:self.contractArray];
            [mDataArray addObject:self.signatureModel];
            NSMutableArray *uploadArray = [NSMutableArray array];
            for (ZYMoulageHelperDetailtParamsModel *tempModel in mDataArray) {
                ZYContractTemplateUploadTempParamModel *model = [[ZYContractTemplateUploadTempParamModel alloc] init];
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
            vc.contractParams = [uploadArray copy];
            ZYSealImageDataModel *sealImageDataModel = [self.imageArray firstObject];
            vc.sealImageDataModel = sealImageDataModel;
            vc.rentSignInfoModel = self.rentSignInfoModel;
            [self pushVc:vc];
        }
    }
}

// 提示合同内容不能为空
- (BOOL)isContractContentNoEmptyPrompt {
    for (ZYMoulageHelperDetailtParamsModel *model in self.contractArray) {
        if (!(model.tValue.length > 0)) {
            [ZYProgressHUDTool showCustomHUDTextMessage:[NSString stringWithFormat:@"%@不能为空!", model.tName] toView:self.view];
            
            return NO;
        }
    }
    
    return YES;
}

// 提示印章不能为空
- (BOOL)issignatureContentNoEmptyPrompt {
    if (!(self.signatureModel.tValue.length > 0)) {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"发起方印章不能为空!" toView:self.view];
        
        return NO;
    }
    
    return YES;
}

// 点击内容视图
- (void)contentLabelTap:(UITapGestureRecognizer *)tap {
    
    // 让cell中输入框失去第一响应
    [self.view endEditing:YES];
    
    ZYMoulageHelperDetailtParamsModel *model = self.contractArray[tap.view.tag - 1000];
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
            
            // 保存草稿数据
            [self saveDraftDataWithParamsModel:model];
        }];
    }else if ([model.tType isEqualToString:@"option"]) {
        NSArray *array = [self stringToJSON:model.tValueRange];
        [BRStringPickerView showPickerWithTitle:model.tName dataSourceArr:array selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
            model.tValue = resultModel.value;
            [weakSelf handleOptionDataWithParamsModel:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tap.view.tag - 1000 inSection:0];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            
            // 保存草稿数据
            [weakSelf saveDraftDataWithParamsModel:model];
        }];
    }
}

// 处理选项数据
- (void)handleOptionDataWithParamsModel:(ZYMoulageHelperDetailtParamsModel *)model {
    
    for (ZYMoulageHelperDetailtParamsModel *tempModel in self.contractArray) {
        if ([model.tKey isEqualToString:tempModel.tRelyParam]) {
            if (![model.tValue isEqualToString:tempModel.tRelyCondition]) {
                tempModel.tEditableParty = 1;
                tempModel.tValue = @"/";
            }else {
                tempModel.tEditableParty = 0;
                tempModel.tValue = @"";
            }
            
            // 保存草稿数据
            [self saveDraftDataWithParamsModel:tempModel];
        }
    }
    
    for (ZYMoulageHelperDetailtParamsModel *model in self.contractArray) {
        NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", model.tKey, model.tValue];
        [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
            
            NSLog(@"htmlStr:%@", htmlStr);
        }];
    }
}

// 处理大写数据
- (void)handleCapitalWithParamsModel:(ZYMoulageHelperDetailtParamsModel *)model {
    
    for (ZYMoulageHelperDetailtParamsModel *tempModel in self.contractArray) {
        if ([model.tKey isEqualToString:tempModel.tRelyParam] && [tempModel.tType isEqualToString:@"capital"]) {
            tempModel.tValue = [ZYAmountCapitalTool getAmountInWords:model.tValue];
            NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", tempModel.tKey, tempModel.tValue];
            [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                
                NSLog(@"htmlStr:%@", htmlStr);
            }];
            
            // 保存草稿数据
            [self saveDraftDataWithParamsModel:tempModel];
        }
    }
}

// 保存草稿数据
- (void)saveDraftDataWithParamsModel:(ZYMoulageHelperDetailtParamsModel *)model {
    // 保存草稿数据
    ZYDraftUploadModel *draftUploadModel = [[ZYDraftUploadModel alloc] init];
    draftUploadModel.userId = [ShareUserInfo sharedUserInfo].userInfo.uid;
    draftUploadModel.tempId = self.contractTemplatesDataListModel.uuid;
    draftUploadModel.paramId = model.tUid;
    draftUploadModel.value = model.tValue;
    draftUploadModel.editableParty = model.tEditableParty;
    [self initSaveDraftDataWithModel:draftUploadModel];
}

// json转数组
- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
            } else if([tmp isKindOfClass:[NSString class]] || [tmp isKindOfClass:[NSDictionary class]]) {
                
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
    
    ZYMoulageHelperDetailtParamsModel *model = self.contractArray[sender.tag - 1500];
    model.tValue = @"";
    if ([model.tType isEqualToString:@"option"]) {
        for (ZYMoulageHelperDetailtParamsModel *tempModel in self.contractArray) {
            if ([model.tKey isEqualToString:tempModel.tRelyParam]) {
                tempModel.tEditableParty = 0;
                tempModel.tValue = @"";
                
                // 保存草稿数据
                [self saveDraftDataWithParamsModel:tempModel];
            }
        }
        
        for (ZYMoulageHelperDetailtParamsModel *model in self.contractArray) {
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
    
    // 保存草稿数据
    [self saveDraftDataWithParamsModel:model];
}

// 添加印章
- (void)signatureViewTap {
    NSLog(@"添加印章");
    
    __weak typeof(self) weakSelf = self;
    [BRStringPickerView showPickerWithTitle:nil dataSourceArr:@[@"个人系统印章", @"个人印章", @"手写印章"] selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
        if (resultModel.index == 0) {
            
            NSLog(@"个人系统印章");
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
            [weakSelf initSystemSealData];
        }else if (resultModel.index == 1) {
            
            NSLog(@"个人印章");
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
            [weakSelf initPersonSealData];
        }else if (resultModel.index == 2) {
            
            NSLog(@"手写印章");
            ZYZhangDrawVC *vc = [[ZYZhangDrawVC alloc] init];
            vc.delegate = weakSelf;
            [weakSelf pushVc:vc];
        }
    }];
}

#pragma mark - 处理租赁合同
- (void)handleRentContract {
    if (self.rentSignInfoModel.assetId.length > 0 && [self.contractTemplatesDataListModel.type isEqual:@"temp_type_rent"]) {
        [self initContractPreFillData];
    }
}

// 加载租赁合同预填数据
- (void)initContractPreFillData {
    NSDictionary *params = @{@"id" : self.rentSignInfoModel.contractId};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kQueryContractPreFillInfoUrl] withBody:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.fillDataArray.count > 0) {
                    [self.fillDataArray removeAllObjects];
                }
                NSDictionary *dict = responsObject[@"data"];
                for (NSString *key in dict.allKeys) {
                    ZYTemplateFillDataModel *fillModel = [[ZYTemplateFillDataModel alloc] init];
                    fillModel.key = key;
                    id value = dict[key];
                    fillModel.value = [NSString stringWithFormat:@"%@", value];
                    [self.fillDataArray addObject:fillModel];
                }
                [self handleFillData];
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

@end
