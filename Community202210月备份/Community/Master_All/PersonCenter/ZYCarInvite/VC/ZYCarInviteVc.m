//
//  ZYCarInviteVc.m
//  Community
//
//  Created by ZY on 2022/5/18.
//

#import "ZYCarInviteVc.h"
#import "ZYCarInviteBottomView.h"
#import "ZYCarInviteCell.h"

static NSString * const ZYCarInviteCellID = @"ZYCarInviteCell";
#define kZYCarInviteCellHeight 80
#define kZYCarInviteBottomViewHeight 95+button_bottom_height

@interface ZYCarInviteVc () <UITableViewDataSource, UITableViewDelegate, ZYCarInviteBottomViewDelegete>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) ZYCarInviteBottomView *bottomView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYCarInviteVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"访客邀请(车辆)";
    [self setUI];
    [self customTableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kZYCarInviteBottomViewHeight);
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

- (ZYCarInviteBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYCarInviteBottomView" owner:nil options:nil].lastObject;
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
    if (!self.dataArray.count) {
        [self.tableView emptyDataDelegate];
    }
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYCarInviteCellID bundle:nil] forCellReuseIdentifier:ZYCarInviteCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYCarInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCarInviteCellID forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYCarInviteCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
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

#pragma mark - ZYCarInviteBottomViewDelegete
// 邀请访客(车辆)
- (void)inviteButtonEvent {
    NSLog(@"邀请访客(车辆)");
}

@end
