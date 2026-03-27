//
//  ZYLifeCostAddGroupVC.m
//  Community
//
//  Created by ZY on 2022/1/7.
//

#import "ZYLifeCostAddGroupVC.h"
#import "ZYLifeCostAddGroupTopView.h"
#import "ZYLifeCostAddGroupBottomView.h"
#import "ZYLifeCostAddGroupMenuCell.h"
#import "ZYLifeCostAddGroupCommunityCell.h"
#import "ZYLifeCostHouseholdModel.h"
#import "ZYLifeCostData.h"

static NSString * const lifeCostAddGroupMenuCellID = @"ZYLifeCostAddGroupMenuCell";
static NSString * const lifeCostAddGroupCommunityCellID = @"ZYLifeCostAddGroupCommunityCell";
#define kLifeCostAddGroupTopViewHeight 95
#define kLifeCostAddGroupBottomViewHeight 85+button_bottom_height
#define kLifeCostAddGroupPlotCellHeight 70

@interface ZYLifeCostAddGroupVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TTGTextTagCollectionViewDelegate, ZYLifeCostAddGroupBottomViewDelegate>

@property (nonatomic, strong) ZYLifeCostAddGroupTopView *topView;

@property (nonatomic, strong) ZYLifeCostAddGroupBottomView *bottomView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

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

@end

@implementation ZYLifeCostAddGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分组设置";
    [self setUI];
    [self customTableView];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initGroupListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kLifeCostAddGroupTopViewHeight);
    }];
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kLifeCostAddGroupBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableView.superview);
        make.top.equalTo(_topView.mas_bottom);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYLifeCostAddGroupTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYLifeCostAddGroupTopView" owner:nil options:nil].lastObject;
        _topView.nameTF.delegate = self;
        _topView.nameTF.text = self.groupName;
    }
    
    return _topView;
}

- (ZYLifeCostAddGroupBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYLifeCostAddGroupBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
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
        _content.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    }
    
    return _content;
}

- (TTGTextTagStringContent *)selectedContent {
    if (!_selectedContent) {
        _selectedContent = [[TTGTextTagStringContent alloc] init];
        _selectedContent.textFont = [UIFont systemFontOfSize:14];
        _selectedContent.textColor = [UIColor zy_colorWithHexString:@"#2672F9"];
    }
    
    return _selectedContent;
}

- (TTGTextTagStyle *)style {
    if (!_style) {
        _style = [[TTGTextTagStyle alloc] init];
        _style.backgroundColor = [UIColor clearColor];
        _style.shadowColor = [UIColor clearColor];
        _style.borderWidth = 0.5;
        _style.borderColor = [UIColor zy_colorWithHexString:@"#C5C9D4"];
        _style.cornerRadius = 2.5;
        _style.extraSpace = CGSizeMake(20, 0);
        _style.exactHeight = 25;
    }
    
    return _style;
}

- (TTGTextTagStyle *)selectedStyle {
    if (!_selectedStyle) {
        _selectedStyle = [[TTGTextTagStyle alloc] init];
        _selectedStyle.backgroundColor = [UIColor clearColor];
        _selectedStyle.shadowColor = [UIColor clearColor];
        _selectedStyle.borderWidth = 0.5;
        _selectedStyle.borderColor = [UIColor zy_colorWithHexString:@"#2672F9"];
        _selectedStyle.cornerRadius = 2.5;
        _selectedStyle.extraSpace = CGSizeMake(20, 0);
        _selectedStyle.exactHeight = 25;
    }
    
    return _selectedStyle;
}

#pragma mark - 加载数据
// 加载分组列表数据
- (void)initGroupListData {
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:[NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, kLifeCostGetGroupListUrl] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYLifeCostHouseholdModel class] json:responsObject[@"data"]];
                    for (ZYLifeCostHouseholdModel *model in array) {
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
                    [self.tableView reloadData];
                    [self initNearCommunityData];
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载附近小区数据
- (void)initNearCommunityData {
    NSDictionary *params = @{@"lng" : @([ShareUserInfo sharedUserInfo].positioningModel.longitude), @"lat" : @([ShareUserInfo sharedUserInfo].positioningModel.latitude)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, kLifeCostNearCommunityUrl] withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYLifeCostNearCommunityModel class] json:responsObject[@"data"]];
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载添加分组数据
- (void)initAddGroupData {
    NSDictionary *params = @{@"groupName" : self.groupName};
    [ZYLifeCostData lifeCostAddGroupWithParams:params dictBlock:^(id  _Nonnull responsObject, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            if (self.type == ZYLife_Cost_Type_AddGroup) {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"添加成功" toView:self.view.window];
            }
            NSString *groupId = responsObject[@"data"];
            NSDictionary *groupInfo = @{@"groupId" : groupId, @"groupName" : self.groupName};
            Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(@"LIFE_COST_CHANGE_GROUP_BACK", groupInfo)
            Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(@"LIFE_COST_SELSECT_GOURP_BACK", groupInfo)
            [self popVC];
        }
    }];
}

// 加载修改分组数据
- (void)initUpdateGroupData {
    NSDictionary *params = @{@"groupName" : self.groupName, @"id" : self.groupId};
    [ZYLifeCostData lifeCostUpdateGroupWithParams:params dictBlock:^(id  _Nonnull responsObject, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            if (self.type == ZYLife_Cost_Type_AddGroup) {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"修改成功" toView:self.view.window];
            }
            NSString *groupId = responsObject[@"data"];
            NSDictionary *groupInfo = @{@"groupId" : groupId, @"groupName" : self.groupName};
            Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(@"LIFE_COST_CHANGE_GROUP_BACK", groupInfo)
            [self popVC];
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:lifeCostAddGroupMenuCellID bundle:nil] forCellReuseIdentifier:lifeCostAddGroupMenuCellID];
    [self.tableView registerNib:[UINib nibWithNibName:lifeCostAddGroupCommunityCellID bundle:nil] forCellReuseIdentifier:lifeCostAddGroupCommunityCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        
        return self.dataArray.count;
    }else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYLifeCostAddGroupMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:lifeCostAddGroupMenuCellID forIndexPath:indexPath];
        if (self.menuTagTempArray.count > 0) {
            self.selectedTagIndex = 0;
            cell.textTagCollectionView.delegate = self;
            [cell.textTagCollectionView addTags:self.menuTagArray];
            self.textTagCollectionViewHeight = cell.textTagCollectionView.contentSize.height;
            [self.menuTagTempArray removeAllObjects];
        }
        
        return cell;
    }else {
        ZYLifeCostAddGroupCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:lifeCostAddGroupCommunityCellID forIndexPath:indexPath];
        ZYLifeCostNearCommunityModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat height;
        if (self.menuArray.count > 0) {
            height = 35 + self.textTagCollectionViewHeight;
        }else {
            height = 0;
        }
        
        return height;
    }else {
        
        return kLifeCostAddGroupPlotCellHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, kScreenW - 32, 18)];
        lable.text = @"附近小区";
        lable.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        lable.font = [UIFont systemFontOfSize:14];
        [View addSubview:lable];
        
        return View;
    }else {
        
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        
        return 40;
    }else {
        
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        NSLog(@"小区 %ld", indexPath.row);
        ZYLifeCostNearCommunityModel *model = self.dataArray[indexPath.row];
        self.groupName = model.name;
        self.topView.nameTF.text = self.groupName;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    self.groupName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.menuArray.count > 0) {
        BOOL isHave = NO;
        for (NSString *str in self.menuArray) {
            if ([self.groupName isEqual:str]) {
                isHave = YES;
            }
        }
        if (!isHave) {
            ZYLifeCostAddGroupMenuCell *cell = (ZYLifeCostAddGroupMenuCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell.textTagCollectionView updateTagAtIndex:self.selectedTagIndex selected:NO];
        }
    }
}

#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    [self.view endEditing:YES];
    ZYLifeCostAddGroupMenuCell *cell = (ZYLifeCostAddGroupMenuCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (self.type == ZYLife_Cost_Type_AddHousehold) {
        if (self.selectedTagIndex != index) {
            [cell.textTagCollectionView updateTagAtIndex:self.selectedTagIndex selected:NO];
        }
        [cell.textTagCollectionView updateTagAtIndex:index selected:YES];
        self.groupName = self.menuArray[index];
        self.topView.nameTF.text = self.groupName;
    }else {
        [cell.textTagCollectionView updateTagAtIndex:index selected:NO];
    }
    self.selectedTagIndex = index;
}

#pragma mark - ZYLifeCostAddGroupBottomViewDelegate
- (void)okButtonEvent {
    
    NSLog(@"确认");
    [self.view endEditing:YES];
    if (self.groupName.length > 0) {
        if (self.type == ZYLife_Cost_Type_AddGroup) {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"添加中..."];
            [self initAddGroupData];
        }else if (self.type == ZYLife_Cost_Type_UpdateGroup) {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"修改中..."];
            [self initUpdateGroupData];
        }else if (self.type == ZYLife_Cost_Type_AddHousehold) {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"选择中..."];
            [self initAddGroupData];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入分组名称!" toView:self.view];
    }
}

@end
