//
//  ZYLifeCostHouseholdVC.m
//  Community
//
//  Created by ZY on 2022/1/6.
//

#import "ZYLifeCostHouseholdVC.h"
#import "ZYLifeCostAddGroupVC.h"
#import "ZYLifeCostHouseholdTopView.h"
#import "ZYLifeCostHouseholdBottomView.h"
#import "ZYLifeCostHouseholdHeaderView.h"
#import "ZYLifeCostHouseholdCell.h"
#import "ZYLifeCostData.h"

static NSString * const lifeCostHouseholdCellID = @"ZYLifeCostHouseholdCell";
#define kLifeCostHouseholdBottomViewHeight 85+button_bottom_height
#define kLifeCostHouseholdHeaderViewHeight 50
#define kLifeCostHouseholdCellHeight 70

@interface ZYLifeCostHouseholdVC () <UITableViewDataSource, UITableViewDelegate, TTGTextTagCollectionViewDelegate, ZYLifeCostHouseholdBottomViewDelegate, ZYLifeCostHouseholdCellDelegate>

@property (nonatomic, strong) ZYLifeCostHouseholdTopView *topView;

@property (nonatomic, strong) ZYLifeCostHouseholdBottomView *bottomView;

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *searchArray;

@property (nonatomic, strong) NSMutableArray *menuArray;

@property (nonatomic, strong) NSMutableArray *menuTagArray;

@property (nonatomic, strong) NSMutableArray *menuTagTempArray;

@property (nonatomic, assign) CGFloat textTagCollectionViewHeight;

// 选中的标签index
@property (nonatomic, assign) NSInteger selectedTagIndex;

// 标签相关配置
@property (nonatomic, strong) TTGTextTagStringContent *content;

@property (nonatomic, strong) TTGTextTagStringContent *selectedContent;

@property (nonatomic, strong) TTGTextTagStyle *style;

@property (nonatomic, strong) TTGTextTagStyle *selectedStyle;

// 当前分组model
@property (nonatomic, strong) ZYLifeCostHouseholdModel *currentGroupModel;

// 当前户号model
@property (nonatomic, strong) ZYLifeCostHouseholdListModel *currentHouseholdModel;

@end

@implementation ZYLifeCostHouseholdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"户号管理";
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
    // 自动加载数据
    [self.tableView.mj_header beginRefreshing];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"LIFE_COST_CHANGE_GROUP_BACK", lifeCostChangeGroupBack:)
}

// 通知回调
- (void)lifeCostChangeGroupBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initData];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"LIFE_COST_CHANGE_GROUP_BACK")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(self.textTagCollectionViewHeight);
    }];
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_topView.superview);
        make.height.offset(kLifeCostHouseholdBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableView.superview);
        make.top.equalTo(_topView.mas_bottom).offset(15);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYLifeCostHouseholdTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYLifeCostHouseholdTopView" owner:nil options:nil].lastObject;
    }
    
    return _topView;
}

- (ZYLifeCostHouseholdBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYLifeCostHouseholdBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (ZYEmptyDataTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    
    return _searchArray;
}

- (NSMutableArray *)menuArray {
    if (!_menuArray) {
        _menuArray = [NSMutableArray array];
    }
    
    return _menuArray;
}

- (NSMutableArray *)menuTagArray {
    if (!_menuTagArray) {
        _menuTagArray = [NSMutableArray array];
    }
    
    return _menuTagArray;
}

- (NSMutableArray *)menuTagTempArray {
    if (!_menuTagTempArray) {
        _menuTagTempArray = [NSMutableArray array];
    }
    
    return _menuTagTempArray;
}

- (TTGTextTagStringContent *)content {
    if (!_content) {
        _content = [[TTGTextTagStringContent alloc] init];
        _content.textFont = [UIFont systemFontOfSize:14];
        _content.textColor = [ZYThemeManager shareManager].titleThemeColor;
    }
    
    return _content;
}

- (TTGTextTagStringContent *)selectedContent {
    if (!_selectedContent) {
        _selectedContent = [[TTGTextTagStringContent alloc] init];
        _selectedContent.textFont = [UIFont systemFontOfSize:14];
        _selectedContent.textColor = [UIColor whiteColor];
    }
    
    return _selectedContent;
}

- (TTGTextTagStyle *)style {
    if (!_style) {
        _style = [[TTGTextTagStyle alloc] init];
        _style.backgroundColor = [UIColor clearColor];
        _style.shadowColor = [UIColor clearColor];
        _style.borderWidth = 0.5;
        _style.borderColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
        _style.cornerRadius = 2.5;
        _style.extraSpace = CGSizeMake(30, 0);
        _style.exactHeight = 32;
    }
    
    return _style;
}

- (TTGTextTagStyle *)selectedStyle {
    if (!_selectedStyle) {
        _selectedStyle = [[TTGTextTagStyle alloc] init];
        _selectedStyle.backgroundColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        _selectedStyle.shadowColor = [UIColor clearColor];
        _selectedStyle.borderWidth = 0.5;
        _selectedStyle.borderColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        _selectedStyle.cornerRadius = 2.5;
        _selectedStyle.extraSpace = CGSizeMake(30, 0);
        _selectedStyle.exactHeight = 32;
    }
    
    return _selectedStyle;
}

#pragma mark - 加载数据
- (void)initData {
    [ZYLifeCostData lifeCostHouseholdListWithParams:@{} dictBlock:^(id  _Nonnull responsObject, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        if (success) {
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
            }
            if (self.searchArray.count > 0) {
                [self.searchArray removeAllObjects];
            }
            NSArray *array = [NSArray yy_modelArrayWithClass:[ZYLifeCostHouseholdModel class] json:responsObject[@"data"]];
            [self.dataArray addObjectsFromArray:array];
            [self.searchArray addObjectsFromArray:array];
            if (!self.dataArray.count) {
                // 空占位图文
                [self.tableView emptyDataDelegate];
            }else {
                self.tableView.emptyDataSetSource = nil;
                self.tableView.emptyDataSetDelegate = nil;
            }
            [self.tableView reloadData];
            [self handleMenuData];
        }
    }];
}

// 处理菜单数据
- (void)handleMenuData {
    if (self.menuArray.count > 0) {
        [self.menuArray removeAllObjects];
    }
    if (self.menuTagArray.count > 0) {
        [self.menuTagArray removeAllObjects];
    }
    if (self.menuTagTempArray.count > 0) {
        [self.menuTagTempArray removeAllObjects];
    }
    [self.topView.textTagCollectionView removeAllTags];
    if (self.dataArray.count > 0) {
        [self.menuArray addObject:@"全部"];
    }else {
        self.textTagCollectionViewHeight = 0;
        [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.textTagCollectionViewHeight);
        }];
        return;
    }
    for (ZYLifeCostHouseholdModel *model in self.dataArray) {
        [self.menuArray addObject:model.groupName];
    }
    for (int i = 0; i < self.menuArray.count; i++) {
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = self.menuArray[i];
        TTGTextTagStringContent *selectedStringContent = [self.selectedContent copy];
        selectedStringContent.text = self.menuArray[i];
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = self.style;
        tag.selectedStyle = self.selectedStyle;
        [self.menuTagArray addObject:tag];
        [self.menuTagTempArray addObject:tag];
    }
    if (self.menuTagTempArray.count > 0) {
        self.topView.textTagCollectionView.delegate = self;
        [self.topView.textTagCollectionView addTags:self.menuTagArray];
        [self.topView.textTagCollectionView updateTagAtIndex:0 selected:YES];
        self.textTagCollectionViewHeight = self.topView.textTagCollectionView.contentSize.height;
        [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.textTagCollectionViewHeight);
        }];
        [self.menuTagTempArray removeAllObjects];
    }
    [self.topView reloadInputViews];
}

// 加载删除分组数据
- (void)initDeleteGroupData {
    NSDictionary *params = @{@"id" : self.currentGroupModel.ID};
    [ZYLifeCostData lifeCostDeleteGroupWithParams:params dictBlock:^(id  _Nonnull responsObject, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            NSDictionary *groupInfo = @{@"groupId" : self.currentGroupModel.ID, @"groupName" : self.currentGroupModel.groupName};
            Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(@"LIFE_COST_CHANGE_GROUP_BACK", groupInfo)
        }
    }];
}

// 加载删除户号数据
- (void)initDeleteHouseholdData {
    NSDictionary *params = @{@"id" : self.currentHouseholdModel.ID};
    [ZYLifeCostData lifeCostDeleteHouseholdWithParams:params dictBlock:^(id  _Nonnull responsObject, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            Y_NSNotificationCenter_PostNotice_NilObject_Name(@"LIFE_COST_CHANGE_GROUP_BACK")
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:lifeCostHouseholdCellID bundle:nil] forCellReuseIdentifier:lifeCostHouseholdCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.searchArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZYLifeCostHouseholdModel *model = self.searchArray[section];
    
    return model.accountEntityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYLifeCostHouseholdCell *cell = [tableView dequeueReusableCellWithIdentifier:lifeCostHouseholdCellID forIndexPath:indexPath];
    cell.delegate = self;
    ZYLifeCostHouseholdModel *model = self.searchArray[indexPath.section];
    ZYLifeCostHouseholdListModel *listModel = model.accountEntityList[indexPath.row];
    if (indexPath.row == (model.accountEntityList.count - 1)) {
        [cell.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, kLifeCostHouseholdCellHeight) radius:7.5 corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    cell.model = listModel;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kLifeCostHouseholdCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZYLifeCostHouseholdHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYLifeCostHouseholdHeaderView" owner:nil options:nil].lastObject;
    ZYLifeCostHouseholdModel *model = self.searchArray[section];
    if (!model.accountEntityList.count) {
        headerView.lineView.hidden = YES;
        [headerView.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, kLifeCostHouseholdHeaderViewHeight) radius:7.5 corners:UIRectCornerAllCorners];
    }
    headerView.titleLabel.text = model.groupName;
    headerView.moreButton.tag = 500 + section;
    [headerView.moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kLifeCostHouseholdHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15;
}

#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    [self.topView.textTagCollectionView updateTagAtIndex:self.selectedTagIndex selected:NO];
    [self.topView.textTagCollectionView updateTagAtIndex:index selected:YES];
    self.selectedTagIndex = index;
    if (self.searchArray.count > 0) {
        [self.searchArray removeAllObjects];
    }
    if (self.selectedTagIndex == 0) {
        [self.searchArray addObjectsFromArray:self.dataArray];
    }else {
        ZYLifeCostHouseholdModel *model = self.dataArray[self.selectedTagIndex - 1];
        [self.searchArray addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - ZYLifeCostHouseholdBottomViewDelegate
- (void)addButtonEvent {
    NSLog(@"添加");
    ZYLifeCostAddGroupVC *vc = [[ZYLifeCostAddGroupVC alloc] init];
    vc.type = ZYLife_Cost_Type_AddGroup;
    [self pushVc:vc];
}

#pragma mark - ZYLifeCostHouseholdCellDelegate
- (void)deleteButtonEventWithModel:(ZYLifeCostHouseholdListModel *)model {
    NSLog(@"删除户号");
    self.currentHouseholdModel = model;
    [self showAlertDeleteHousehold];
}

#pragma mark - 处理点击事件
- (void)moreButtonClicked:(UIButton *)sender {
    NSLog(@"更多 %ld", sender.tag - 500);
    NSInteger index = sender.tag - 500;
    ZYLifeCostHouseholdModel *model = self.searchArray[index];
    self.currentGroupModel = model;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editAlert = [UIAlertAction actionWithTitle:@"修改名称" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"修改名称");
        ZYLifeCostAddGroupVC *vc = [[ZYLifeCostAddGroupVC alloc] init];
        vc.type = ZYLife_Cost_Type_UpdateGroup;
        vc.groupId = model.ID;
        vc.groupName = model.groupName;
        [self pushVc:vc];
    }];
    UIAlertAction *deleteAlert = [UIAlertAction actionWithTitle:@"删除分组" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertDeleteGroup];
    }];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:editAlert];
    [alertVC addAction:deleteAlert];
    [alertVC addAction:cancelAlert];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 删除分组提示视图
- (void)showAlertDeleteGroup {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否确认删除该分组?" message:@"删除后分组下所有用户号都将一键删除" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *deleteAlert = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除");
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"删除中..."];
        [self initDeleteGroupData];
    }];
    [alertVC addAction:cancelAlert];
    [alertVC addAction:deleteAlert];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 删除户号提示视图
- (void)showAlertDeleteHousehold {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否确认删除该户号?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *deleteAlert = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除");
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"删除中..."];
        [self initDeleteHouseholdData];
    }];
    [alertVC addAction:cancelAlert];
    [alertVC addAction:deleteAlert];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
