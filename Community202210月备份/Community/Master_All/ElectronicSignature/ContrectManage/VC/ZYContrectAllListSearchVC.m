//
//  ZYContrectAllListSearchVC.m
//  Community
//
//  Created by ZY on 2021/7/12.
//

#import "ZYContrectAllListSearchVC.h"
#import "ContrectAllDetailVc.h"
#import "ZYContractSignCompleteDetailVc.h"
#import "ZYContractingPartyInformationSearchTopView.h"
#import "ContrectAllListBaseTableViewCell.h"
#import "ZYContrectAllListModel.h"

#define  ContrectAllListBaseTableViewCell_Identifier    @"ContrectAllListBaseTableViewCell"
@interface ZYContrectAllListSearchVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) ZYContractingPartyInformationSearchTopView *topView;

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *searchStr;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSString *urlStr;

@end

@implementation ZYContrectAllListSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.listVcType ) {
        case ContrectList_Type_All:
        {
            self.title = @"全部合同";
            self.urlStr = kAllContractsUrl;
        }
            break;
        case ContrectList_Type_MyWait:
        {
            self.title = @"待签合同";
            self.urlStr = kAllContractsAwaitingAttentionUrl;
        }
            break;
        case ContrectList_Type_OtherWait:
        {
            self.title = @"待他人处理合同";
            self.urlStr = kContractToBeSignedUrl;
        }
            break;
        case ContrectList_Type_Complete:
        {
            self.title = @"已完成合同";
            self.urlStr = kCompletedContractUrl;
        }
            break;
        case ContrectList_Type_Expire:
        {
            self.title = @"即将截止签署合同";
            self.urlStr = kContractAboutToExpireUrl;
        }
            break;
        case ContrectList_Type_Close:
        {
            self.title = @"即将过期合同";
            self.urlStr = kContractIsAboutToCloseUrl;
        }
            break;
        default:
            break;
    }
    
    [self setUI];
    [self customTableView];
    [self tableViewHandle];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hiddenNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setupNavigationBarClearTransparentStyle];
}

- (void)setUI {
    
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(64 + status_height);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.bottom.left.right.equalTo(_tableView.superview);
    }];
}

- (void)tableViewHandle {
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf initContrectListData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf initContrectListData];
        // 禁用header
        weakSelf.tableView.mj_header.hidden = YES;
    }];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_Dark) {
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - 懒加载
- (ZYContractingPartyInformationSearchTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYContractingPartyInformationSearchTopView" owner:nil options:nil].lastObject;
        _topView.searchTF.delegate = self;
        _topView.searchTF.placeholder = @"请输入合同名称";
        _topView.searchTF.keyboardType = UIKeyboardTypeDefault;
        _topView.searchTF.returnKeyType = UIReturnKeySearch;
        [_topView.searchTF becomeFirstResponder];
        [_topView.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_topView.searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _topView;
}

- (ZYEmptyDataTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
// 合同列表数据
- (void)initContrectListData {
    NSString *uuid =  [ShareUserInfo sharedUserInfo].userInfo.uid;
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNum" : @(self.currentPage), @"pageSize" : @(10), @"userId" : uuid, @"searchKeywords" : self.searchStr}];
    if (self.listVcType == ContrectList_Type_Expire) {
        [parms addEntriesFromDictionary:@{@"rangeDay" : @(30)}];
    }
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:self.urlStr withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 移除所有数据
                if (self.currentPage == 1) {
                    [self.dataArray removeAllObjects];
                }
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                ZYContrectAllListDataModel *dataModel = [ZYContrectAllListDataModel yy_modelWithJSON:jsonStr];
                NSArray *array = dataModel.list;
                [self.dataArray addObjectsFromArray:array];
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

#pragma mark - 定制TableView
- (void)customTableView {
    
    // 设置单元格自适应
    self.tableView.estimatedRowHeight = 82;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 设置tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerClass:[ContrectAllListBaseTableViewCell class] forCellReuseIdentifier:ContrectAllListBaseTableViewCell_Identifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContrectAllListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContrectAllListBaseTableViewCell_Identifier forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    ZYContrectAllListDataListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZYContrectAllListDataListModel *model = self.dataArray[indexPath.row];
    
    if ((model.conState == 1) && (model.partASignState == 1) && (model.partBSignState == 1)) {
        ZYContractSignCompleteDetailVc *vc = [[ZYContractSignCompleteDetailVc alloc] init];
        vc.conId = model.conId;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        ContrectAllDetailVc *vc = [[ContrectAllDetailVc alloc] init];
        vc.conId = model.conId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    self.searchStr = textField.text;
    if (!self.searchStr.length) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        [self.tableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"搜索");
    [self.view endEditing:YES];
    if (self.searchStr.length > 0) {
        self.tableView.mj_header.hidden = NO;
        [self.tableView.mj_header beginRefreshing];
    }else {
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"搜索内容不能为空!" toView:self.view];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    self.searchStr = @"";
    
    return YES;
}

#pragma mark - 处理点击事件
- (void)backButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchButtonClicked {
    
    NSLog(@"搜索");
    [self.view endEditing:YES];
    if (self.searchStr.length > 0) {
        self.tableView.mj_header.hidden = NO;
        [self.tableView.mj_header beginRefreshing];
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"搜索内容不能为空!" toView:self.view];
    }
}

@end

