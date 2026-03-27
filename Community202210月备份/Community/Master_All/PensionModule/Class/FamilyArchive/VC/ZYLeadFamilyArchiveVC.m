//
//  ZYLeadFamilyArchiveVC.m
//  Community
//
//  Created by ZY on 2021/12/3.
//

#import "ZYLeadFamilyArchiveVC.h"
#import "ZYFamilyArchiveVC.h"
#import "ZYPensionEmptyTableView.h"
#import "ZYLeadFamilyArchiveBottomView.h"
#import "ZYLeadFamilyArchiveCell.h"

static NSString * const leadFamilyArchiveCellID = @"ZYLeadFamilyArchiveCell";
#define kLeadFamilyArchiveBottomViewHeight button_bottom_height+85
#define kLeadFamilyArchiveCellHeight 58

@interface ZYLeadFamilyArchiveVC () <UITableViewDataSource, UITableViewDelegate, ZYLeadFamilyArchiveBottomViewDelegate>

@property (nonatomic, strong) ZYLeadFamilyArchiveBottomView *bottomView;

@property (nonatomic, strong) ZYPensionEmptyTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYLeadFamilyArchiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"导入家人";
    [self setUI];
    [self customTableView];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initFamilyMembersData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithSOSColor];
}

- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kLeadFamilyArchiveBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYLeadFamilyArchiveBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYLeadFamilyArchiveBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (ZYPensionEmptyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYPensionEmptyTableView alloc] init];
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
// 加载家人数据
- (void)initFamilyMembersData {
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kFamilyMembersUrl] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.dataArray.count) {
                        [self.dataArray removeAllObjects];
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYLeadFamilyArchiveModel class] json:responsObject[@"data"]];
                    [self.dataArray addObjectsFromArray:array];
                    if (!self.dataArray.count) {
                        [self.tableView emptyDataDelegate];
                    }
                    [self.tableView reloadData];
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载导入家人数据
- (void)initImportFamilyData {
    NSArray *submitArray = [self handleFamilyData];
    if (!submitArray.count) {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请勾选要导入的家人" toView:self.view];
        return;
    }
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"导入中..."];
    NSDictionary *params = @{@"families" : submitArray};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kImportFamilyUrl]  withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 发送通知
                    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"PENSION_ADD_FAMILY_BACK")
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"导入成功" toView:self.view.window];
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[ZYFamilyArchiveVC class]]) {
                            [self popVc:vc];
                        }
                    }
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 处理家人数据
- (NSArray<ZYLeadFamilyArchiveModel *> *)handleFamilyData {
    NSMutableArray *mArray = [NSMutableArray array];
    for (ZYLeadFamilyArchiveModel *tempModel in self.dataArray) {
        if (tempModel.isSelected) {
            [mArray addObject:[tempModel yy_modelToJSONObject]];
        }
    }
    
    return [mArray copy];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.separatorColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:leadFamilyArchiveCellID bundle:nil] forCellReuseIdentifier:leadFamilyArchiveCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYLeadFamilyArchiveCell *cell = [tableView dequeueReusableCellWithIdentifier:leadFamilyArchiveCellID forIndexPath:indexPath];
    ZYLeadFamilyArchiveModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kLeadFamilyArchiveCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZYLeadFamilyArchiveModel *model = self.dataArray[indexPath.row];
    model.isSelected = !model.isSelected;
    [self.tableView reloadData];
}
#pragma mark - ZYLeadFamilyArchiveBottomViewDelegate
// 确认
- (void)okButtonEvent {
    
    NSLog(@"确认");
    [self initImportFamilyData];
}

@end
