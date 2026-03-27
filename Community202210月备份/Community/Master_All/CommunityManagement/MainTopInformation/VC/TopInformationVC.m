//
//  TopInformationVC.m
//  Community
//  顶部总消息
//  Created by 余莹 on 2020/12/14.
//

#import "TopInformationVC.h"

#import "TopInformationModel.h"
#import "TopInformationTableViewCell.h"
#define TopInformationTableViewCell_Identifier @"TopInformationTableViewCell"
#define TopInformationCell_H 72

@interface TopInformationVC ()
@property (nonatomic,assign) NSInteger pageNum;

@end

@implementation TopInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";//紧急消息 通知 list
    self.pageNum = 1;
//    [self initRightNavItem];//1019 社区消息总列表暂时隐藏清除按钮 21主页顶部消息跳转走通知消息 不走本社区总消息
    [self addRefresh];
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.tableView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
//        [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
//    });
//}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}
- (void)initRightNavItem{
    UIButton *cleanItem = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanItem.titleLabel.font = [UIFont systemFontOfSize:12];
    [cleanItem setTitle:@"清除未读" forState:UIControlStateNormal];
    [cleanItem setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    cleanItem.bounds = CGRectMake(0 , 0, 24, 24);
    [cleanItem addTarget:self action:@selector(cleanItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cleanItemBar = [[UIBarButtonItem alloc]initWithCustomView:cleanItem];
    [self.navigationItem setRightBarButtonItem:cleanItemBar animated:YES];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMoreNewsData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}

- (void)initData{//主页紧急消息 20条数据
    self.pageNum = 1;
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_MAIN_TOP_MESSAGE withParams:@{@"page":@(self.pageNum),@"size":@(Y_PAGE_SIZE)}.mutableCopy finished:^(id responsObject, NSError *error) {
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_MAIN_TOP_MESSAGE withParams:@{@"page":@(self.pageNum),@"size":@(Y_PAGE_SIZE)}.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.pageNum += 1;
                NSArray *arr = [NSArray arrayWithArray:Y_ResponsObject_dataArr];
                self.dataSourceArr = [NSMutableArray arrayWithArray:[TopInformationModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    if (arr.count>=Y_PAGE_SIZE) {
                        self.tableView.mj_footer.hidden = NO;
                    }else{
                        self.tableView.mj_footer.hidden = YES;
                    }
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
- (void)footerLoadMoreNewsData{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    self.pageNum = 1;
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_MAIN_TOP_MESSAGE withParams:@{@"page":@(self.pageNum),@"size":@(Y_PAGE_SIZE)}.mutableCopy finished:^(id responsObject, NSError *error) {
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_MAIN_TOP_MESSAGE withParams:@{@"page":@(self.pageNum),@"size":@(Y_PAGE_SIZE)}.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_footer endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.pageNum += 1;
                NSArray *arr = [NSArray arrayWithArray:Y_ResponsObject_dataArr];
                self.dataSourceArr = [NSMutableArray arrayWithArray:[TopInformationModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    if (arr.count>=Y_PAGE_SIZE) {
                        self.tableView.mj_footer.hidden = NO;
                    }else{
                        self.tableView.mj_footer.hidden = YES;
                    }
                });
            }else{
                self.pageNum -= 1;
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            self.pageNum -= 1;
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark ---cleanItemAction
- (void)cleanItemAction:(UIBarButtonItem *)sender{
    DLog(@"清除未读");
//    []
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopInformationTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:TopInformationTableViewCell_Identifier];
    if (!cell) {
        cell = [[TopInformationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopInformationTableViewCell_Identifier];
    }
    cell.model = self.dataSourceArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TopInformationCell_H;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MoreUrgentListVC *communityInfoListVc = [[MoreUrgentListVC alloc]init];//顶部小区cell 对应消息的列表vc
    TopInformationModel *model = self.dataSourceArr[indexPath.row];
    communityInfoListVc.isTopInfoVcDetailListVc  = YES;//社区消息列表对应的小区ID做请求 no则内部用当前社区id即可 不需要传入cid
    communityInfoListVc.communityId = model.id;
    [self.navigationController pushViewController:communityInfoListVc animated:YES];
}

@end
