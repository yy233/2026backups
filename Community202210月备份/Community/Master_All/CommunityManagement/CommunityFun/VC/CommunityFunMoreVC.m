//
//  CommunityFunMoreVC.m
//  Community
//
//  Created by 余莹 on 2020/12/22.
//

#import "CommunityFunMoreVC.h"
#import "CommunityFunMoreVCTableViewCell.h"
#import "CommunityFunDetialVC.h"
#define CommunityFunMoreVCTableViewCell_Identifier @"CommunityFunMoreVCTableViewCell"
#define Cell_Height 240
@interface CommunityFunMoreVC ()
@property (nonatomic,assign) NSInteger pageNum;
@end

@implementation CommunityFunMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生活趣事";//列表页
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addRefresh];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMoreNewsData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}

- (void)initData{//社区趣事
    self.pageNum = 1;
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [CommunityFunListViewModel comunityFunListInitWithListBlock:^(BOOL success, NSArray * arr, NSInteger total) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
        });
        if (success) {
            self.pageNum += 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (arr.count<PageSize_CommunityFunList) {
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    self.tableView.mj_footer.hidden = NO;
                }
            });
            self.dataSourceArr = [NSMutableArray arrayWithArray:[CommunityFunModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            self.pageNum = 1;
        }
    }];
    
}
- (void)footerLoadMoreNewsData{
    NSLog(@"------------footerRefres------------");
    [self bottmNewsDataMore];
}
- (void)bottmNewsDataMore{//社区趣事
    [CommunityFunListViewModel  comunityFunListWithPageNum:self.pageNum UpdateWithListBlock:^(BOOL success, NSArray * arr, NSInteger total) {//total数据有bug 用arr。count
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
        if (success) {
            self.pageNum += 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (arr.count<PageSize_CommunityFunList) {
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    self.tableView.mj_footer.hidden = NO;
                }
            });
            [self.dataSourceArr addObjectsFromArray:[CommunityFunModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            self.pageNum -= 1;
        }
    }];
    
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Cell_Height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunityFunMoreVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityFunMoreVCTableViewCell_Identifier];
    if (!cell) {
        cell = [[CommunityFunMoreVCTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CommunityFunMoreVCTableViewCell_Identifier];
    }
    cell.model = self.dataSourceArr[indexPath.row];
    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommunityFunModel *model = self.dataSourceArr[indexPath.row];
    CommunityFunDetialVC *detailVc = [[CommunityFunDetialVC alloc]init];
    detailVc.id = model.id;
    [self.navigationController pushViewController:detailVc animated:YES];
}
 

@end
