//
//  ZYBlockchainIDcardVC.m
//  Community
//
//  Created by ZY on 2021/10/28.
//

#import "ZYBlockchainIDcardVC.h"
#import "ZYBlockchainIDcardCell.h"

static NSString * const blockchainIDcardCellID = @"ZYBlockchainIDcardCell";

@interface ZYBlockchainIDcardVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYBlockchainIDcardDataModel *detailModel;

@end

@implementation ZYBlockchainIDcardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"区块链电子身份证";
    [self setUI];
    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"加载中..."];
    [self initBlockchainIDcardData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_Lf0f1f6_D001534];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
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

#pragma mark - 加载区块链电子身份证数据
- (void)initBlockchainIDcardData {
    NSDictionary *parms = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kBlockchainIDcardUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                self.detailModel = [ZYBlockchainIDcardDataModel yy_modelWithJSON:jsonStr];
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

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYBlockchainIDcardCell" bundle:nil] forCellReuseIdentifier:blockchainIDcardCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYBlockchainIDcardCell *cell = [tableView dequeueReusableCellWithIdentifier:blockchainIDcardCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITabBarDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:blockchainIDcardCellID cacheByIndexPath:indexPath configuration:^(ZYBlockchainIDcardCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    
    ZYBlockchainIDcardCell *cell = (ZYBlockchainIDcardCell *)currentCell;
    cell.model = self.detailModel;
}

@end
