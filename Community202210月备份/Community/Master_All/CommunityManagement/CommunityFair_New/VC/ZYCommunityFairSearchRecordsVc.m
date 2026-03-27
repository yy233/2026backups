//
//  ZYCommunityFairSearchRecordsVc.m
//  Community
//
//  Created by ZY on 2022/6/9.
//

#import "ZYCommunityFairSearchRecordsVc.h"
#import "ZYCommunityFairComprehensiveSearchVc.h"
#import "ZYCommunityFairSearchRecordsTopView.h"
#import "ZYCommunityFairSearchRecordsCell.h"

static NSString * const ZYCommunityFairSearchRecordsCellID = @"ZYCommunityFairSearchRecordsCell";
#define kZYCommunityFairSearchRecordsTopViewHeight status_height+45
#define kZYCommunityFairSearchRecordsCellHeight 57

@interface ZYCommunityFairSearchRecordsVc () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, ZYCommunityFairSearchRecordsTopViewDelegate, TTGTextTagCollectionViewDelegate>

@property (nonatomic, strong) ZYCommunityFairSearchRecordsTopView *topView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat textTagCollectionViewRecordHeight;

@property (nonatomic, strong) NSMutableArray *recordArray;

@property (nonatomic, strong) NSMutableArray *recordTagArray;

@property (nonatomic, assign) CGFloat textTagCollectionViewHotHeight;

@property (nonatomic, strong) NSMutableArray *hotArray;

@property (nonatomic, strong) NSMutableArray *hotTagArray;

// 标签相关配置
@property (nonatomic, strong) TTGTextTagStringContent *content;

@property (nonatomic, strong) TTGTextTagStyle *style;

@end

@implementation ZYCommunityFairSearchRecordsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self hiddenNavigationBar];
    [self setUI];
    [self customTableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self hiddenNavigationBar];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kZYCommunityFairSearchRecordsTopViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYCommunityFairSearchRecordsTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairSearchRecordsTopView" owner:nil options:nil].lastObject;
        _topView.delegate = self;
    }
    
    return _topView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (NSMutableArray *)recordArray {
    if (!_recordArray) {
        _recordArray = [NSMutableArray array];
    }
    
    return _recordArray;
}

- (NSMutableArray *)recordTagArray {
    if (!_recordTagArray) {
        _recordTagArray = [NSMutableArray array];
    }
    
    return _recordTagArray;
}

- (NSMutableArray *)hotArray {
    if (!_hotArray) {
        _hotArray = [NSMutableArray array];
    }
    
    return _hotArray;
}

- (NSMutableArray *)hotTagArray {
    if (!_hotTagArray) {
        _hotTagArray = [NSMutableArray array];
    }
    
    return _hotTagArray;
}

- (TTGTextTagStringContent *)content {
    if (!_content) {
        _content = [[TTGTextTagStringContent alloc] init];
        _content.textFont = [UIFont systemFontOfSize:14];
        _content.textColor = [ZYThemeManager shareManager].titleThemeColor;
    }
    
    return _content;
}

- (TTGTextTagStyle *)style {
    if (!_style) {
        _style = [[TTGTextTagStyle alloc] init];
        _style.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
        _style.shadowColor = [UIColor clearColor];
        _style.borderWidth = 0;
        _style.borderColor = [UIColor clearColor];
        _style.cornerRadius = 18;
        _style.extraSpace = CGSizeMake(30, 0);
        _style.exactHeight = 35;
        _style.maxWidth = 120;
    }
    
    return _style;
}

#pragma mark - 加载数据
- (void)initData {
    [self.recordArray addObjectsFromArray:@[@"华为", @"大疆", @"电瓶车电瓶车电瓶车电瓶车电瓶车", @"苹果7", @"三星s10", @"荣耀play", @"洗衣机", @"ps4"]];
    for (int i = 0; i < self.recordArray.count; i++) {
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = self.recordArray[i];
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.style = self.style;
        [self.recordTagArray addObject:tag];
    }
    
    [self.hotArray addObjectsFromArray:@[@"华为", @"大疆", @"电瓶车", @"苹果7", @"三星s10", @"荣耀play", @"洗衣机", @"ps4", @"电视机", @"空调", @"冰箱"]];
    for (int i = 0; i < self.hotArray.count; i++) {
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = self.hotArray[i];
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.style = self.style;
        [self.hotTagArray addObject:tag];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYCommunityFairSearchRecordsCellID bundle:nil] forCellReuseIdentifier:ZYCommunityFairSearchRecordsCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.recordArray.count > 0) {
        
        return 2;
    }else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYCommunityFairSearchRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCommunityFairSearchRecordsCellID forIndexPath:indexPath];
    if (self.recordArray.count > 0) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"历史记录";
            cell.deleteButton.hidden = NO;
            [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            cell.textTagCollectionView.tag = 200;
            [cell.textTagCollectionView removeAllTags];
            [cell.textTagCollectionView addTags:self.recordTagArray];
            cell.textTagCollectionView.delegate = self;
            self.textTagCollectionViewRecordHeight = cell.textTagCollectionView.contentSize.height;
        }else {
            cell.titleLabel.text = @"推荐搜索";
            cell.deleteButton.hidden = YES;
            cell.textTagCollectionView.tag = 300;
            [cell.textTagCollectionView removeAllTags];
            [cell.textTagCollectionView addTags:self.hotTagArray];
            cell.textTagCollectionView.delegate = self;
            self.textTagCollectionViewHotHeight = cell.textTagCollectionView.contentSize.height;
        }
    }else {
        cell.titleLabel.text = @"推荐搜索";
        cell.deleteButton.hidden = YES;
        cell.textTagCollectionView.tag = 500;
        [cell.textTagCollectionView removeAllTags];
        [cell.textTagCollectionView addTags:self.hotTagArray];
        cell.textTagCollectionView.delegate = self;
        self.textTagCollectionViewHotHeight = cell.textTagCollectionView.contentSize.height;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.recordArray.count > 0) {
        if (indexPath.row == 0) {
            
            return kZYCommunityFairSearchRecordsCellHeight + self.textTagCollectionViewRecordHeight;
        }else {
            
            return kZYCommunityFairSearchRecordsCellHeight + self.textTagCollectionViewHotHeight;
        }
    }else {
        
        return kZYCommunityFairSearchRecordsCellHeight + self.textTagCollectionViewHotHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    if (self.recordArray.count > 0) {
        if (textTagCollectionView.tag == 200) {
            NSString *searchStr = self.recordArray[index];
            self.topView.searchTF.text = searchStr;
        }else if (textTagCollectionView.tag == 300) {
            NSString *searchStr = self.hotArray[index];
            self.topView.searchTF.text = searchStr;
        }
    }else {
        if (textTagCollectionView.tag == 500) {
            NSString *searchStr = self.hotArray[index];
            self.topView.searchTF.text = searchStr;
        }
    }
}

#pragma mark - ZYCommunityFairSearchRecordsTopViewDelegate
- (void)backButtonEvent {
    [self popVC];
}

- (void)searchButtonEvent {
    NSLog(@"搜索");
    ZYCommunityFairComprehensiveSearchVc *vc = [[ZYCommunityFairComprehensiveSearchVc alloc] init];
    [self pushVc:vc];
}

#pragma mark - 处理点击事件
- (void)deleteButtonClicked {
    [self.recordArray removeAllObjects];
    [self.recordTagArray removeAllObjects];
    [self.tableView reloadData];
}

@end
