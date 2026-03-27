//
//  ZYParkingTemporaryVC.m
//  Community
//
//  Created by ZY on 2021/10/25.
//

#import "ZYParkingTemporaryVC.h"
#import "ZYParkingTemporaryDetailVC.h"
#import "ZYParkingTemporaryCell.h"

static NSString * const parkingTemporaryCellID = @"ZYParkingTemporaryCell";
#define kParkingTemporaryCellHeight 125

@interface ZYParkingTemporaryVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYParkingTemporaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"临时缴费";
    [self setUI];
    [self customTableView];
    [self refreshingData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYEmptyDataTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 下拉刷新数据
- (void)refreshingData {
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf initParkingTemporaryData];
    }];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_Dark) {
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    self.tableView.mj_header = header;
    // 自动加载数据
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 加载临时缴费数据
- (void)initParkingTemporaryData {
    NSDictionary *parms = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kGetTemporaryOrderUrl] withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
                ZYParkingTemporaryModel *model = [ZYParkingTemporaryModel yy_modelWithJSON:responsObject];
                [self.dataArray addObjectsFromArray:model.data];
                if (!self.dataArray.count) {
                    // 空占位图文
                    [self.tableView emptyDataDelegate];
                }
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYParkingTemporaryCell" bundle:nil] forCellReuseIdentifier:parkingTemporaryCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYParkingTemporaryCell *cell = [tableView dequeueReusableCellWithIdentifier:parkingTemporaryCellID forIndexPath:indexPath];
    ZYParkingTemporaryDataModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kParkingTemporaryCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYParkingTemporaryDataModel *model = self.dataArray[indexPath.row];

    NSString *idStr = [NSString stringWithFormat:@"%@",model.ID];
    
    ZYParkingTemporaryDetailVC *vc = [[ZYParkingTemporaryDetailVC alloc] init];
    vc.orderId = idStr;
    [self pushVc:vc];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

@end
