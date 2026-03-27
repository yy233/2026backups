//
//  ZYMoulageHelperVc.m
//  Community
//
//  Created by ZY on 2021/4/15.
//

#import "ZYMoulageHelperVc.h"
#import "ZYMoulageHelperDetailVc.h"
#import "ZYContrectUnderSigningDetailEditVc.h"
#import "ZYMoulageHelperSearchVc.h"
#import "ZYContractTemplatesTypeModel.h"
#import "ZYAllContractTemplatesModel.h"
#import "ZYMoulageHelperVcHeaderView.h"
#import "ZYMoulageHelperVcTableViewCell.h"
#import "ZYMoulageHelperBarView.h"

static NSString * const moulageHelperVcTableViewCellID = @"ZYMoulageHelperVcTableViewCell";

@interface ZYMoulageHelperVc () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) ZYMoulageHelperBarView *barView;

@property (nonatomic, strong) ZYMoulageHelperVcHeaderView *helperHeaderView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *typeButtonArray;

@property (nonatomic, strong) NSMutableArray *dataTypeArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 是否是系统模板
@property (nonatomic, assign) BOOL isSystemTemplate;

@property (nonatomic, assign) BOOL isClearViewHidden;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ZYMoulageHelperVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isSystemTemplate = YES;
    self.isClearViewHidden = YES;
    self.barView.titleLabel.text = self.type;
    [self setBarUI];
    [self initHeaderView];
    [self.view bringSubviewToFront:self.barView];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    // 注册模板编辑返回列表通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(templateEditBack:) name:@"TEMPLATE_EDIT_BACK" object:nil];
}

// 通知回调
- (void)templateEditBack:(NSNotification *)noti {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isSystemTemplate = YES;
        [self personalTemplateButtonClicked];
    });
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TEMPLATE_EDIT_BACK" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hiddenNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setupNavigationBarClearTransparentStyle];
}

#pragma mark - 视图处理
- (void)setBarUI {
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_dingbu"];
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(backgroundImageView.superview);
        make.height.offset(44 + status_height + 100);
    }];
    
    [self.view addSubview:self.barView];
    [_barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_barView.superview);
        make.height.offset(44 + status_height);
    }];
}

- (void)initHeaderView {
    
    [self.view addSubview:self.helperHeaderView];
    [_helperHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_helperHeaderView.superview).with.offset(16);
        make.right.equalTo(_helperHeaderView.superview).with.offset(-16);
        make.height.offset(138);
        make.top.equalTo(_helperHeaderView.superview).with.offset(status_height + 54);
    }];
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self requestContractTemplateTypeData];
}

- (void)headerViewHandle {
    
    [self clearViewIsShow];
    
    CGFloat scrollViewWidth = kScreenW - 56;
    self.scrollView.frame = CGRectMake(0, 0, scrollViewWidth, 28);
    [self.helperHeaderView.contentView addSubview:self.scrollView];
    CGFloat buttonsWidth = self.dataTypeArray.count * 82 - 12;
    if (buttonsWidth > scrollViewWidth) {
        self.scrollView.contentSize = CGSizeMake(buttonsWidth, 28);
    }else {
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth, 28);
    }
    for (int i = 0; i < self.dataTypeArray.count; i++) {
        UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        typeButton.frame = CGRectMake(82 * i, 0, 70, 28);
        ZYContractTemplatesTypeDataModel *model = self.dataTypeArray[i];
        [typeButton setTitle:model.name forState:UIControlStateNormal];
        typeButton.tag = 300 + i;
        [typeButton addTarget:self action:@selector(typeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeButtonArray addObject:typeButton];
        [self settingButtonTypeWithIndex:i];
        [self.scrollView addSubview:typeButton];
    }
    [self.view reloadInputViews];
    // 加载tableView数据
    [self tableViewHandle];
}

- (void)tableViewHandle {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_tableView.superview);
        make.top.equalTo(_helperHeaderView.mas_bottom).offset(6);
    }];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf requestContractTemplateData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf requestContractTemplateData];
        // 禁用header
        weakSelf.tableView.mj_header.hidden = YES;
    }];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_Dark) {
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    // 自动加载数据
    [self.tableView.mj_header beginRefreshing];
}

// 设置button样式
- (void)settingButtonTypeWithIndex:(NSInteger)index {
    
    ZYContractTemplatesTypeDataModel *model = self.dataTypeArray[index];
    UIButton *button = self.typeButtonArray[index];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        button.backgroundColor = Y_RGBA(246, 246, 246, 1);
    }else {
        button.backgroundColor = Y_RGBA(28, 57, 112, 1);
    }
    if (model.isSelected) {
        [button setTitleColor:Y_RGBA(38, 114, 249, 1) forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = Y_RGBA(38, 114, 249, 1).CGColor;
    }else {
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            [button setTitleColor:Y_RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            button.layer.borderWidth = 1;
            button.layer.borderColor = Y_RGBA(246, 246, 246, 1).CGColor;
        }else {
            [button setTitleColor:Y_RGBA(148, 157, 170, 1) forState:UIControlStateNormal];
            button.layer.borderWidth = 1;
            button.layer.borderColor = Y_RGBA(16, 37, 78, 1).CGColor;
        }
    }
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
}

#pragma mark - 懒加载
- (ZYMoulageHelperBarView *)barView {
    if (!_barView) {
        _barView = [[NSBundle mainBundle] loadNibNamed:@"ZYMoulageHelperBarView" owner:nil options:nil].lastObject;
        [_barView.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_barView.rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _barView;
}

- (ZYMoulageHelperVcHeaderView *)helperHeaderView {
    
    if (!_helperHeaderView) {
        _helperHeaderView = [[NSBundle mainBundle] loadNibNamed:@"ZYMoulageHelperVcHeaderView" owner:nil options:nil].lastObject;
        [_helperHeaderView.personalTemplateButton addTarget:self action:@selector(personalTemplateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_helperHeaderView.systemTemplateButton addTarget:self action:@selector(systemTemplateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _helperHeaderView.clearView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearViewTap)];
        _helperHeaderView.clearView.userInteractionEnabled = YES;
        [_helperHeaderView.clearView addGestureRecognizer:tap];
    }
    
    return _helperHeaderView;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollView;
}

- (ZYEmptyDataTableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        // 设置单元格自适应
        _tableView.estimatedRowHeight = 82;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        // 设置代理
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // 设置tableView样式
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 注册单元格
        [_tableView registerNib:[UINib nibWithNibName:@"ZYMoulageHelperVcTableViewCell" bundle:nil] forCellReuseIdentifier:moulageHelperVcTableViewCellID];
    }
    
    return _tableView;
}

- (NSMutableArray *)typeButtonArray {
    if (!_typeButtonArray) {
        _typeButtonArray = [NSMutableArray array];
    }
    
    return _typeButtonArray;
}

- (NSMutableArray *)dataTypeArray {
    
    if (!_dataTypeArray) {
        _dataTypeArray = [NSMutableArray array];
    }
    
    return _dataTypeArray;
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 请求合同模板类型数据
- (void)requestContractTemplateTypeData  {
    
    NSDictionary *parms = @{};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractTemplatesTypeUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYContractTemplatesTypeDataModel class] json:jsonStr];
                
                if (self.dataTypeArray.count > 0) {
                    [self.dataTypeArray removeAllObjects];
                }
                [self.dataTypeArray addObjectsFromArray:array];
                for (ZYContractTemplatesTypeDataModel *dataModel in self.dataTypeArray) {
                    dataModel.isSelected = NO;
                }
                if (self.dataTypeArray.count > 0) {
                    [self headerViewHandle];
                }
            }else {
               
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
           
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 请求合同模板数据
- (void)requestContractTemplateData {

    NSDictionary *parms = [NSDictionary dictionary];
    if (!self.isClearViewHidden) {
        NSMutableArray *typeArray = [NSMutableArray array];
        for (ZYContractTemplatesTypeDataModel *model in self.dataTypeArray) {
            if (model.isSelected) {
                [typeArray addObject:model.sn];
            }
        }
        NSArray *typeJsonArray = [typeArray yy_modelToJSONObject];
        parms = @{@"pageNum" : @(self.currentPage), @"pageSize" : @(10), @"attr" : @(self.isSystemTemplate), @"type" : typeJsonArray};
    }else {
        parms = @{@"pageNum" : @(self.currentPage), @"pageSize" : @(10), @"attr" : @(self.isSystemTemplate)};
    }
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractTemplatesUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;

        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                ZYAllContractTemplatesDataModel *dataModel = [ZYAllContractTemplatesDataModel yy_modelWithJSON:jsonStr];
                // 先移除所有数据
                if (self.currentPage == 1) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:dataModel.list];
                // 判断数据是否加载完了
                if (self.dataArray.count >= dataModel.total) {
                    // 表示没有数据可以请求，设置UITableView footer的状态
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    // 重置提示加载更多数据
                    [self.tableView.mj_footer resetNoMoreData];
                }
                
                if (!self.dataArray.count) {
                    self.tableView.mj_footer.hidden = YES;
                    // 空占位图文
                    [self.tableView emptyDataDelegate];
                }
                
                // 刷新tableView
                [self.tableView reloadData];
            }else {
                if (self.currentPage > 1) {
                    self.currentPage -= 1;
                }
                if (self.currentPage == 1) {
                    self.tableView.mj_footer.hidden = YES;
                }
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            if (self.currentPage > 1) {
                self.currentPage -= 1;
            }
            if (self.currentPage == 1) {
                self.tableView.mj_footer.hidden = YES;
            }
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYMoulageHelperVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moulageHelperVcTableViewCellID forIndexPath:indexPath];
    cell.showButton.layer.borderWidth = 1;
    cell.showButton.layer.borderColor = Y_RGBA(38, 114, 249, 1).CGColor;
    cell.showButton.userInteractionEnabled = NO;
    ZYAllContractTemplatesDataListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZYAllContractTemplatesDataListModel *model = self.dataArray[indexPath.row];
    if ([self.type isEqualToString:@"合同模板"]) {
        ZYMoulageHelperDetailVc *vc = [[ZYMoulageHelperDetailVc alloc] init];
        vc.uuid = model.uuid;
        vc.contractTemplatesDataListModel = model;
        if ([model.belongTo isEqualToString:@"system"]) {
            vc.isSystemTemplate = YES;
        }else {
            vc.isSystemTemplate = NO;
        }
        [self pushVc:vc];
    }else if ([self.type isEqualToString:@"在线签约"]) {
        ZYContrectUnderSigningDetailEditVc *vc = [[ZYContrectUnderSigningDetailEditVc alloc] init];
        vc.uuid = model.uuid;
        vc.contractTemplatesDataListModel = model;
        vc.isImmediatelySign = NO;
        vc.rentSignInfoModel = self.rentSignInfoModel;
        vc.isSystemTemplate = self.isSystemTemplate;
        [self pushVc:vc];
    }
}

#pragma mark - 处理点击事件
- (void)backButtonClicked {
    
    [self popVC];
}

- (void)rightButtonClicked {
    
    NSLog(@"搜索");
    ZYMoulageHelperSearchVc *vc = [[ZYMoulageHelperSearchVc alloc] init];
    vc.type = self.type;
    vc.isSystemTemplate = self.isSystemTemplate;
    vc.rentSignInfoModel = self.rentSignInfoModel;
    [self pushVc:vc];
}

- (void)personalTemplateButtonClicked {
    
    if (self.isSystemTemplate) {
        self.isSystemTemplate = NO;
        self.helperHeaderView.personalTemplateButton.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
        [self.helperHeaderView.personalTemplateButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            self.helperHeaderView.systemTemplateButton.backgroundColor = Y_RGBA(190, 213, 253, 1);
            [self.helperHeaderView.systemTemplateButton setTitleColor:Y_RGBA(58, 70, 108, 1) forState:UIControlStateNormal];
        }else {
            self.helperHeaderView.systemTemplateButton.backgroundColor = Y_RGBA(0, 21, 52, 1);
            [self.helperHeaderView.systemTemplateButton setTitleColor:Y_RGBA(148, 157, 170, 1) forState:UIControlStateNormal];
        }
        [self.view reloadInputViews];
        self.currentPage = 1;
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)systemTemplateButtonClicked {
    
    if (!self.isSystemTemplate) {
        self.isSystemTemplate = YES;
        self.helperHeaderView.systemTemplateButton.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
        [self.helperHeaderView.systemTemplateButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            self.helperHeaderView.personalTemplateButton.backgroundColor = Y_RGBA(190, 213, 253, 1);
            [self.helperHeaderView.personalTemplateButton setTitleColor:Y_RGBA(58, 70, 108, 1) forState:UIControlStateNormal];
        }else {
            self.helperHeaderView.personalTemplateButton.backgroundColor = Y_RGBA(0, 21, 52, 1);
            [self.helperHeaderView.personalTemplateButton setTitleColor:Y_RGBA(148, 157, 170, 1) forState:UIControlStateNormal];
        }
        [self.view reloadInputViews];
        self.currentPage = 1;
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)clearViewIsShow {
    self.isClearViewHidden = YES;
    for (ZYContractTemplatesTypeDataModel *model in self.dataTypeArray) {
        if (model.isSelected) {
            self.isClearViewHidden = NO;
        }
    }
    self.helperHeaderView.clearView.hidden = self.isClearViewHidden;
}

- (void)clearViewTap {
    
    self.isClearViewHidden = YES;
    self.helperHeaderView.clearView.hidden = YES;
    for (int i = 0; i < self.dataTypeArray.count; i++) {
        ZYContractTemplatesTypeDataModel *model = self.dataTypeArray[i];
        model.isSelected = NO;
        [self settingButtonTypeWithIndex:i];
    }
    self.currentPage = 1;
    [self.tableView.mj_header beginRefreshing];
}

- (void)typeButtonClicked:(UIButton *)sender {
    
    NSInteger index = sender.tag - 300;
    ZYContractTemplatesTypeDataModel *model = self.dataTypeArray[index];
    if (model.isSelected) {
        model.isSelected = NO;
    }else {
        model.isSelected = YES;
    }
    [self settingButtonTypeWithIndex:index];
    [self clearViewIsShow];
    [self.view reloadInputViews];
    self.currentPage = 1;
    [self.tableView.mj_header beginRefreshing];
}

@end
