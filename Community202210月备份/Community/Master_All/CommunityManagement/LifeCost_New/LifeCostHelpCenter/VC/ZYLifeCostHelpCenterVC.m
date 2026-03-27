//
//  ZYLifeCostHelpCenterVC.m
//  Community
//
//  Created by ZY on 2022/1/4.
//

#import "ZYLifeCostHelpCenterVC.h"
#import "ZYLifeCostHelpCenterSearchVC.h"
#import "ZYLifeCostHelpCenterDetailVC.h"
#import "ZYLifeCostHelpCenterSearchView.h"
#import "ZYLifeCostHelpCenterTitleView.h"
#import "ZYLifeCostHelpCenterMenuCell.h"
#import "ZYLifeCostHelpCenterContentCell.h"

static NSString * const lifeCostHelpCenterMenuCellID = @"ZYLifeCostHelpCenterMenuCell";
static NSString * const lifeCostHelpCenterContentCellID = @"ZYLifeCostHelpCenterContentCell";
#define kLifeCostHelpCenterTitleViewHeight 35

@interface ZYLifeCostHelpCenterVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TTGTextTagCollectionViewDelegate, ZYLifeCostHelpCenterSearchViewDelegate>

@property (nonatomic, strong) ZYLifeCostHelpCenterSearchView *searchView;

@property (nonatomic, strong) ZYLifeCostHelpCenterTitleView *titleView;

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

// 是否隐藏热门标题
@property (nonatomic, assign) BOOL isHiddenHotTitle;

// 搜索内容
@property (nonatomic, copy) NSString *searchStr;

@end

@implementation ZYLifeCostHelpCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助中心";
    [self setUI];
    [self customTableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)setUI {
    [self.view addSubview:self.searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_searchView.superview);
        make.height.offset(50 + button_bottom_height);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_tableView.superview);
        make.top.equalTo(_searchView.mas_bottom);
    }];
}

#pragma mark - 懒加载
- (ZYLifeCostHelpCenterSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[NSBundle mainBundle] loadNibNamed:@"ZYLifeCostHelpCenterSearchView" owner:nil options:nil].lastObject;
        _searchView.delegate = self;
        _searchView.searchTF.delegate = self;
    }
    
    return _searchView;
}

- (ZYLifeCostHelpCenterTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[NSBundle mainBundle] loadNibNamed:@"ZYLifeCostHelpCenterTitleView" owner:nil options:nil].lastObject;
    }
    
    return _titleView;
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
        _style.extraSpace = CGSizeMake(20, 0);
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
        _selectedStyle.extraSpace = CGSizeMake(20, 0);
        _selectedStyle.exactHeight = 32;
    }
    
    return _selectedStyle;
}

#pragma mark - 加载数据
- (void)initData {
    [self.menuArray addObjectsFromArray:@[@"生活缴费", @"一键报修", @"房屋租赁", @"社区集市", @"注册登录", @"实名认证"]];
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
    [self.dataArray addObjectsFromArray:@[@"", @"", @"", @"", @""]];
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:lifeCostHelpCenterMenuCellID bundle:nil] forCellReuseIdentifier:lifeCostHelpCenterMenuCellID];
    [self.tableView registerNib:[UINib nibWithNibName:lifeCostHelpCenterContentCellID bundle:nil] forCellReuseIdentifier:lifeCostHelpCenterContentCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }else {
        
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYLifeCostHelpCenterMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:lifeCostHelpCenterMenuCellID forIndexPath:indexPath];
        if (self.menuTagTempArray.count > 0) {
            self.selectedTagIndex = -1;
            cell.textTagCollectionView.delegate = self;
            [cell.textTagCollectionView addTags:self.menuTagArray];
            self.textTagCollectionViewHeight = cell.textTagCollectionView.contentSize.height;
            [self.menuTagTempArray removeAllObjects];
        }
        
        return cell;
    }else {
        ZYLifeCostHelpCenterContentCell *cell = [tableView dequeueReusableCellWithIdentifier:lifeCostHelpCenterContentCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
//    ZYLifeCostHelpCenterContentCell *cell = (ZYLifeCostHelpCenterContentCell *)currentCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return self.textTagCollectionViewHeight;
    }else {
        
        return [tableView fd_heightForCellWithIdentifier:lifeCostHelpCenterContentCellID configuration:^(ZYLifeCostHelpCenterContentCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return [[UIView alloc] init];
    }else {
        
        if (!self.isHiddenHotTitle) {
            
            return self.titleView;
        }else {
            
            return [[UIView alloc] init];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return 0;
    }else {
        if (!self.isHiddenHotTitle) {
            
            return kLifeCostHelpCenterTitleViewHeight;
        }else {
            
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        
        return 0;
    }else {
        
        return 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        NSLog(@"%ld", indexPath.row);
        ZYLifeCostHelpCenterDetailVC *vc = [[ZYLifeCostHelpCenterDetailVC alloc] init];
        vc.titleStr = @"如何绑定水电气缴费？";
        vc.urlStr = @"http://www.zhsj.co";
        [self pushVc:vc];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    self.searchStr = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self searchButtonEvent];
    
    return YES;
}

#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    ZYLifeCostHelpCenterMenuCell *cell = (ZYLifeCostHelpCenterMenuCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (self.selectedTagIndex == index) {
        [cell.textTagCollectionView updateTagAtIndex:index selected:NO];
        self.selectedTagIndex = -1;
    }else {
        [cell.textTagCollectionView updateTagAtIndex:self.selectedTagIndex selected:NO];
        [cell.textTagCollectionView updateTagAtIndex:index selected:YES];
        self.selectedTagIndex = index;
    }
    
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    if (self.selectedTagIndex == -1) {
        self.isHiddenHotTitle = NO;
        [self.dataArray addObjectsFromArray:@[@"", @"", @"", @"", @""]];
    }else {
        self.isHiddenHotTitle = YES;
        [self.dataArray addObjectsFromArray:@[@"", @"", @""]];
    }
    [self.tableView reloadData];
}

#pragma mark - ZYLifeCostHelpCenterSearchViewDelegate
- (void)searchButtonEvent {
    
    NSLog(@"搜索");
    [self.view endEditing:YES];
    NSString *tempSearchStr = [self.searchStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (tempSearchStr.length > 0) {
        ZYLifeCostHelpCenterSearchVC *vc = [[ZYLifeCostHelpCenterSearchVC alloc] init];
        vc.searchStr = tempSearchStr;
        [self pushVc:vc];
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入搜索内容!" toView:self.view];
    }
}

@end
