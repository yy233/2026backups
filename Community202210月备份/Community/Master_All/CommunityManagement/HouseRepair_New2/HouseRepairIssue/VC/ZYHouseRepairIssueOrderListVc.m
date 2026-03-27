//
//  ZYHouseRepairIssueOrderListVc.m
//  Community
//
//  Created by ZY on 2022/4/12.
//

#import "ZYHouseRepairIssueOrderListVc.h"
#import "ZYHouseRepairIssueListCell.h"
#import "ZYHouseRepairIssueOrderModel.h"

static NSString * const ZYHouseRepairIssueListCellID = @"ZYHouseRepairIssueListCell";
#define kZYHouseRepairIssueListCellHeight 55

@interface ZYHouseRepairIssueOrderListVc () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 是否展示子级
@property (nonatomic, assign) BOOL isShowChildren;

// 子级index
@property (nonatomic, assign) NSInteger childrenIndex;

@end

@implementation ZYHouseRepairIssueOrderListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择工单类型";
    [self setUI];
    [self customTableView];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_Lf0f1f6_D001534];
}

#pragma mark - 布局视图
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
    NSDictionary *params = @{@"communityId" : self.communityId};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kRepairOrderListUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    if (self.dataArray.count > 0) {
                        [self.dataArray removeAllObjects];
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYHouseRepairIssueOrderModel class] json:responsObject[@"data"]];
                    [self.dataArray addObjectsFromArray:array];
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
        });
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYHouseRepairIssueListCellID bundle:nil] forCellReuseIdentifier:ZYHouseRepairIssueListCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isShowChildren) {
        ZYHouseRepairIssueOrderModel *model = self.dataArray[self.childrenIndex];
        
        return model.children.count;
    }
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYHouseRepairIssueListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYHouseRepairIssueListCellID forIndexPath:indexPath];
    if (self.isShowChildren) {
        ZYHouseRepairIssueOrderModel *model = self.dataArray[self.childrenIndex];
        ZYHouseRepairIssueOrderChildrenModel *childrenModel = model.children[indexPath.row];
        cell.titleLabel.text = childrenModel.name;
    }else {
        ZYHouseRepairIssueOrderModel *model = self.dataArray[indexPath.row];
        cell.titleLabel.text = model.name;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYHouseRepairIssueListCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld", indexPath.row);
    if (!self.isShowChildren) {
        ZYHouseRepairIssueOrderModel *model = self.dataArray[indexPath.row];
        if (model.children.count > 0) {
            self.isShowChildren = YES;
            self.childrenIndex = indexPath.row;
            [self.tableView reloadData];
        }else {
            NSDictionary *dict = @{@"typeId" : model.ID, @"typeName" : model.name};
            // 发送通知
            Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(@"HOUSE_REPAIR_ORDER_BACK", dict);
            [self popVC];
        }
    }else {
        ZYHouseRepairIssueOrderModel *model = self.dataArray[self.childrenIndex];
        ZYHouseRepairIssueOrderChildrenModel *childrenModel = model.children[indexPath.row];
        NSDictionary *dict = @{@"typeId" : childrenModel.ID, @"typeName" : childrenModel.name};
        // 发送通知
        Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(@"HOUSE_REPAIR_ORDER_BACK", dict);
        [self popVC];
    }
}

@end

