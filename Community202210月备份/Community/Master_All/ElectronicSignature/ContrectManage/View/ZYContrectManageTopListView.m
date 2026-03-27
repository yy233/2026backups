//
//  ZYContrectManageTopListView.m
//  Community
//
//  Created by ZY on 2021/8/30.
//

#import "ZYContrectManageTopListView.h"
#import "ZYContrectManageTopListCell.h"

static NSString * const contrectManageTopListCellID = @"ZYContrectManageTopListCell";
#define kContrectManageTopListCellHeight 40

@interface ZYContrectManageTopListView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation ZYContrectManageTopListView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self customTableView];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contrectManageTopListViewTap)]];
}

// 设置数据
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    if (self.dataSourceArray.count > 0) {
        [self.dataSourceArray removeAllObjects];
    }
    [self.dataSourceArray addObjectsFromArray:_dataArray];
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    
    return _dataSourceArray;
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_D001534;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYContrectManageTopListCell" bundle:nil] forCellReuseIdentifier:contrectManageTopListCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYContrectManageTopListCell *cell = [tableView dequeueReusableCellWithIdentifier:contrectManageTopListCellID forIndexPath:indexPath];
    ZYContrectManageTopListModel *model = self.dataSourceArray[indexPath.row];
    cell.model = model;
    cell.contentV.tag = 200 + indexPath.row;
    [cell.contentV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTap:)]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kContrectManageTopListCellHeight;
}

#pragma mark - 点击事件
- (void)contrectManageTopListViewTap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(contrectManageTopListViewTapEvent)]) {
        [self.delegate contrectManageTopListViewTapEvent];
    }
}

- (void)contentViewTap:(UITapGestureRecognizer *)tap {
    
    NSInteger index = tap.view.tag - 200;
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentViewTapWithIndex:)]) {
        [self.delegate contentViewTapWithIndex:index];
    }
}

@end
