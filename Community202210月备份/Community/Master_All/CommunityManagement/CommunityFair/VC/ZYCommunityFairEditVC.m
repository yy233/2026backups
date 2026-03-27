//
//  ZYCommunityFairEditVC.m
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import "ZYCommunityFairEditVC.h"
#import "ZYCommunityFairMyIssueVC.h"
#import "ZYCommunityFairEditInputCell.h"
#import "ZYCommunityFairEditMarkCell.h"
#import "ZYCommunityFairEditPhotoCell.h"
#import "ZYCommunityFairTypeModel.h"
#import "ZYCommunityFairMarkModel.h"

static NSString * const communityFairEditInputCellID = @"ZYCommunityFairEditInputCell";
static NSString * const communityFairEditMarkCellID = @"ZYCommunityFairEditMarkCell";
static NSString * const communityFairEditPhotoCellID = @"ZYCommunityFairEditPhotoCell";

#define kCommunityFairEditInputCellHeight 500
#define kCommunityFairEditMarkCellHeight 74
#define kCommunityFairEditPhotoCellHeight 70+(kScreenW-32-20)/3.0

@interface ZYCommunityFairEditVC () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, TTGTextTagCollectionViewDelegate, ZYCommunityFairEditPhotoCellDelegate, TZImagePickerControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@property (nonatomic, strong) NSMutableArray *typesArray;

@property (nonatomic, strong) NSMutableArray *typeTagsArray;

@property (nonatomic, strong) NSMutableArray *typeTagsTempArray;

@property (nonatomic, strong) NSMutableArray *marksArray;

@property (nonatomic, strong) NSMutableArray *markTagsArray;

@property (nonatomic, strong) NSMutableArray *markTagsTempArray;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSMutableArray *uploadImagesArray;

@property (nonatomic, strong) ZYCommunityFairMarketModel *marketModel;

@property (nonatomic, copy) NSString *selectedimagePath;

// 类别数据是否加载完成
@property (nonatomic, assign) BOOL isMarketCategoryDataFinish;

// 标签数据是否加载完成
@property (nonatomic, assign) BOOL isMarketLabelDataFinish;

// 标签相关配置
@property (nonatomic, strong) TTGTextTagStringContent *content;

@property (nonatomic, strong) TTGTextTagStringContent *selectedContent;

@property (nonatomic, strong) TTGTextTagStyle *style;

@property (nonatomic, strong) TTGTextTagStyle *selectedStyle;

// 选中的类别index
@property (nonatomic, assign) NSInteger selectedTypeIndex;

// 选中的标签index
@property (nonatomic, assign) NSInteger selectedMarkIndex;

@end

@implementation ZYCommunityFairEditVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"编辑商品";
    [self leftBarButtonItemCustom];
    [self rightBarButtonItemCustom];
    [self setUI];
    [self customTableView];
    self.isMarketCategoryDataFinish = NO;
    self.isMarketLabelDataFinish = NO;
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initMarketCategoryData];
    [self initMarketLabelData];
    
    // 添加返回手势
    self.transitioningDelegate = self;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
    
    if ([self.typeStr isEqual:@"发布"]) {
        [[ShareUserInfo sharedUserInfo] getDefaultsCommunityFairMarketInfo];
        ZYCommunityFairMarketModel *model = [ShareUserInfo sharedUserInfo].communityFairMarketModel;
        if (isNotNil(model)) {
            self.marketModel = model;
        }else {
            self.marketModel = [[ZYCommunityFairMarketModel alloc] init];
        }
        
        NSArray *array = [self.marketModel.images componentsSeparatedByString:@","];
        if (self.imagesArray.count > 0) {
            [self.imagesArray removeAllObjects];
        }
        for (NSString *str in array) {
            if (str.length > 0) {
                [self.imagesArray addObject:str];
            }
        }
    }else {
        ZYCommunityFairMarketModel *model = [[ZYCommunityFairMarketModel alloc] init];
        model.goodsName = self.listModel.goodsName;
        model.price = self.listModel.price;
        model.goodsExplain = self.listModel.goodsExplain;
        model.negotiable = self.listModel.negotiable;
        model.phone = self.listModel.phone;
        model.images = self.listModel.images;
        model.categoryId = self.listModel.categoryId;
        model.categoryName = self.listModel.categoryName;
        model.labelId = self.listModel.labelId;
        model.labelName = self.listModel.labelName;
        self.marketModel = model;
        
        NSArray *array = [self.marketModel.images componentsSeparatedByString:@","];
        if (self.imagesArray.count > 0) {
            [self.imagesArray removeAllObjects];
        }
        for (NSString *str in array) {
            if (str.length > 0) {
                [self.imagesArray addObject:str];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#C5C9D4"];
    }else {
        self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#001534"];
    }
    [self setupNavigationBarStyleWithThemeColor];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].windows.lastObject].x / [UIApplication sharedApplication].windows.lastObject.bounds.size.width);
    if ((edgePan.edges == UIRectEdgeLeft) && (progress > 0.2)) {
        if ([self.typeStr isEqual:@"发布"]) {
            [self showSaveAlert];
        }else {
            [self popVC];
        }
    }
}

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {

    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame = CGRectMake(0, 0, 52, 30);
    navRightBtn.backgroundColor = Y_RGBA(35, 124, 250, 1);
    navRightBtn.layer.cornerRadius = 15;
    navRightBtn.layer.masksToBounds = YES;
    [navRightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}

// 定制左barButtonItem
- (void)leftBarButtonItemCustom {

    UIButton *navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navLeftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [navLeftBtn setTitleColor:[ZYThemeManager shareManager].navigationItemThemeColor forState:UIControlStateNormal];
    navLeftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [navLeftBtn addTarget:self action:@selector(navLeftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navLeftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:navLeftBtn];
    [self.navigationItem setLeftBarButtonItem:navLeftBtnItem animated:YES];
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.superview).offset(0.5);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
    }
    
    return _tableView;
}

- (NSMutableArray *)typesArray {
    if (!_typesArray) {
        _typesArray = [NSMutableArray array];
    }
    
    return _typesArray;
}

- (NSMutableArray *)typeTagsArray {
    if (!_typeTagsArray) {
        _typeTagsArray = [NSMutableArray array];
    }
    
    return _typeTagsArray;
}

- (NSMutableArray *)typeTagsTempArray {
    if (!_typeTagsTempArray) {
        _typeTagsTempArray = [NSMutableArray array];
    }
    
    return _typeTagsTempArray;
}

- (NSMutableArray *)marksArray {
    if (!_marksArray) {
        _marksArray = [NSMutableArray array];
    }
    
    return _marksArray;
}

- (NSMutableArray *)markTagsArray {
    if (!_markTagsArray) {
        _markTagsArray = [NSMutableArray array];
    }
    
    return _markTagsArray;
}

- (NSMutableArray *)markTagsTempArray {
    if (!_markTagsTempArray) {
        _markTagsTempArray = [NSMutableArray array];
    }
    
    return _markTagsTempArray;
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    
    return _imagesArray;
}

- (NSMutableArray *)uploadImagesArray {
    if (!_uploadImagesArray) {
        _uploadImagesArray = [NSMutableArray array];
    }
    
    return _uploadImagesArray;
}

- (TTGTextTagStringContent *)content {
    if (!_content) {
        _content = [[TTGTextTagStringContent alloc] init];
        _content.textFont = [UIFont systemFontOfSize:13];
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            _content.textColor = [UIColor zy_colorWithHexString:@"#AAAAB9"];
        }else {
            _content.textColor = [UIColor whiteColor];
        }
    }
    
    return _content;
}

- (TTGTextTagStringContent *)selectedContent {
    if (!_selectedContent) {
        _selectedContent = [[TTGTextTagStringContent alloc] init];
        _selectedContent.textFont = [UIFont systemFontOfSize:13];
        _selectedContent.textColor = [UIColor whiteColor];
    }
    
    return _selectedContent;
}

- (TTGTextTagStyle *)style {
    if (!_style) {
        _style = [[TTGTextTagStyle alloc] init];
        _style.backgroundColor = [UIColor clearColor];
        _style.shadowColor = [UIColor clearColor];
        _style.borderWidth = 0.5;
        _style.borderColor = [ZYThemeManager shareManager].borderThemeColor;
        _style.cornerRadius = 11;
        _style.extraSpace = CGSizeMake(20, 0);
        _style.exactHeight = 22;
    }
    
    return _style;
}

- (TTGTextTagStyle *)selectedStyle {
    if (!_selectedStyle) {
        _selectedStyle = [[TTGTextTagStyle alloc] init];
        _selectedStyle.backgroundColor = Y_RGBA(38, 114, 249, 1);
        _selectedStyle.shadowColor = [UIColor clearColor];
        _selectedStyle.borderWidth = 0.5;
        _selectedStyle.borderColor = Y_RGBA(38, 114, 249, 1);
        _selectedStyle.cornerRadius = 11;
        _selectedStyle.extraSpace = CGSizeMake(20, 0);
        _selectedStyle.exactHeight = 22;
    }
    
    return _selectedStyle;
}

#pragma mark - 加载数据
// 加载商品提交数据
- (void)initMarketSubmitData {
    NSDictionary *params = [NSDictionary dictionary];
    if ([self.typeStr isEqual:@"发布"]) {
        params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID), @"goodsName" : self.marketModel.goodsName, @"price" : self.marketModel.price, @"goodsExplain" : self.marketModel.goodsExplain, @"labelId" : self.marketModel.labelId, @"categoryId" : self.marketModel.categoryId, @"phone" : self.marketModel.phone, @"images" : self.marketModel.images, @"negotiable" : @(self.marketModel.negotiable)};
    }else {
        params = @{@"id" : self.listModel.ID, @"goodsName" : self.marketModel.goodsName, @"price" : self.marketModel.price, @"goodsExplain" : self.marketModel.goodsExplain, @"labelId" : self.marketModel.labelId, @"categoryId" : self.marketModel.categoryId, @"phone" : self.marketModel.phone, @"images" : self.marketModel.images, @"negotiable" : @(self.marketModel.negotiable)};
    }
    NSString *urlStr = [NSString string];
    if ([self.typeStr isEqual:@"发布"]) {
        urlStr = [NSString stringWithFormat:@"%@%@", BASE_URL, kAddMarketUrl];
    }else {
        urlStr = [NSString stringWithFormat:@"%@%@", BASE_URL, kUpdateMarketUrl];
    }
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:urlStr withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 保存商品信息
                [[ShareUserInfo sharedUserInfo] saveDefaultsCommunityFairMarketInfo:[[ZYCommunityFairMarketModel alloc] init]];
                NSString *msg;
                if ([self.typeStr isEqual:@"发布"]) {
                    msg = @"发布成功";
                    BOOL isHave = NO;
                    ZYCommunityFairMyIssueVC *myIssueVC;
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[ZYCommunityFairMyIssueVC class]]) {
                            isHave = YES;
                            myIssueVC = (ZYCommunityFairMyIssueVC *)vc;
                        }
                    }
                    if (isHave) {
                        [self.navigationController popToViewController:myIssueVC animated:YES];
                    }else {
                        ZYCommunityFairMyIssueVC *vc = [[ZYCommunityFairMyIssueVC alloc] init];
                        [self pushVc:vc];
                    }
                }else {
                    msg = @"编辑成功";
                    [self popVC];
                }
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"MARKET_SUBMIT_BACK")
                [ZYProgressHUDTool showCustomHUDTextMessage:msg toView:self.view.window];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 提示内容不能为空
- (BOOL)isContentNoEmptyPrompt {
    if (self.marketModel.goodsExplain.length > 0) {
        if (self.marketModel.categoryName.length > 0) {
            if (self.marketModel.goodsName.length > 0) {
                if ((self.marketModel.price.length > 0 && self.marketModel.negotiable == 0) || self.marketModel.negotiable == 1) {
                    if (self.marketModel.phone.length > 0) {
                        if ([ZYTextValidationTool validatePhone:self.marketModel.phone]) {
                            if (self.marketModel.labelName.length > 0) {
                                if (self.marketModel.images.length > 0) {
                                    
                                    return YES;
                                }else {
                                    [ZYProgressHUDTool showCustomHUDTextMessage:@"请上传物品图片" toView:self.view];
                                }
                            }else {
                                [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择闲置物品标签" toView:self.view];
                            }
                        }else {
                            [ZYProgressHUDTool showCustomHUDTextMessage:@"手机格式不正确，请重新填写!" toView:self.view];
                        }
                    }else {
                        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入手机号" toView:self.view];
                    }
                }else {
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入物品价格或者选择面议" toView:self.view];
                }
            }else {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入物品名称" toView:self.view];
            }
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择闲置物品类别" toView:self.view];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请填写闲置物品说明" toView:self.view];
    }
    
    return NO;
}

// 加载商品类别
- (void)initMarketCategoryData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kEditSelectMarketCategoryUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.isMarketCategoryDataFinish = YES;
                if (self.isMarketLabelDataFinish) {
                    Y_SVP_DISMISS
                }
                ZYCommunityFairTypeModel *model = [ZYCommunityFairTypeModel yy_modelWithJSON:responsObject];
                if (self.typesArray.count > 0) {
                    [self.typesArray removeAllObjects];
                }
                NSArray *array = model.data;
                for (ZYCommunityFairTypeDataModel *tempModel in array) {
                    if ([tempModel.categoryId isEqual:self.marketModel.categoryId]) {
                        [self.typesArray addObject:tempModel];
                    }
                }
                for (ZYCommunityFairTypeDataModel *tempModel in array) {
                    if (![tempModel.categoryId isEqual:self.marketModel.categoryId]) {
                        [self.typesArray addObject:tempModel];
                    }
                }
                [self handleMarketCategoryData];
                [self.tableView reloadData];
            }else {
                Y_SVP_DISMISS
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_DISMISS
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 处理商品类别数据
- (void)handleMarketCategoryData {
    if (self.typeTagsArray.count) {
        [self.typeTagsArray removeAllObjects];
    }
    if (self.typeTagsTempArray.count) {
        [self.typeTagsTempArray removeAllObjects];
    }
    for (int i = 0; i < self.typesArray.count; i++) {
        ZYCommunityFairTypeDataModel *model = self.typesArray[i];
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = model.category;
        TTGTextTagStringContent *selectedStringContent = [self.selectedContent copy];
        selectedStringContent.text = model.category;
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = self.style;
        tag.selectedStyle = self.selectedStyle;
        [self.typeTagsArray addObject:tag];
        [self.typeTagsTempArray addObject:tag];
    }
}

// 加载商品标签
- (void)initMarketLabelData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kSelectMarketLabelUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.isMarketLabelDataFinish = YES;
                if (self.isMarketCategoryDataFinish) {
                    Y_SVP_DISMISS
                }
                ZYCommunityFairMarkModel *model = [ZYCommunityFairMarkModel yy_modelWithJSON:responsObject];
                if (self.marksArray.count > 0) {
                    [self.marksArray removeAllObjects];
                }
                NSArray *array = model.data;
                for (ZYCommunityFairMarkDataModel *tempModel in array) {
                    if ([tempModel.labelId isEqual:self.marketModel.labelId]) {
                        [self.marksArray addObject:tempModel];
                    }
                }
                for (ZYCommunityFairMarkDataModel *tempModel in array) {
                    if (![tempModel.labelId isEqual:self.marketModel.labelId]) {
                        [self.marksArray addObject:tempModel];
                    }
                }
                [self handleMarketLabelData];
                [self.tableView reloadData];
            }else {
                Y_SVP_DISMISS
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_DISMISS
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 处理商品标签数据
- (void)handleMarketLabelData {
    if (self.markTagsArray.count > 0) {
        [self.markTagsArray removeAllObjects];
    }
    if (self.markTagsTempArray.count > 0) {
        [self.markTagsTempArray removeAllObjects];
    }
    for (int i = 0; i < self.marksArray.count; i++) {
        ZYCommunityFairMarkDataModel *model = self.marksArray[i];
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = model.label;
        TTGTextTagStringContent *selectedStringContent = [self.selectedContent copy];
        selectedStringContent.text = model.label;
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = self.style;
        tag.selectedStyle = self.selectedStyle;
        [self.markTagsArray addObject:tag];
        [self.markTagsTempArray addObject:tag];
    }
}

// 上传多张图片
- (void)initImagesUploadsData {
    [[ToolOfNetWork sharedTools] YrequestMarketImgFilesArrWithALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kUploadMarketImagesUrl] withParams:@{}.mutableCopy fileDataArr:self.uploadImagesArray.mutableCopy fileNameStr:@"" finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSArray *array = responsObject[@"data"];
                [self.imagesArray addObjectsFromArray:array];
                NSMutableString *mStr = [NSMutableString string];
                for (int i = 0; i < self.imagesArray.count; i++) {
                    if (i == 0) {
                        [mStr appendString:self.imagesArray[i]];
                    }else {
                        [mStr appendString:[NSString stringWithFormat:@",%@", self.imagesArray[i]]];
                    }
                }
                self.marketModel.images = [mStr copy];
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

//// 删除图片
//- (void)initDeleteImageData {
//    NSDictionary *params = @{@"images" : self.selectedimagePath};
//    [[ToolOfNetWork sharedTools] YrequestDeleteALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kDeleteMarketImageUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
//        Y_SVP_DISMISS
//        if (isNotNil(responsObject)) {
//            if (Y_IS_Success) {
//                [self.imagesArray removeObject:self.selectedimagePath];
//                NSMutableString *mStr = [NSMutableString string];
//                for (int i = 0; i < self.imagesArray.count; i++) {
//                    if (i == 0) {
//                        [mStr appendString:self.imagesArray[i]];
//                    }else {
//                        [mStr appendString:[NSString stringWithFormat:@",%@", self.imagesArray[i]]];
//                    }
//                }
//                self.marketModel.images = [mStr copy];
//                [self.tableView reloadData];
//            }else {
//                Y_SVP_SHOW_ERR_MESSAGE
//            }
//        }else {
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//    }];
//}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYCommunityFairEditInputCell" bundle:nil] forCellReuseIdentifier:communityFairEditInputCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYCommunityFairEditMarkCell" bundle:nil] forCellReuseIdentifier:communityFairEditMarkCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYCommunityFairEditPhotoCell" bundle:nil] forCellReuseIdentifier:communityFairEditPhotoCellID];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ZYCommunityFairEditInputCell *cell = [tableView dequeueReusableCellWithIdentifier:communityFairEditInputCellID forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.nameTF.tag = 200;
        cell.nameTF.delegate = self;
        cell.priceTF.tag = 300;
        cell.priceTF.delegate = self;
        cell.telTF.tag = 400;
        cell.telTF.delegate = self;
        
        if (self.typeTagsTempArray.count > 0) {
            cell.textTagCollectionView.delegate = self;
            cell.textTagCollectionView.tag = 200;
            [cell.textTagCollectionView addTags:self.typeTagsTempArray];
            self.selectedTypeIndex = 0;
            [cell.textTagCollectionView updateTagAtIndex:0 selected:YES];
            ZYCommunityFairTypeDataModel *model = self.typesArray[0];
            self.marketModel.categoryId = model.categoryId;
            self.marketModel.categoryName = model.category;
            [self.typeTagsTempArray removeAllObjects];
        }
        
        [cell.discussButton addTarget:self action:@selector(discussButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        cell.model = self.marketModel;
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYCommunityFairEditMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:communityFairEditMarkCellID forIndexPath:indexPath];
        if (self.markTagsTempArray.count > 0) {
            cell.textTagCollectionView.delegate = self;
            cell.textTagCollectionView.tag = 300;
            [cell.textTagCollectionView addTags:self.markTagsTempArray];
            self.selectedMarkIndex = 0;
            [cell.textTagCollectionView updateTagAtIndex:0 selected:YES];
            ZYCommunityFairMarkDataModel *model = self.marksArray[0];
            self.marketModel.labelId = model.labelId;
            self.marketModel.labelName = model.label;
            [self.markTagsTempArray removeAllObjects];
        }
        
        return cell;
    }else {
        ZYCommunityFairEditPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:communityFairEditPhotoCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.imagesArray = self.imagesArray;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return kCommunityFairEditInputCellHeight;
    }else if (indexPath.row == 1) {
        
        return kCommunityFairEditMarkCellHeight;
    }else {
        
        return kCommunityFairEditPhotoCellHeight;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    self.marketModel.goodsExplain = textView.text;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    if (textField.tag == 200) {
        self.marketModel.goodsName = textField.text;
    }else if (textField.tag == 300) {
        self.marketModel.price = textField.text;
    }else if (textField.tag == 400) {
        self.marketModel.phone = textField.text;
    }
}


#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    
    if (textTagCollectionView.tag == 200) {
        ZYCommunityFairEditInputCell *cell = (ZYCommunityFairEditInputCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.textTagCollectionView updateTagAtIndex:self.selectedTypeIndex selected:NO];
        [cell.textTagCollectionView updateTagAtIndex:index selected:YES];
        self.selectedTypeIndex = index;
        ZYCommunityFairTypeDataModel *model = self.typesArray[index];
        self.marketModel.categoryId = model.categoryId;
        self.marketModel.categoryName = model.category;
    }else if (textTagCollectionView.tag == 300) {
        ZYCommunityFairEditMarkCell *cell = (ZYCommunityFairEditMarkCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.textTagCollectionView updateTagAtIndex:self.selectedMarkIndex selected:NO];
        [cell.textTagCollectionView updateTagAtIndex:index selected:YES];
        self.selectedMarkIndex = index;
        ZYCommunityFairMarkDataModel *model = self.marksArray[index];
        self.marketModel.labelId = model.labelId;
        self.marketModel.labelName = model.label;
    }
    [self.tableView reloadData];
}

#pragma mark - ZYCommunityFairEditPhotoCellDelegate
- (void)addPhotos {
    
    NSLog(@"添加照片");
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakeVideo = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            NSMutableArray *tempIconImageArray = [NSMutableArray arrayWithArray:[weakSelf.imagesArray copy]];
            NSMutableArray *tempPhotosArray = [NSMutableArray array];
            [tempIconImageArray addObjectsFromArray:photos];
            if (tempIconImageArray.count > 3) {
                for (NSInteger i = weakSelf.imagesArray.count; i < 3; i++) {
                    UIImage *image = tempIconImageArray[i];
                    [tempPhotosArray addObject:image];
                }
            }else {
                [tempPhotosArray addObjectsFromArray:photos];
            }
            weakSelf.uploadImagesArray = [tempPhotosArray copy];
            
            [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"上传中..."];
            [weakSelf initImagesUploadsData];
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imageViewTapWithIndex:(NSInteger)index {
    
    NSLog(@"点击照片 %ld", index);
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < self.imagesArray.count; i++) {
        GKPhoto *photoModel = [[GKPhoto alloc] init];
        photoModel.url = [NSURL URLWithString:self.imagesArray[i]];
        photoModel.originUrl = [NSURL URLWithString:self.imagesArray[i]];
        [photos addObject:photoModel];
    }
    self.photoBrowser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    self.photoBrowser.showStyle = GKPhotoBrowserShowStyleNone;
    [self.photoBrowser showFromVC:self];
}

- (void)deletePhotoWithIndex:(NSInteger)index {
    
    NSLog(@"删除照片 %ld", index);
    self.selectedimagePath = self.imagesArray[index];
    [self.imagesArray removeObject:self.selectedimagePath];
    NSMutableString *mStr = [NSMutableString string];
    for (int i = 0; i < self.imagesArray.count; i++) {
        if (i == 0) {
            [mStr appendString:self.imagesArray[i]];
        }else {
            [mStr appendString:[NSString stringWithFormat:@",%@", self.imagesArray[i]]];
        }
    }
    self.marketModel.images = [mStr copy];
    [self.tableView reloadData];
//    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"删除中..."];
//    [self initDeleteImageData];
}

#pragma mark - 点击事件
// 取消
- (void)navLeftBtnAction {
    
    [self.view endEditing:YES];
    if ([self.typeStr isEqual:@"发布"]) {
        [self showSaveAlert];
    }else {
        [self popVC];
    }
}

- (void)showSaveAlert {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"是否保存当前信息?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"保存");
        // 保存商品信息
        [[ShareUserInfo sharedUserInfo] saveDefaultsCommunityFairMarketInfo:self.marketModel];
        [self popVC];
    }];
    UIAlertAction *noSaveAction = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"不保存");
        // 保存商品信息
        [[ShareUserInfo sharedUserInfo] saveDefaultsCommunityFairMarketInfo:[[ZYCommunityFairMarketModel alloc] init]];
        [self popVC];
    }];
    [alertVC addAction:noSaveAction];
    [alertVC addAction:saveAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 发布
- (void)navRightBtnAction {
    
    NSLog(@"发布");
    [self.view endEditing:YES];
    if ([self isContentNoEmptyPrompt]) {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"发布中..."];
        [self initMarketSubmitData];
    }
}

// 面议
- (void)discussButtonClicked {
    
    NSLog(@"面议");
    if (self.marketModel.negotiable == 1) {
        self.marketModel.negotiable = 0;
    }else {
        self.marketModel.negotiable = 1;
        self.marketModel.price = @"";
    }
    [self.tableView reloadData];
}

@end
