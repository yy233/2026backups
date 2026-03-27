//
//  IssueHistroyListVC.m
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import "IssueHistroyListVC.h"
#import "HouseRentVC.h"
#import "IssueHistroyListHeaderView.h"
#import "IssueHistroyListVcViewModel.h"
//
#import "IssueHistroyListVcHouseTableViewCell.h"
#import "IssueHistroyListVcBuniessShopTableViewCell.h"
//
#define IssueHistroyListVcHouseTableViewCell_Identifier          @"IssueHistroyListVcHouseTableViewCell"
#define IssueHistroyListVcBuniessShopTableViewCell_Identifier    @"IssueHistroyListVcBuniessShopTableViewCell"
//
#import "HouseRentHouseDetailVc.h"
#import "HouseRentBuniessShopDetailVc.h"



@interface IssueHistroyListVC () <HouseRentHeaderViewChooseTypeDelegate>
@property (nonatomic,strong) IssueHistroyListHeaderView *headerView;
@property (nonatomic,assign) MainCellRecommendedServiceHourse_Rent_Type viewType; 
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,strong) NSMutableArray *dataSourceHouse;
@property (nonatomic,strong) NSMutableArray *dataSourceBuniessShop;
@end

@implementation IssueHistroyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最近浏览";
    self.viewType = MainCellRecommendedServiceHourse_Type_RentHouse;//房屋先出现
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setupNavigationBarWhiteStyle];
}
- (void)initView{
    [self initNavRightItem];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.headerView;
    [self addRefresh];
}
- (void)initNavRightItem{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn newAnBtnWithTextStr:@"清空"];
    [rightBtn newAnBtnWithTextColor:[UIColor blackColor]];
    [rightBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
    //
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
}
- (void)rightBtnAction{
    DLog(@"clear");
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {
        [parms setValue:@(0) forKey:@"type"];
    }else{
        [parms setValue:@(1) forKey:@"type"];
    }
    [[ToolOfNetWork sharedTools]YrequestDeletURL:URL_Rent_Look_History_list withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self initData];
             }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
 
}
#pragma mark ==
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMoreNewsData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}
#pragma mark==== mj_header
- (void)initData{
    self.pageNum = 1;
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        [self initHouseListData];
    }else{
        [self initBuniessShopListData];
    }
}
- (void)initHouseListData{
    self.pageNum = 1;
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(self.pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    NSLog(@"parms==%@",parms);
    [IssueHistroyListVcViewModel issueHistroyListWithHouseWithParm:parms withListBloclk:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
        });
        if (success) {
                self.pageNum += 1;
                self.dataSourceHouse = [NSMutableArray arrayWithArray:[IssueHistoryModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.headerView setNowBtnSelectedWithType:self.viewType];//当前商铺or租房
                    [self.tableView reloadData];
                    if (arr.count>=Y_PAGE_SIZE) {
                        self.tableView.mj_footer.hidden = NO;
                    }else{
                        self.tableView.mj_footer.hidden = YES;
                    }
                });
        }else{
            //失败--用商铺的显示
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.dataSourceBuniessShop.count>0) {//商铺有数据的情况
                    self.viewType = MainCellRecommendedServiceHourse_Type_BusinessShop;
                  [self.headerView setNowBtnSelectedWithType:self.viewType];//当前商铺or租房
                }
            });
        }
    }];
}
- (void)initBuniessShopListData{
    self.pageNum = 1;
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(self.pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [IssueHistroyListVcViewModel issueHistroyListWithBuniessShopWithParm:parms withListBloclk:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
        });
        if (success) {
                self.pageNum += 1;
                self.dataSourceBuniessShop = [NSMutableArray arrayWithArray:[IssueHistoryModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.headerView setNowBtnSelectedWithType:self.viewType];//当前商铺or租房
                    [self.tableView reloadData];
                    if (arr.count>=Y_PAGE_SIZE) {
                        self.tableView.mj_footer.hidden = NO;
                    }else{
                        self.tableView.mj_footer.hidden = YES;
                    }
                });
        }else{
            //失败--用租房的显示
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.dataSourceHouse.count>0) {//租房有数据的情况下
                    self.viewType = MainCellRecommendedServiceHourse_Type_RentHouse;
                  [self.headerView setNowBtnSelectedWithType:self.viewType];//当前商铺or租房
                }
            });
        }
    }];
}
#pragma mark==== mj_footer
- (void)footerLoadMoreNewsData{
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        [self footerUpDataHouse];
    }else{
        [self footerUpDataBuniessShop];

    }
}
- (void)footerUpDataHouse{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(self.pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [IssueHistroyListVcViewModel issueHistroyListWithHouseWithParm:parms withListBloclk:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
        if (success) {
            if (arr.count>0) {
                self.pageNum += 1;
                [self.dataSourceHouse addObjectsFromArray:[NSMutableArray arrayWithArray:[IssueHistoryModel mj_objectArrayWithKeyValuesArray:arr]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    if (arr.count>=Y_PAGE_SIZE) {
                        self.tableView.mj_footer.hidden = NO;
                    }else{
                        self.tableView.mj_footer.hidden = YES;
                    }
                });
            }else{//0
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableView.mj_footer.hidden = YES;
                });
            }
        }
    }];
    
}
- (void)footerUpDataBuniessShop{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(self.pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [IssueHistroyListVcViewModel issueHistroyListWithBuniessShopWithParm:parms withListBloclk:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
        if (success) {
            if (arr.count>0) {
                self.pageNum += 1;
                [self.dataSourceBuniessShop addObjectsFromArray:[NSMutableArray arrayWithArray:[IssueHistoryModel mj_objectArrayWithKeyValuesArray:arr]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    if (arr.count>=Y_PAGE_SIZE) {
                        self.tableView.mj_footer.hidden = NO;
                    }else{
                        self.tableView.mj_footer.hidden = YES;
                    }
                });
            }else{//0
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableView.mj_footer.hidden = YES;
                });
               
            }
        }
    }];
}

#pragma mark === ChooseType
- (void)houseRentHeaderViewChooseTypeSubBtnTouchChooseType:(MainCellRecommendedServiceHourse_Rent_Type)type{
    self.viewType  = type;
    NSLog(@"切换 %lu",(unsigned long)type);
    Y_SVP_SHOW_MES_IsDealing
    [self initData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark ===
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        return self.dataSourceHouse.count;
    }else{
        return self.dataSourceBuniessShop.count;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        return [UIView new];
    }else{
        return [UIView new];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        IssueHistroyListVcHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueHistroyListVcHouseTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueHistroyListVcHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHistroyListVcHouseTableViewCell_Identifier];
        }
        if (self.dataSourceHouse.count>=indexPath.row+1) {
            cell.historyhouseCellmodel = self.dataSourceHouse[indexPath.row];
        }
        return cell;
    }else{   //商铺
        IssueHistroyListVcBuniessShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueHistroyListVcBuniessShopTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueHistroyListVcBuniessShopTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHistroyListVcBuniessShopTableViewCell_Identifier];
        }
        if (self.dataSourceBuniessShop.count>=indexPath.row+1) {
            cell.historyBuniessShopCellmodel = self.dataSourceBuniessShop[indexPath.row];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];   //详情
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        IssueHistoryModel *model = self.dataSourceHouse[indexPath.row];
        HouseRentHouseDetailVc *houseDetailVc = [[HouseRentHouseDetailVc alloc]init];
        houseDetailVc.IDNum = model.houseId;
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self pushVc:houseDetailVc];
    }else{
        IssueHistoryModel *model = self.dataSourceBuniessShop[indexPath.row];
        HouseRentBuniessShopDetailVc *buinessShopDetailVc = [[HouseRentBuniessShopDetailVc alloc]init];
        buinessShopDetailVc.IDNum = model.houseId;
        //     [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self pushVc:buinessShopDetailVc];
    }
}
#pragma mark ==
 
- (IssueHistroyListHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[IssueHistroyListHeaderView alloc]initWithFrame:CGRectZero];
        _headerView.delegate = self;
    }
    return _headerView;
}
 
#pragma mark ==
- (NSMutableArray *)dataSourceHouse{
    if (!_dataSourceHouse) {
        _dataSourceHouse = [NSMutableArray array];
    }
    return _dataSourceHouse;
}
- (NSMutableArray *)dataSourceBuniessShop{
    if (!_dataSourceBuniessShop) {
        _dataSourceBuniessShop = [NSMutableArray array];
    }
    return _dataSourceBuniessShop;
}
@end
