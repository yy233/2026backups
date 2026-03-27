//
//  ZYContractingPartyInformationSearchVc.m
//  Community
//
//  Created by ZY on 2021/5/21.
//

#import "ZYContractingPartyInformationSearchVc.h"
#import "ZYContractingPartyInformationSearchTopView.h"
#import "ZYContractingPartyInformationSearchCell.h"
#import "ZYContractingPartyInformationSearchModel.h"

static NSString * const contractingPartyInformationSearchCellID = @"ZYContractingPartyInformationSearchCell";
#define kContractingPartyInformationSearchCellHeight  50

@interface ZYContractingPartyInformationSearchVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) ZYContractingPartyInformationSearchTopView *topView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *searchStr;

@end

@implementation ZYContractingPartyInformationSearchVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self customTableView];
    
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

#pragma mark - 懒加载
- (ZYContractingPartyInformationSearchTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYContractingPartyInformationSearchTopView" owner:nil options:nil].lastObject;
        _topView.searchTF.delegate = self;
        _topView.searchTF.keyboardType = UIKeyboardTypeDefault;
        _topView.searchTF.returnKeyType = UIReturnKeySearch;
        _topView.searchTF.placeholder = @"请输入姓名或手机号";
        [_topView.searchTF becomeFirstResponder];
        [_topView.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_topView.searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _topView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
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
- (void)initData {
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    NSDictionary *parms = @{@"telephone" : self.searchStr};
    NSString *jsonStr = [parms yy_modelToJSONString];
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kGetUserByPhoneUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYContractingPartyInformationSearchModel class] json:jsonStr];
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                
                if (!self.dataArray.count) {
                    [SVProgressHUD showInfoCustomHUDWithStatus:@"用户不存在"];
                }
            }else {
              
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
           
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 定制TableView
- (void)customTableView {
    
    // 防止tableView刷新漂移问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYContractingPartyInformationSearchCell" bundle:nil] forCellReuseIdentifier:contractingPartyInformationSearchCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYContractingPartyInformationSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:contractingPartyInformationSearchCellID forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    ZYContractingPartyInformationSearchModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kContractingPartyInformationSearchCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZYContractingPartyInformationSearchModel *model = self.dataArray[indexPath.row];
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CONTANCT_PARTY_INFO_SEARCH_BACK" object:model];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    self.searchStr = textField.text;
    if (!self.searchStr.length) {
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
        [self initData];
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
        [self initData];
    }else {
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"搜索内容不能为空!" toView:self.view];
    }
}

@end
