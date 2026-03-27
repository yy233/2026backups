//
//  ZYRedCardListVC.m
//  Community
//
//  Created by ZY on 2021/6/8.
//

#import "ZYRedCardListVC.h"
#import "ZYRedCardListCell.h"
#import "ZYRedCardListModel.h"

static NSString * const redCardListCellID = @"ZYRedCardListCell";
#define kRedCardListCellHeight 90

@interface ZYRedCardListVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYRedCardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"红包卡券";
    [self setupNavigationBarWhiteStyle];
    
    [self setUI];
    [self customTableView];
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initAllRedpacketData];
    }];
    // 自动刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarWhiteStyle];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = Y_RGBA(245, 245, 245, 1);
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
- (void)initAllRedpacketData {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_BuniessService_Default, URL_Get_Red_Packet];
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
                ZYRedCardListModel *model = [ZYRedCardListModel yy_modelWithJSON:responsObject];
                [self.dataArray addObjectsFromArray:model.data];
                // 刷新tableView
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
    self.tableView.estimatedRowHeight = kRedCardListCellHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYRedCardListCell" bundle:nil] forCellReuseIdentifier:redCardListCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYRedCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:redCardListCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.statusButton.tag = 200 + indexPath.row;
    [cell.statusButton addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - 处理点击事件
- (void)statusButtonClicked:(UIButton *)sender {
    
    NSLog(@"去使用 %ld", sender.tag - 200);
}

@end
