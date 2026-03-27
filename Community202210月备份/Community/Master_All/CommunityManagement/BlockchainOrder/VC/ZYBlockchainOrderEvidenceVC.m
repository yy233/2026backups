//
//  ZYBlockchainOrderEvidenceVC.m
//  Community
//
//  Created by ZY on 2021/10/29.
//

#import "ZYBlockchainOrderEvidenceVC.h"
#import "ZYBlockchainOrderEvidenceCell.h"

static NSString * const blockchainOrderEvidenceCellID = @"ZYBlockchainOrderEvidenceCell";

@interface ZYBlockchainOrderEvidenceVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYBlockchainOrderEvidenceModel *detailModel;

@end

@implementation ZYBlockchainOrderEvidenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单凭证";
    [self setUI];
    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"加载中..."];
    [self initBlockchainOrderEvidenceData];
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
- (void)initBlockchainOrderEvidenceData {
    NSDictionary *parms = @{@"orderId" : self.orderId};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kBlockchainOrderEvidenceUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                self.detailModel = [ZYBlockchainOrderEvidenceModel yy_modelWithJSON:jsonStr];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYBlockchainOrderEvidenceCell" bundle:nil] forCellReuseIdentifier:blockchainOrderEvidenceCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYBlockchainOrderEvidenceCell *cell = [tableView dequeueReusableCellWithIdentifier:blockchainOrderEvidenceCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITabBarDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:blockchainOrderEvidenceCellID cacheByIndexPath:indexPath configuration:^(ZYBlockchainOrderEvidenceCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    
    ZYBlockchainOrderEvidenceCell *cell = (ZYBlockchainOrderEvidenceCell *)currentCell;
    cell.model = self.detailModel;
}

@end
