//
//  XianjingJuanVC.m
//  Community
//
//  Created by 余莹 on 2021/2/4.
// 20210608master1

#import "XianjingJuanVC.h"
#import "ZYXianjingJuanCell.h"
#import "ZYXianjingJuanListModel.h"

#define  XianjingJuanCell_Identifier    @"ZYXianjingJuanCell"

@interface XianjingJuanVC ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XianjingJuanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [UIView new];
    self.title = @"现金劵";
    [self setupNavigationBarWhiteStyle];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = Y_RGBA(245, 245, 245, 1);

    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf initTicketsData];
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    // 触底加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf initTicketsData];
        weakSelf.tableView.mj_header.hidden = YES;
    }];
    // 自动刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarWhiteStyle];
}

#pragma mark - 加载数据
- (void)initTicketsData {
    
    NSDictionary *params = @{@"page" : @(self.currentPage), @"size" : @(10)};
    [[ToolOfNetWork sharedTools] YrequestPostURLNoMainQueueWithBodyNotParms:URL_Post_Tickets withBody:params.mutableCopy finished:^(id responsObject, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                if (self.dataSourceArr.count > 0) {
                    [self.dataSourceArr removeAllObjects];
                }
                ZYXianjingJuanListModel *model = [ZYXianjingJuanListModel yy_modelWithJSON:responsObject];
                [self.dataSourceArr addObjectsFromArray:model.data.records];
                // 判断数据是否加载完了
                if (self.dataSourceArr.count >= model.data.total) {
                    // 表示没有数据可以请求，设置UITableView footer的状态
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    // 重置提示加载更多数据
                    [self.tableView.mj_footer resetNoMoreData];
                }
                // 刷新tableView
                [self.tableView reloadData];
            }else {
                if (self.currentPage > 1) {
                    self.currentPage -= 1;
                }
                if (self.currentPage == 1) {
                    self.tableView.mj_footer.hidden = YES;
                }
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            if (self.currentPage > 1) {
                self.currentPage -= 1;
            }
            if (self.currentPage == 1) {
                self.tableView.mj_footer.hidden = YES;
            }
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return   self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;//145
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZYXianjingJuanCell *cell = [tableView dequeueReusableCellWithIdentifier:XianjingJuanCell_Identifier];
    if (!cell) {
        cell = [[ZYXianjingJuanCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:XianjingJuanCell_Identifier];
    }
    cell.model = self.dataSourceArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZYXianjingJuanListDataRecordsModel *model = self.dataSourceArr[indexPath.row];
    if (model.status == 0) {
        NSLog(@"去使用 %ld", indexPath.section);
    }
}

@end
