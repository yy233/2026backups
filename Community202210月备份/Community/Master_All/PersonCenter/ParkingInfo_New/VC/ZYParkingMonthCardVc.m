//
//  ZYParkingMonthCardVc.m
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import "ZYParkingMonthCardVc.h"
#import "ZYParkingInvalidMonthCardVc.h"
#import "ZYParkingMonthCardRenewalVc.h"
#import "ZYParkingAddMonthCardVc.h"
#import "ZYParkingMonthCardCell.h"
#import "ZYParkingMonthCardBottomView.h"

static NSString * const ZYParkingMonthCardCellID = @"ZYParkingMonthCardCell";
#define kZYParkingMonthCardCellHeight 220
#define kZYParkingMonthCardBottomViewheight 90+button_bottom_height

@interface ZYParkingMonthCardVc () <UITableViewDataSource, UITableViewDelegate, ZYParkingMonthCardBottomViewDelegate>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) ZYParkingMonthCardBottomView *bottomView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYParkingMonthCardVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@-月卡", [ShareUserInfo sharedUserInfo].commuityInfo.name];
    [self rightBarButtonItemCustom];
    [self setUI];
    [self customTableView];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf initData];
    }];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_Dark) {
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    self.tableView.mj_header = header;
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initData];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"PARKING_MONTHCARD_SUCCESS_BACK", parkingMonthCardSuccessBack);
}

// 通知回调
- (void)parkingMonthCardSuccessBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initData];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"PARKING_MONTHCARD_SUCCESS_BACK");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [navRightBtn setTitle:@"已失效" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[ZYThemeManager shareManager].navigationItemThemeColor forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}

// 已失效
- (void)navRightBtnAction {
    NSLog(@"已失效");
    ZYParkingInvalidMonthCardVc *vc = [[ZYParkingInvalidMonthCardVc alloc] init];
    [self pushVc:vc];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kZYParkingMonthCardBottomViewheight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYEmptyDataTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] init];
    }
    
    return _tableView;
}

- (ZYParkingMonthCardBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYParkingMonthCardBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID), @"type" : @(0)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kParkingMonthCardUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
            if (!self.dataArray.count) {
                self.tableView.mj_footer.hidden = YES;
            }
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    if (self.dataArray.count > 0) {
                        [self.dataArray removeAllObjects];
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYParkingMonthCardModel class] json:responsObject[@"data"]];
                    [self.dataArray addObjectsFromArray:array];
                    if (!self.dataArray.count) {
                        [self.tableView emptyDataDelegate];
                    }
                    [self.tableView reloadData];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYParkingMonthCardCellID bundle:nil] forCellReuseIdentifier:ZYParkingMonthCardCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYParkingMonthCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYParkingMonthCardCellID forIndexPath:indexPath];
    cell.renewalButton.tag = 200 + indexPath.row;
    [cell.renewalButton addTarget:self action:@selector(renewalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    ZYParkingMonthCardModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYParkingMonthCardCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - ZYParkingMonthCardBottomViewDelegate
// 购买月租卡
- (void)buyButtonEvent {
    NSLog(@"购买月租卡");
    ZYParkingAddMonthCardVc *vc = [[ZYParkingAddMonthCardVc alloc] init];
    [self pushVc:vc];
}

#pragma mark - 处理点击事件
// 续期
- (void)renewalButtonClicked:(UIButton *)sender {
    NSLog(@"续期 %ld", sender.tag - 200);
    ZYParkingMonthCardRenewalVc *vc = [[ZYParkingMonthCardRenewalVc alloc] init];
    ZYParkingMonthCardModel *model = self.dataArray[sender.tag - 200];
    vc.model = model;
    [self pushVc:vc];
}

@end
