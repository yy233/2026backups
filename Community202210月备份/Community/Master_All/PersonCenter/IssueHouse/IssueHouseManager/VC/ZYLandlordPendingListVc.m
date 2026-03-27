//
//  ZYLandlordPendingListVc.m
//  Community
//
//  Created by ZY on 2021/9/10.
//

#import "ZYLandlordPendingListVc.h"
#import "ZYSigningDetailVC.h"
#import "ZYRentContractDetailVC.h"
#import "ZYLandlordPendingListCell.h"

static NSString * const LandlordPendingListCellID = @"ZYLandlordPendingListCell";
#define kLandlordPendingListCellHeight 180

@interface ZYLandlordPendingListVc () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYLandlordPendingListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"待处理";
    [self setUI];
    [self customTableView];
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initLandlordContractListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载房东单个资产的签约列表数据
- (void)initLandlordContractListData {
    NSDictionary *params = @{@"assetType" : @(self.assetType), @"assetId" : self.assetId, @"contractStatus" : @(self.contractStatus)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kLandlordContractListUrl] withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
                ZYLandlordPendingListModel *model = [ZYLandlordPendingListModel yy_modelWithJSON:responsObject];
                [self.dataArray addObjectsFromArray:model.data];
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
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYLandlordPendingListCell" bundle:nil] forCellReuseIdentifier:LandlordPendingListCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYLandlordPendingListCell *cell = [tableView dequeueReusableCellWithIdentifier:LandlordPendingListCellID forIndexPath:indexPath];
    ZYLandlordPendingListDataModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kLandlordPendingListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld", indexPath.row);
    ZYLandlordPendingListDataModel *model = self.dataArray[indexPath.row];
    // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起 31:房东拟定发起合同(重新发起合同) 32:房东已取消发起
    if (model.operation == 4 || model.operation == 5 || model.operation == 6 || model.operation == 31 || model.operation == 32) {
        ZYRentContractDetailVC *vc = [[ZYRentContractDetailVC alloc] init];
        vc.contractId = [NSString stringWithFormat:@"%ld", model.id];
        vc.identityType = 1;
        [self pushVc:vc];
    }else {
        // 租赁签约详情
        ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
        vc.contractId = [NSString stringWithFormat:@"%ld", model.id];
        vc.identityType = 1;
        vc.assetId = self.assetId;
        vc.assetType = self.assetType;
        vc.isRentDetail = NO;
        [self pushVc:vc];
    }
}

@end
