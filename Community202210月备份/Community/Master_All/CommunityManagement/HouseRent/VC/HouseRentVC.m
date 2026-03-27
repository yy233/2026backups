//
//  HouseRentVC.m
//  Community
//
//  Created by 余莹 on 2020/12/29.
//。出租

#import "HouseRentVC.h"
#import "HouseRentHouseDetailVc.h"
#import "HouseRentBuniessShopDetailVc.h"
//view
#import "HouseRentNavSearchView.h"
#import "HouseRentHeaderView.h"
//#import "HouseRentSectionHeaderView.h"
#import "HouseBuniesShopSectionHeaderView.h"
#import "HouseRentHouseTableViewCell.h"
#import "HouseRentBuniessShopTableViewCell.h"

#import "HouseRentChooseHouseTypeView.h"
#import "HouseRentChooseHouseMoreView.h"
//view model
#import "HouseRentVCListViewModel.h"
#import "HouseRentVcAllQueryTypesChooseViewModel.h"
//query model
#import "HouseRentListVcHouseQueryTypesModel.h"
#import "HouseRentListVcBuniessShopQueryTypesModel.h"
//
#define HouseRentHouseTableViewCell_Identifier          @"HouseRentHouseTableViewCell"
#define HouseRentBuniessShopTableViewCell_Identifier    @"HouseRentBuniessShopTableViewCell"


//


#define BuniessRentQuyu_SectionNum 0
#define BuniessRentMoney_SectionNum 1
#define BuniessRentAreaNum_SectionNum 2
#define HouseRentHuXinNum_SectionNum 2
#define BuniessRentMore_SectionNum 3
#import "BuniessShopRentMoreShaiXuanModel.h"
#import "BuniessShopOrHouseRentNomalShaiXuanModel.h"

#define Cell_H  100
#define Cell_headerView_H  50
#define Cell_sectionheaderView_H  30
 
@interface HouseRentVC () <HouseRentHeaderViewChooseTypeDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,HouseRentChooseHouseTypeViewOkBtnDelegate,WMZDropMenuDelegate>

@property (nonatomic,strong) HouseRentNavSearchView *navSearchView;
@property (nonatomic,strong) HouseRentHeaderView *headerViewOfBuniessShopAndHouse;//商铺｜租房 header
//@property (nonatomic,strong) HouseRentSectionHeaderView *sectionHeaderViewHouse;//区域租金户型更多view
//@property (nonatomic,strong) HouseBuniesShopSectionHeaderView *sectionHeaderViewBuniess;//区域租金 面积 更多view
@property (nonatomic,strong) HouseRentChooseHouseTypeView *chooseHouseTypePickView;//户型pick
//@property (nonatomic,strong) HouseRentChooseHouseMoreView *chooseHouseMoreView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSString *searchTextStr;
@property (nonatomic,strong) NSMutableArray *dataSourceHouse;
@property (nonatomic,strong) NSMutableArray *dataSourceBuniessShop;
@property (nonatomic,strong) HouseRentListVcHouseQueryTypesModel *queryModelHouse;
@property (nonatomic,strong) HouseRentListVcBuniessShopQueryTypesModel *queryModelBuniessShop;
@property (nonatomic,assign) NSInteger pageNum;
//

@property (nonatomic,strong) NSMutableArray *houseSaveMoreSelectedModelArr;

#pragma mark == 商铺
//商铺筛选UI
@property (nonatomic,strong) WMZDropMenuParam *param;
@property (nonatomic,strong) WMZDropDownMenu *menu ;
//商铺筛选保存的原版数据
@property (nonatomic,strong) NSMutableArray *saveBuniessQuyuDataSourceModelArr;
@property (nonatomic,strong) NSMutableArray *saveBuniessMoneyDataSourceModelArr;
@property (nonatomic,strong) NSMutableArray *saveBuniessAreaNumDataSourceModelArr;
@property (nonatomic,strong) NSMutableDictionary *saveBuniessMoreDataSourceDic;
@property (nonatomic,strong) NSMutableArray *saveBuniessMoreDataSourceModelArrUseChoose;//用于选择时的源本数据结构为arr[arrs]
//商铺筛选文本类型数据
//@"区域",@"租金", @"面积", @"更多", nil];
@property (nonatomic,strong)  NSArray *saixuanBuniessTopTitleStrArr;
@property (nonatomic,strong)  NSMutableArray *shaixuanBuniessQuyuDataSourceArr;
@property (nonatomic,strong)  NSMutableArray *shaixuanBuniessMoneyDataSourceArr;
@property (nonatomic,strong)  NSMutableArray *shaixuanBuniessAreaNumDataSourceArr;
@property (nonatomic,strong)  NSMutableArray *saixuanBuniessMoreDataTitleStrSourceArr;//title str
@property (nonatomic,strong)  NSMutableArray *shaixuanBuniessMoreDataSourceArr;//文本 纯文本的arr
#pragma mark == 房屋
@property (nonatomic,strong) NSMutableArray *saveHouseQuyuDataSourceModelArr;
@property (nonatomic,strong) NSMutableArray *saveHouseMoneyDataSourceModelArr;
@property (nonatomic,strong) NSMutableArray *saveHouseHuxinDataSourceModelArr;//户型 不走下拉框 走选择器
@property (nonatomic,strong) NSMutableDictionary *saveHouseMoreDataSourceDic;
 
//房屋筛选所用带有文本类型的数据
//@"区域",@"租金", @"户型", @"更多", nil];
@property (nonatomic,strong)  NSArray *saixuanHouseTopTitleStrArr;
@property (nonatomic,strong)  NSMutableArray *shaixuanHouseQuyuDataSourceArr;
@property (nonatomic,strong)  NSMutableArray *shaixuanHouseMoneyDataSourceArr;
@property (nonatomic,strong)  NSMutableArray *shaixuanHouseHuXingNumDataSourceArr;//户型数量
@property (nonatomic,strong)  NSMutableArray *shaixuanHouseMoreDataTitleStrSourceArr;//title str
@property (nonatomic,strong)  NSMutableArray *shaixuanHouseMoreDataSourceArr;//带有文本name 和model 的 键值对
@end

@implementation HouseRentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTextStr = @"";
    [self initView];//nav+列表相关view
    [self initBuniessShopAndHouseShaiXuanChooseMenu];//筛选view
    [self addRefresh];
    Y_SVP_SHOW_MES_IsDealing
    [self initAllData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initAllData)];//刷新时要做列表数据和筛选数据两种
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMoreNewsData)];//footer加载时只做列表数据
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}
#pragma mark ===== 列表数据
#pragma mark==== mj_header
- (void)initAllData{
    [self initData];
    [self initShaiXuanData];
}
- (void)initShaiXuanData{
    //
    [self initWithBuniessShopMoreOptionData];//商铺筛选
    //
    [self initWithHouseMoreOptionData];//房屋筛选
}
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
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:[self.queryModelHouse mj_keyValues]];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(self.pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [parms setValue:query forKey:@"query"];
    NSLog(@"parms==%@",parms);
    [HouseRentVCListViewModel getRentVcHouseListArrWithParm:parms withBlock:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
        });
        if (success) {
                self.pageNum += 1;
                self.dataSourceHouse = [NSMutableArray arrayWithArray:[HouseRentListVcHouseCellModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.headerViewOfBuniessShopAndHouse setNowBtnSelectedWithType:self.viewType];//当前商铺or租房
                    [self.tableView reloadData];
//                    [self.menu updateUI];//成功 不做更新 普通切换的位置会更 加了会影响toptitle 失败时切换才需要再次调用刷新
//                    [self buniessAndHouseNamalShaiXuanClearning];//清空原所有筛选条件 成功才清掉 ?0715 成功后清空筛选条件 bug不做清空
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
                    [self.headerViewOfBuniessShopAndHouse setNowBtnSelectedWithType:self.viewType];//当前商铺or租房
                    [self.menu updateUI];//刷新筛选项目列表数 //数据有误回到另一个有数据的位置时 更新筛选UI数据
                }
            });
        }
    }];
}
- (void)initBuniessShopListData{
    self.pageNum = 1;
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:[self.queryModelBuniessShop mj_keyValues]];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(self.pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [parms setValue:query forKey:@"query"]; 
    [HouseRentVCListViewModel getRentVcBuniessShopListArrWithParm:parms WithBlock:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
        });
        if (success) {
                self.pageNum += 1;
                self.dataSourceBuniessShop = [NSMutableArray arrayWithArray:[HouseRentListVcBuniessShopCellModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.headerViewOfBuniessShopAndHouse setNowBtnSelectedWithType:self.viewType];//当前商铺or租房
                    [self.tableView reloadData];
//                    [self.menu updateUI];//成功 不做更新 普通切换的位置会更 加了会影响toptitle
//                    [self buniessAndHouseNamalShaiXuanClearning];//清空原所有筛选条件 成功才清掉?0715 成功后清空筛选条件 bug不做清空
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
                   [self.headerViewOfBuniessShopAndHouse setNowBtnSelectedWithType:self.viewType];//当前商铺or租房
                    [self.menu updateUI];//刷新筛选项目列表数据
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
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:[self.queryModelHouse mj_keyValues]];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(self.pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [parms setValue:query forKey:@"query"];
    NSLog(@"parms==%@",parms);
    [HouseRentVCListViewModel getRentVcHouseListArrWithParm:parms withBlock:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
        if (success) {
            if (arr.count>0) {
                self.pageNum += 1;
                [self.dataSourceHouse addObjectsFromArray:[NSMutableArray arrayWithArray:[HouseRentListVcHouseCellModel mj_objectArrayWithKeyValuesArray:arr]]];
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
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:[self.queryModelBuniessShop mj_keyValues]];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(self.pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [parms setValue:query forKey:@"query"];
    [HouseRentVCListViewModel getRentVcBuniessShopListArrWithParm:parms WithBlock:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
        if (success) {
            if (arr.count>0) {
                self.pageNum += 1;
                [self.dataSourceBuniessShop addObjectsFromArray:[NSMutableArray arrayWithArray:[HouseRentListVcBuniessShopCellModel mj_objectArrayWithKeyValuesArray:arr]]];
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
#pragma mark ===== 列表数据_end
#pragma mark === ChooseType
- (void)houseRentHeaderViewChooseTypeSubBtnTouchChooseType:(MainCellRecommendedServiceHourse_Rent_Type)type{
    self.viewType  = type;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.menu updateUI];
    });
    NSLog(@"切换 %lu",(unsigned long)type);
    Y_SVP_SHOW_MES_IsDealing
    [self initData];
    
}

#pragma mark === 基础UI
- (void)initView{
    [self navView];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    //
    [self.headerViewOfBuniessShopAndHouse setNowBtnSelectedWithType:self.viewType];//当前商铺or租房
    //
    [self.view addSubview:self.chooseHouseTypePickView];
    self.chooseHouseTypePickView.hidden = YES;
 
 
}
- (void)navView{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-100, KNavBarHeight)];
    [v addSubview:self.navSearchView];
    self.navSearchView.searchBar.delegate = self;
    self.navigationItem.titleView = v;
    [self initRightNavItem];
}
- (void)initRightNavItem{
    UIButton *infoRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoRightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [infoRightBtn setTitle:@"右按钮" forState:UIControlStateNormal];
//    [infoRightBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
//    [infoRightBtn newAnBtnWithImg:[UIImage imageNamed:@"head_news_night"]];
    [infoRightBtn setImage:[[UIImage imageNamed:@"head_news_night"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    infoRightBtn.imageView.tintColor =  [ThemeManager shareManager].mainTextColor;//源图附色
    infoRightBtn.bounds = CGRectMake(0 , 0, 24, 24);
    [infoRightBtn addTarget:self action:@selector(infoRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoRightBarItem = [[UIBarButtonItem alloc]initWithCustomView:infoRightBtn];
//    [self.navigationItem setRightBarButtonItem:infoRightBarItem animated:YES];
    //暂时不显示nav右按钮
}
#pragma mark --- 搜索文本处理   searchStr
//QueryType_CitySearchText
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.searchTextStr = searchText;
    if (searchText.length>0) {
        self.queryModelHouse.searchText =  self.searchTextStr;
        self.queryModelBuniessShop.searchText =  self.searchTextStr;
    }else{
//普通数据
        self.queryModelHouse.searchText = @"";
        self.queryModelBuniessShop.searchText = @"";
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self initData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self initData];
}

- (void)infoRightItemAction:(UIButton *)sender{
    NSLog(@"右按钮 ");
    //暂时不跳
}
#pragma mark === 房屋 筛选相关 delegat—————————————————————— 包含 房屋筛选数据源
 
//HouseTyp弃用下拉框 使用滚轮
- (void)touchUpHouseHouseTypeBtn{
    self.chooseHouseTypePickView.hidden = NO;
}
//弃用 下拉框 房屋类型 改用滚轮 houseConstCode 自己拼 以xx室xx厅xx卫 做成6位长度的字符串再传入提供给initdata筛选
- (void)houseTypeIsChooseWithShiNum:(NSInteger)s withTingNum:(NSInteger)t withWeiNum:(NSInteger)w{
    NSString *strWithS = @"00";
    NSString *strWithT = @"00";
    NSString *strWithW = @"00";
    if (s/10==0) {
        strWithS = [NSString stringWithFormat:@"0%ld",(long)s];
    }else{
        strWithS = [NSString stringWithFormat:@"%ld",(long)s];
    }
    if (t/10==0) {
        strWithT = [NSString stringWithFormat:@"0%ld",(long)t];
    }else{
        strWithT = [NSString stringWithFormat:@"%ld",(long)t];
    }
    if (w/10==0) {
        strWithW = [NSString stringWithFormat:@"0%ld",(long)w];
    }else{
        strWithW = [NSString stringWithFormat:@"%ld",(long)w];
    }
    NSString *codeStr = [NSString stringWithFormat:@"%@%@%@",strWithS,strWithT,strWithW];
    self.queryModelHouse.houseTypeCode = codeStr;//房屋类型几室几厅几卫
    [self initHouseListData];//加载新数据
 
    self.chooseHouseTypePickView.hidden = YES;
}
- (void)houseChooseBuXianBtnActionWithZeroNum{
    self.queryModelHouse.houseTypeCode = @"";
    [self initHouseListData];//加载新数据
}
//房屋租_更多_筛选
#pragma  mark == 房屋 更多
 
 
#pragma mark === 房屋 筛选相关 delegat—————————————————————— 包含 房屋筛选数据源 end
 
 
 
#pragma mark ===  tableView * * *
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        return self.dataSourceHouse.count;
    }else{
        return self.dataSourceBuniessShop.count;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!headView) {
        headView =  [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        headView.backgroundColor = [UIColor clearColor];
    }
    [headView addSubview:self.menu];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        return Cell_sectionheaderView_H;
    }else{
        return Cell_sectionheaderView_H;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Cell_H;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        HouseRentHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentHouseTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRentHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentHouseTableViewCell_Identifier];
        }
        if (self.dataSourceHouse.count>=indexPath.row+1) {
            cell.houseCellmodel = self.dataSourceHouse[indexPath.row];
        }
        return cell;
    }else{   //商铺
        HouseRentBuniessShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentBuniessShopTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRentBuniessShopTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentBuniessShopTableViewCell_Identifier];
        }
        if (self.dataSourceBuniessShop.count>=indexPath.row+1) {
            cell.shopCellmodel = self.dataSourceBuniessShop[indexPath.row];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];   //详情
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        HouseRentListVcHouseCellModel *model = self.dataSourceHouse[indexPath.row];
        HouseRentHouseDetailVc *houseDetailVc = [[HouseRentHouseDetailVc alloc]init];
        houseDetailVc.IDNum = model.ID;
        [self pushVc:houseDetailVc];
    }else{
        HouseRentBuniessShopDetailVc *buinessShopDetailVc = [[HouseRentBuniessShopDetailVc alloc]init];
        HouseRentListVcBuniessShopCellModel *model = self.dataSourceBuniessShop[indexPath.row];
        buinessShopDetailVc.IDNum = model.ID;
        [self pushVc:buinessShopDetailVc];
    }
}

#pragma mark ===  基础UI + 数据 getter
- (HouseRentNavSearchView *)navSearchView{
    if (!_navSearchView) {
        _navSearchView = [[HouseRentNavSearchView alloc]initWithFrame: CGRectMake(0, 0, Screen_W-100, KNavBarHeight)];
    }
    return _navSearchView;
}
- (HouseRentHeaderView *)headerViewOfBuniessShopAndHouse{
    if (!_headerViewOfBuniessShopAndHouse) {
        _headerViewOfBuniessShopAndHouse = [[HouseRentHeaderView alloc]initWithFrame:CGRectZero];//商铺 租房 切换的headerview
        _headerViewOfBuniessShopAndHouse.delegate = self;
    }
    return _headerViewOfBuniessShopAndHouse;
}

- (HouseRentChooseHouseTypeView *)chooseHouseTypePickView{
    if (!_chooseHouseTypePickView) {
        _chooseHouseTypePickView = [[HouseRentChooseHouseTypeView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    }
    _chooseHouseTypePickView.delegate = self;
    return _chooseHouseTypePickView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //_tableView.tableHeaderView = self.headerViewOfBuniessShopAndHouse;//1019 隐藏商铺（切换的headerV去掉 就不会点到商铺了）
        _tableView.tableHeaderView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
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
- (HouseRentListVcHouseQueryTypesModel *)queryModelHouse{
    if (!_queryModelHouse) {
        _queryModelHouse = [[HouseRentListVcHouseQueryTypesModel alloc]init];
        _queryModelHouse.houseAdvantage = [NSArray array];//暂不知道是哪个键
//        _queryModelHouse.searchText = @"";
//        _queryModelHouse.houseTypeCode = @"";
//        _queryModelHouse.houseAreaId = @"";
    }
    return _queryModelHouse;
}
- (HouseRentListVcBuniessShopQueryTypesModel *)queryModelBuniessShop{
    if (!_queryModelBuniessShop) {
        _queryModelBuniessShop = [[HouseRentListVcBuniessShopQueryTypesModel alloc]init];
        _queryModelBuniessShop.shopTypeIdArrays = [[NSMutableArray alloc]init];
        _queryModelBuniessShop.shopBusinessIdArrays = [[NSMutableArray alloc]init];
        
    }
    return _queryModelBuniessShop;
}
// 多选
- (NSMutableArray *)houseSaveMoreSelectedModelArr{
    if (!_houseSaveMoreSelectedModelArr) {
        _houseSaveMoreSelectedModelArr = [[NSMutableArray alloc]init];
    }
    return _houseSaveMoreSelectedModelArr;
}
#pragma mark ====== 筛选 z
#pragma mark === 商铺 房屋 普通 筛选时 不限的数据 各个类型初始化后 增加"不限"项目处理
- (BuniessShopOrHouseRentNomalShaiXuanModel *)dealShaixuanNamalTableViewListDataInfoWithAddBuXianChooseesWithZeroCityOrZeroAreaNum{
    BuniessShopOrHouseRentNomalShaiXuanModel *zeroModel = [[BuniessShopOrHouseRentNomalShaiXuanModel alloc]init];
    zeroModel.name = @"不限";
    zeroModel.annotation = @"";
    zeroModel.houseConstName = @"不限";
    zeroModel.houseConstValue = @"0,99999999";
    zeroModel.idStr = @"";
    zeroModel.ID = 0;
    zeroModel.houseConstType = 0;
    zeroModel.houseConstCode = 0;
//    return [zeroModel mj_keyValues];
    return zeroModel;

}
#pragma mark === 商铺 房屋 普通 筛选展示用的 数据处理
- (NSMutableArray *)dealShaiXuanNomalTableViewListDataInfoDefineIntIs:(NSInteger)defineInt andWithModelArr:(NSMutableArray *)modelArr{
    NSMutableArray *useShaiXuanArr = [[NSMutableArray alloc]init];
    for (int i = 0 ; i <modelArr.count; i++) {
        BuniessShopOrHouseRentNomalShaiXuanModel *model = modelArr[i];
        if (defineInt == BuniessRentQuyu_SectionNum) {
            NSDictionary *newDic = @{@"name": [TextShowWithModelStr textShowWithModelStr: model.name] ,@"otherData":model};
            [useShaiXuanArr addObject:newDic];
        }else{
            NSDictionary *newDic = @{@"name": [TextShowWithModelStr textShowWithModelStr: model.houseConstName] ,@"otherData":model};
            [useShaiXuanArr addObject:newDic];
        }
    }
    return useShaiXuanArr;
}
#pragma mark =========================================================================== 房屋的筛选
- (void)initWithHouseMoreOptionData{
    WEAKSELF
    [HouseRentVcAllQueryTypesChooseViewModel getCityQuArr:^(NSArray * arr, BOOL success) {
        STRONGSELF
        if (success) {
            DLog(@"getCityQuArr  ==%@",arr);
            self.saveHouseQuyuDataSourceModelArr = [BuniessShopOrHouseRentNomalShaiXuanModel mj_objectArrayWithKeyValuesArray:arr];
            //区域 不限
            [self.saveHouseQuyuDataSourceModelArr insertObject:[self dealShaixuanNamalTableViewListDataInfoWithAddBuXianChooseesWithZeroCityOrZeroAreaNum] atIndex:0];
            //
            self.shaixuanHouseQuyuDataSourceArr = [self dealShaiXuanNomalTableViewListDataInfoDefineIntIs:BuniessRentQuyu_SectionNum andWithModelArr:self.saveHouseQuyuDataSourceModelArr];

            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.menu updateUI];
            });
        }
    }];
    [HouseRentVcAllQueryTypesChooseViewModel getMoneyArr:^(NSArray * arr, BOOL success) {
        STRONGSELF
        if (success) {
            DLog(@"getMoneyArr  ==%@",arr);
            
            self.saveHouseMoneyDataSourceModelArr = [BuniessShopOrHouseRentNomalShaiXuanModel mj_objectArrayWithKeyValuesArray:arr];
            self.shaixuanHouseMoneyDataSourceArr = [self dealShaiXuanNomalTableViewListDataInfoDefineIntIs:BuniessRentMoney_SectionNum andWithModelArr:self.saveHouseMoneyDataSourceModelArr];
            
            DLog(@"getMoneyArr 筛选用数据 == %@",self.shaixuanHouseMoneyDataSourceArr);
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.menu updateUI];
            });
        }
    }];
    
    //户型 略
    //1019户型改回列表筛选 滚轮的数据暂时不使用
    /**
     //  model.houseConstName  code self.queryModelHouse.houseTypeCode = codeStr;//房屋类型几室几厅几卫
     {
     annotation = "\U623f\U5c4b\U79df\U91d1";
     houseConstCode = 1;
     houseConstName = "\U4e0d\U9650";
     houseConstType = 5;
     houseConstValue = "0,999999";
     id = 30;
     idStr = 30;
 },
     */
    self.queryModelHouse.houseTypeCode = @"";
    NSArray *arrOfHuXinName = [[NSArray alloc]initWithObjects:@"一室",@"两室", @"三室",@"四室及以上",  nil];
    NSArray *arrOfHuXinCode = [[NSArray alloc]initWithObjects:@(1),@(2), @(3),@(4),  nil];
    NSMutableArray *shaiXuanHuXinCodeAndConstnameArr = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < arrOfHuXinName.count; i ++) {
        [shaiXuanHuXinCodeAndConstnameArr addObject:@{@"houseConstName":arrOfHuXinName[i],@"houseConstCode":arrOfHuXinCode[i]}];//houseConstName
    }
    [shaiXuanHuXinCodeAndConstnameArr insertObject:[self dealShaixuanNamalTableViewListDataInfoWithAddBuXianChooseesWithZeroCityOrZeroAreaNum] atIndex:0];//'不限'数据 code0 做第一个数据
    //
    self.saveHouseHuxinDataSourceModelArr = [BuniessShopOrHouseRentNomalShaiXuanModel mj_objectArrayWithKeyValuesArray:shaiXuanHuXinCodeAndConstnameArr];
    self.shaixuanHouseHuXingNumDataSourceArr = [self dealShaiXuanNomalTableViewListDataInfoDefineIntIs:HouseRentHuXinNum_SectionNum andWithModelArr:self.saveHouseHuxinDataSourceModelArr];
    DLog(@"getHuXin 筛选用数据 == %@",self.saveHouseHuxinDataSourceModelArr);

    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.menu updateUI];
    });
    //户型_初始化end
    
    [HouseRentVcAllQueryTypesChooseViewModel getMoreArr:^(NSDictionary * dic, BOOL success) {
        STRONGSELF
        if (success) {
            DLog(@"initWithHouseMoreOptionData  ==%@",dic);
            self.saveHouseMoreDataSourceDic = dic.mutableCopy;
        
            NSMutableArray *moreModelArr = [self dealHouseShaiXuanMoreOptionBecomeArr:dic];//元素为model arr【arr】
            NSMutableArray *willUseSaiXuanHaveNameModelDataArr = [[NSMutableArray alloc]init];
            for (int i = 0; i < moreModelArr.count; i++) {
               [willUseSaiXuanHaveNameModelDataArr  addObject:  [self dealShaiXuanNomalTableViewListDataInfoDefineIntIs:1 andWithModelArr:moreModelArr[i]] ];//非name类型
            }
            self.shaixuanHouseMoreDataSourceArr = [[NSMutableArray alloc]initWithArray:willUseSaiXuanHaveNameModelDataArr];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.menu updateUI];
            });
        }
    }];
}
#pragma mark === 商铺 更多 筛选展示用的 文本处理 做成arr[arrs]用于后续的点击后section row取值 ｜房屋用model不用纯文本
- (NSMutableArray *)dealHouseShaiXuanMoreOptionBecomeArr:(NSDictionary *)moreDic{
    NSMutableArray *willUseSaixuanModelArr = [[NSMutableArray alloc]init];
    self.shaixuanHouseMoreDataTitleStrSourceArr = [[NSMutableArray alloc]init];
    NSArray *moreKeyArr = [moreDic allKeys];//源本key
    //
    for (int i = 0 ;i < moreKeyArr.count; i++) {
        NSString *keyNameStr = [NSString stringWithFormat:@"%@", moreKeyArr[i]];
        NSArray  *subConstArr  = [NSArray arrayWithArray: [moreDic objectForKey:keyNameStr]];
        NSArray *subConstArrModel = [BuniessShopOrHouseRentNomalShaiXuanModel mj_objectArrayWithKeyValuesArray:subConstArr];
        //新的数据
        [self.shaixuanHouseMoreDataTitleStrSourceArr addObject:keyNameStr];//保证name和数据的顺序一致
        [willUseSaixuanModelArr addObject:subConstArrModel];//保存 model 一组 结构arr[arrs]
    }
    return willUseSaixuanModelArr;
}
#pragma mark == 房屋筛选所用
- (NSMutableArray *)saveHouseQuyuDataSourceModelArr{
    if (!_saveHouseQuyuDataSourceModelArr) {
        _saveHouseQuyuDataSourceModelArr = [[NSMutableArray alloc]init];
    }
    return _saveHouseQuyuDataSourceModelArr;
}
- (NSMutableArray *)saveHouseMoneyDataSourceModelArr{
    if (!_saveHouseMoneyDataSourceModelArr) {
        _saveHouseMoneyDataSourceModelArr = [[NSMutableArray alloc]init];
    }
    return _saveHouseMoneyDataSourceModelArr;
}
- (NSMutableArray *)saveHouseHuxinDataSourceModelArr{
    if (!_saveHouseHuxinDataSourceModelArr) {
        _saveHouseHuxinDataSourceModelArr = [[NSMutableArray alloc]init];
    }
    return _saveHouseHuxinDataSourceModelArr;
}
- (NSMutableDictionary *)saveHouseMoreDataSourceDic{
    if (!_saveHouseMoreDataSourceDic) {
        _saveHouseMoreDataSourceDic = [[NSMutableDictionary alloc]init];
    }
    return _saveHouseMoreDataSourceDic;
}

//___ 筛选带有文本

- (NSArray *)saixuanHouseTopTitleStrArr{
    if (!_saixuanHouseTopTitleStrArr) {
        _saixuanHouseTopTitleStrArr = [NSArray arrayWithObjects:@"区域",@"租金", @"户型", @"更多", nil];
    }
    return _saixuanHouseTopTitleStrArr;
}
- (NSMutableArray *)shaixuanHouseQuyuDataSourceArr{
    if (!_shaixuanHouseQuyuDataSourceArr) {
        _shaixuanHouseQuyuDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _shaixuanHouseQuyuDataSourceArr;
}
- (NSMutableArray *)shaixuanHouseMoneyDataSourceArr{
    if (!_shaixuanHouseMoneyDataSourceArr) {
        _shaixuanHouseMoneyDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _shaixuanHouseMoneyDataSourceArr;
}
- (NSMutableArray *)shaixuanHouseHuXingNumDataSourceArr{//户型
    if (!_shaixuanHouseHuXingNumDataSourceArr) {
        _shaixuanHouseHuXingNumDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _shaixuanHouseHuXingNumDataSourceArr;
}
- (NSMutableArray *)shaixuanHouseMoreDataTitleStrSourceArr{
    if (!_shaixuanHouseMoreDataTitleStrSourceArr) {
        _shaixuanHouseMoreDataTitleStrSourceArr = [[NSMutableArray alloc]init];
    }
    return _shaixuanHouseMoreDataTitleStrSourceArr;
}
#pragma mark =========================================================================== 商铺的筛选
 
#pragma mark === 商铺 更多 筛选用的数据源泉
- (void)initWithBuniessShopMoreOptionData{
    WEAKSELF
    [HouseRentVcAllQueryTypesChooseViewModel getCityQuArr:^(NSArray * arr, BOOL success) {
        STRONGSELF
        if (success) {
            DLog(@" getCityQuArr == %@",arr);
            self.saveBuniessQuyuDataSourceModelArr = [NSMutableArray arrayWithArray: [BuniessShopOrHouseRentNomalShaiXuanModel mj_objectArrayWithKeyValuesArray:arr]];
            //区域 不限
            [self.saveBuniessQuyuDataSourceModelArr insertObject:[self dealShaixuanNamalTableViewListDataInfoWithAddBuXianChooseesWithZeroCityOrZeroAreaNum] atIndex:0];
            //
            self.shaixuanBuniessQuyuDataSourceArr = [self dealShaiXuanNomalTableViewListDataInfoDefineIntIs:BuniessRentQuyu_SectionNum andWithModelArr:self.saveBuniessQuyuDataSourceModelArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.menu updateUI];
            });
        }
    }];
    [HouseRentVcAllQueryTypesChooseViewModel getMoneyArr:^(NSArray * arr, BOOL success) {
        STRONGSELF
        if (success) {
            DLog(@"%@",arr);
            self.saveBuniessMoneyDataSourceModelArr = [NSMutableArray arrayWithArray: [BuniessShopOrHouseRentNomalShaiXuanModel mj_objectArrayWithKeyValuesArray:arr]];
            self.shaixuanBuniessMoneyDataSourceArr = [self dealShaiXuanNomalTableViewListDataInfoDefineIntIs:BuniessRentMoney_SectionNum andWithModelArr:self.saveBuniessMoneyDataSourceModelArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.menu updateUI];
            });
        }

    }];
    [HouseRentVcAllQueryTypesChooseViewModel getBuniessAreaSpaceeArr:^(NSArray * arr, BOOL success) {
        STRONGSELF
        if (success) {
            DLog(@"%@",arr);
            self.saveBuniessAreaNumDataSourceModelArr = [NSMutableArray arrayWithArray: [BuniessShopOrHouseRentNomalShaiXuanModel mj_objectArrayWithKeyValuesArray:arr]];
            //面积 不限
            [self.saveBuniessAreaNumDataSourceModelArr insertObject:[self dealShaixuanNamalTableViewListDataInfoWithAddBuXianChooseesWithZeroCityOrZeroAreaNum] atIndex:0];
            //
            self.shaixuanBuniessAreaNumDataSourceArr = [self dealShaiXuanNomalTableViewListDataInfoDefineIntIs:BuniessRentAreaNum_SectionNum andWithModelArr:self.saveBuniessAreaNumDataSourceModelArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.menu updateUI];
            });
        }
    }];
    //more -----    business  type source
    [HouseRentVcAllQueryTypesChooseViewModel getBuniessMoreArr:^(NSDictionary * dic, BOOL success) {
        STRONGSELF
            if (success) {
                //处理成数据
                self.saveBuniessMoreDataSourceDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                self.shaixuanBuniessMoreDataSourceArr = [self dealBuniessShopShaiXuanMoreOptionBecomeArr:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.menu updateUI];
                });
            }
            
 
    }];
    
}

#pragma mark === 商铺 更多 筛选展示用的 文本处理 做成arr[arrs]用于后续的点击后section row取值 ｜房屋用model不用纯文本
- (NSMutableArray *)dealBuniessShopShaiXuanMoreOptionBecomeArr:(NSDictionary *)moreDic{
    NSMutableArray *arrWillUseShaiXuanOnlyText = [[NSMutableArray alloc]init];
    self.saixuanBuniessMoreDataTitleStrSourceArr = [[NSMutableArray alloc]init];//清空原有的title
    
    //BuniessShopRentMoreShaiXuanModel
    NSArray *moreKeyArr = [moreDic allKeys];//源本key
    
    for (int i = 0 ;i < moreKeyArr.count; i++) {
        NSString *keyNameStrWithChinese = @"";
        NSMutableArray *oneConstArr =  [[NSMutableArray alloc]init];
        //
        NSString *keyNameStr = [NSString stringWithFormat:@"%@", moreKeyArr[i]];
        NSArray  *subConstArr  = [NSArray arrayWithArray: [moreDic objectForKey:keyNameStr]];
        NSArray *subConstArrModel = [BuniessShopRentMoreShaiXuanModel mj_objectArrayWithKeyValuesArray:subConstArr];
        //
        if ([keyNameStr isEqualToString:@"source"]) {
            for ( BuniessShopRentMoreShaiXuanModel  *subModel in subConstArrModel ) {
                NSString *constStr =  [TextShowWithModelStr textShowWithModelStr:subModel.type];
                [oneConstArr addObject:constStr];
                keyNameStrWithChinese = @"出租来源";
            }
        }else{
            for ( BuniessShopRentMoreShaiXuanModel  *subModel in subConstArrModel ) {
                NSString *constStr =  [TextShowWithModelStr textShowWithModelStr:subModel.constName];
                [oneConstArr addObject:constStr];
                keyNameStrWithChinese = [TextShowWithModelStr textShowWithModelStr:subModel.typeName];
            }
        }
        //新的数据
        [self.saixuanBuniessMoreDataTitleStrSourceArr addObject:keyNameStrWithChinese];
        [arrWillUseShaiXuanOnlyText addObject:oneConstArr];//加一组 纯文本
        [self.saveBuniessMoreDataSourceModelArrUseChoose addObject:subConstArrModel];//保存 model 一组 结构arr[arrs]
    }
    return arrWillUseShaiXuanOnlyText;
}

#pragma mark == 商铺筛选所用
//商铺筛选纯文本数据源 展示时使用
- (NSArray *)saixuanBuniessTopTitleStrArr{
    if (!_saixuanBuniessTopTitleStrArr) {
        _saixuanBuniessTopTitleStrArr = [NSArray arrayWithObjects:@"区域",@"租金", @"面积", @"更多", nil];
    }
    return _saixuanBuniessTopTitleStrArr;
}
//商铺筛选 得到的数据源 存下来
- (NSMutableArray *)saveBuniessQuyuDataSourceModelArr{
    if (!_saveBuniessQuyuDataSourceModelArr) {
        _saveBuniessQuyuDataSourceModelArr = [[NSMutableArray alloc]init];
    }
    return _saveBuniessQuyuDataSourceModelArr;
}
- (NSMutableArray *)saveBuniessMoneyDataSourceModelArr{
    if (!_saveBuniessMoneyDataSourceModelArr) {
        _saveBuniessMoneyDataSourceModelArr = [[NSMutableArray alloc]init];
    }
    return _saveBuniessMoneyDataSourceModelArr;
}
- (NSMutableArray *)saveBuniessAreaNumDataSourceModelArr{
    if (!_saveBuniessAreaNumDataSourceModelArr) {
        _saveBuniessAreaNumDataSourceModelArr = [[NSMutableArray alloc]init];
    }
    return _saveBuniessAreaNumDataSourceModelArr;
}
- (NSMutableArray *)saveBuniessMoreDataSourceModelArrUseChoose{
    if (!_saveBuniessMoreDataSourceModelArrUseChoose) {
        _saveBuniessMoreDataSourceModelArrUseChoose = [[NSMutableArray alloc]init];
    }
    return _saveBuniessMoreDataSourceModelArrUseChoose;
}
- (NSMutableDictionary *)saveBuniessMoreDataSourceDic{
    if (!_saveBuniessMoreDataSourceDic) {
        _saveBuniessMoreDataSourceDic = [[NSMutableDictionary alloc]init];
    }
    return _saveBuniessMoreDataSourceDic;
}
- (NSMutableArray *)saixuanBuniessMoreDataTitleStrSourceArr{
    if (!_saixuanBuniessMoreDataTitleStrSourceArr) {
        _saixuanBuniessMoreDataTitleStrSourceArr = [[NSMutableArray alloc]init];
    }
    return _saixuanBuniessMoreDataTitleStrSourceArr;
}
- (NSMutableArray *)shaixuanBuniessQuyuDataSourceArr{
    if (!_shaixuanBuniessQuyuDataSourceArr) {
        _shaixuanBuniessQuyuDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _shaixuanBuniessQuyuDataSourceArr;
}
- (NSMutableArray *)shaixuanBuniessMoneyDataSourceArr{
    if (!_shaixuanBuniessMoneyDataSourceArr) {
        _shaixuanBuniessMoneyDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _shaixuanBuniessMoneyDataSourceArr;
}
- (NSMutableArray *)shaixuanBuniessAreaNumDataSourceArr{
    if (!_shaixuanBuniessAreaNumDataSourceArr) {
        _shaixuanBuniessAreaNumDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _shaixuanBuniessAreaNumDataSourceArr;
}
- (NSMutableArray *)shaixuanBuniessMoreDataSourceArr{
    if (!_shaixuanBuniessMoreDataSourceArr) {
        _shaixuanBuniessMoreDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _shaixuanBuniessMoreDataSourceArr;
}

 
#pragma mark === 商铺 下拉菜单 初始化 //1016暂时隐藏更多筛选项目
- (void)initBuniessShopAndHouseShaiXuanChooseMenu{
 
    UIColor *topTitleBgColor =  [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    UIColor *bomListTableViewBgColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    UIColor *collViewCellNomalBgColor =  [[ThemeManager shareManager].themeContentBackGroundColor colorWithAlphaComponent:0.7];
    UIColor *collViewCellSelectedBgColor = [Color_38BlueColor colorWithAlphaComponent:0.7];
    
    self.param =
    MenuParam()
    .wMainRadiusSet(0)
 
    .wTextAlignmentSet(NSTextAlignmentCenter)
//    .wTableViewColorSet( @[bomListTableViewBgColor,bomListTableViewBgColor,bomListTableViewBgColor,bomListTableViewBgColor] )
    .wTableViewColorSet( @[bomListTableViewBgColor,bomListTableViewBgColor,bomListTableViewBgColor] )//1016暂时隐藏更多筛选项目

    .wCollectionViewCellBgColorSet(collViewCellNomalBgColor)
    .wCollectionViewCellSelectBgColorSet( collViewCellSelectedBgColor)
    .wCollectionViewCellTitleColorSet([ThemeManager shareManager].mainTextColor)
    .wCollectionViewCellSelectTitleColorSet([ThemeManager shareManager].mainTextColor)
    
//    .wMenuTitleEqualCountSet(4);//1016暂时隐藏更多筛选项目
    .wMenuTitleEqualCountSet(3);//1016暂时隐藏更多筛选项目
    self.menu = [[WMZDropDownMenu alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Cell_sectionheaderView_H) withParam:self.param];
    self.menu.titleView.backgroundColor =  topTitleBgColor;
    self.menu.collectionView.backgroundColor  = topTitleBgColor;
    self.menu.delegate = self;
}
//
- (BOOL)willDealloc {
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong id strongSelf = weakSelf;
        [strongSelf assertNotDealloc];
    });
    return YES;
}
//assertNotDealloc 主要作用是直接中断言 如果3秒后它被释放成功，weakSelf 就指向 nil，不会调用到 -assertNotDealloc 方法，也就不会中断言，如果它没被释放（泄露了），-assertNotDealloc 就会被调用中断言
- (void)assertNotDealloc {
//    if ([MLeakedObjectProxy isAnyObjectLeakedAtPtrs:[self parentPtrs]]) {
    //        return;
    //    }
    //    [MLeakedObjectProxy addLeakedObject:self];
    DLog(@"----- assertNotDealloc");
}
 
#pragma mark === 筛选协议部分
- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    NSString *nomalImgName = @"menu_dowm";
    NSString *selectedImgName = @"menu_up";
    if (self.viewType == MainCellRecommendedServiceHourse_Type_BusinessShop ) {//商铺
        return @[
            @{@"name":self.saixuanBuniessTopTitleStrArr.firstObject,@"normalImage":nomalImgName,@"selectImage":selectedImgName},
            @{@"name":self.saixuanBuniessTopTitleStrArr[1],        @"normalImage":nomalImgName,@"selectImage":selectedImgName},
            @{@"name":self.saixuanBuniessTopTitleStrArr[2],        @"normalImage":nomalImgName,@"selectImage":selectedImgName},
          //  @{@"name":self.saixuanBuniessTopTitleStrArr.lastObject,@"normalImage":nomalImgName,@"selectImage":selectedImgName},//1016暂时隐藏更多筛选项目
        ];
    }else{
        return @[
            @{@"name":self.saixuanHouseTopTitleStrArr.firstObject,@"normalImage":nomalImgName,@"selectImage":selectedImgName},
            @{@"name":self.saixuanHouseTopTitleStrArr[1],        @"normalImage":nomalImgName,@"selectImage":selectedImgName},
            @{@"name":self.saixuanHouseTopTitleStrArr[2],        @"normalImage":nomalImgName,@"selectImage":nomalImgName},
         //   @{@"name":self.saixuanHouseTopTitleStrArr.lastObject,@"normalImage":nomalImgName,@"selectImage":selectedImgName},//1016暂时隐藏更多筛选项目
        ];
    }
    //            @{@"name":self.saixuanHouseTopTitleStrArr[2],        @"normalImage":nomalImgName,@"selectImage":selectedImgName},
  
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section!=BuniessRentMore_SectionNum){
        return 1;
    }else{
        if (self.viewType == MainCellRecommendedServiceHourse_Type_BusinessShop ) {//商铺
            return self.saixuanBuniessMoreDataTitleStrSourceArr.count;
        }else{
            return self.shaixuanHouseMoreDataTitleStrSourceArr.count;
        }
       
    }
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (self.viewType == MainCellRecommendedServiceHourse_Type_BusinessShop ) {//商铺
        if (dropIndexPath.section==BuniessRentQuyu_SectionNum) {
            return self.shaixuanBuniessQuyuDataSourceArr;
        }else if  (dropIndexPath.section==BuniessRentMoney_SectionNum){
            return self.shaixuanBuniessMoneyDataSourceArr;
        }else if  (dropIndexPath.section==BuniessRentAreaNum_SectionNum){
            return self.shaixuanBuniessAreaNumDataSourceArr;
        }else if  (dropIndexPath.section==BuniessRentMore_SectionNum){//更多
            return  [NSArray arrayWithArray: self.shaixuanBuniessMoreDataSourceArr[dropIndexPath.row]];//更多 纯文本所在的内容
        }else{
            return @[];
        }
    }else{
        if (dropIndexPath.section==BuniessRentQuyu_SectionNum) {
            return self.shaixuanHouseQuyuDataSourceArr;
        }else if  (dropIndexPath.section==BuniessRentMoney_SectionNum){
            return self.shaixuanHouseMoneyDataSourceArr;
        }else if  (dropIndexPath.section==HouseRentHuXinNum_SectionNum){//BuniessRentAreaNum_SectionNum
//            return self.shaixuanHouseHuXingNumDataSourceArr;
//            return @[];//户型 无数据 使用的是滚轮
            return self.shaixuanHouseHuXingNumDataSourceArr;//1019户型改为列表筛选 暂不使用滚轮
        }else if  (dropIndexPath.section==BuniessRentMore_SectionNum){//更多
            return   self.shaixuanHouseMoreDataSourceArr[dropIndexPath.row];//更多 name+model
        }else{
            return @[];
        }
    }
  
}
- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{//section 和 row 的多选单选. 每列的编辑类型 单选|多选  默认单选
    if (self.viewType == MainCellRecommendedServiceHourse_Type_BusinessShop ) {//商铺
        if(dropIndexPath.section != BuniessRentMore_SectionNum){ //多选单选样式关系到数据显示不
            return MenuEditOneCheck;
        }else{
            if (dropIndexPath.row==0  ||  dropIndexPath.row==1) {
                return MenuEditMoreCheck;//多选
            }else{
                return MenuEditOneCheck;
            }
        }
    }else{
        return MenuEditOneCheck;
    }
 
}

 
- (NSString *)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (self.viewType == MainCellRecommendedServiceHourse_Type_BusinessShop ) {//商铺
        if (dropIndexPath.section == BuniessRentMore_SectionNum){
            return self.saixuanBuniessMoreDataTitleStrSourceArr[dropIndexPath.row];;//更多 纯文本的section 组名
        }
    }else{
        if (dropIndexPath.section == BuniessRentMore_SectionNum){
            return self.shaixuanHouseMoreDataTitleStrSourceArr[dropIndexPath.row];;//更多 纯文本的section 组名
        }
    }
   
    return @"";
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return 0;//底部的重置确定
}

- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
//    if (self.viewType == MainCellRecommendedServiceHourse_Type_BusinessShop ) {//商铺
//    }else{
//
//    }
    //每组的样式
    if(dropIndexPath.section != BuniessRentMore_SectionNum){
        return MenuUITableView;
    }else{
        return MenuUICollectionView;
    }
}
/*
*返回section行标题数据视图出现的动画样式   默认
MenuShowAnimalBottom
注:最后一个默认是筛选 弹出动画为 MenuShowAnimalRight
*/
- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu
showAnimalStyleForRowInSection:(NSInteger)section{
    if(section != BuniessRentMore_SectionNum){
        return MenuShowAnimalBottom;
    }else{
        return MenuShowAnimalRight;
    }
}
/*
  *返回section行标题数据视图消失的动画样式   默认 MenuHideAnimalTop
  注:最后一个默认是筛选 消失动画为 MenuHideAnimalLeft
   */
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu
hideAnimalStyleForRowInSection:(NSInteger)section{
    if(section != BuniessRentMore_SectionNum){
        return MenuHideAnimalTop;
    }else{
        return MenuHideAnimalLeft;
    }
}
 
/*
  *返回WMZDropIndexPath每行 每列 显示的个数
   注:
   样式MenuUITableView         默认4个
   样式MenuUICollectionView    默认1个 传值无效
   */
 
- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{

    if(dropIndexPath.section != BuniessRentMore_SectionNum){
        return 4;
    }else{
        return 4;//更多 每组4个点击cell
    }
}
#pragma -mark 交互自定义代理

/*
 *cell点击方法
 */
- (void)menu:(WMZDropDownMenu *)menu
didSelectRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath
dataIndexPath:(NSIndexPath*)indexpath data:(WMZDropTree*)data{
    NSLog(@"cell点击方法");// po data ======== name = m2 ，isSeleted = 1
    NSInteger chooseSectionNum = dropIndexPath.section;//横向section
    NSInteger chooseRowNum = indexpath.row;//纵向arr 的 row
    
    if (self.viewType == MainCellRecommendedServiceHourse_Type_BusinessShop ) {//商铺
        
        switch (chooseSectionNum) {
            case BuniessRentQuyu_SectionNum:
            {
                BuniessShopOrHouseRentNomalShaiXuanModel *model =  self.saveBuniessQuyuDataSourceModelArr[chooseRowNum];
                self.queryModelBuniessShop.houseAreaId =  model.ID;
                
            }
                break;
            case BuniessRentMoney_SectionNum:
            {
                BuniessShopOrHouseRentNomalShaiXuanModel *model=  self.saveBuniessMoneyDataSourceModelArr[chooseRowNum];
                NSString *valueStr = [TextShowWithModelStr textShowWithModelStr:model.houseConstValue];
                NSArray *valueArr = [valueStr componentsSeparatedByString:@","];
                self.queryModelBuniessShop.housePriceMin = [valueArr.firstObject doubleValue];
                self.queryModelBuniessShop.housePriceMax = [valueArr.lastObject doubleValue];
            }
                break;
            case BuniessRentAreaNum_SectionNum:
            {
                BuniessShopOrHouseRentNomalShaiXuanModel *model =  self.saveBuniessAreaNumDataSourceModelArr[chooseRowNum];
                NSString *valueStr = [TextShowWithModelStr textShowWithModelStr:model.houseConstValue];
                NSArray *valueArr = [valueStr componentsSeparatedByString:@","];
                self.queryModelBuniessShop.houseSquareMeterMin = [valueArr.firstObject doubleValue];
                self.queryModelBuniessShop.houseSquareMeterMax = [valueArr.lastObject doubleValue];
            }
                break;
                
            default://更多
            {
                if (dropIndexPath.section==3) {//更多按钮
                    BOOL isChooseOrCancel = NO;
                    if (data.isSelected==YES) {//选择
                        isChooseOrCancel = YES;
                    }else{//取消
                        isChooseOrCancel = NO;
                    }
                    
                    //更多 组内section row
                    NSInteger moreSection = indexpath.section;
                    NSInteger moreRow = indexpath.row;
                    NSMutableArray *arr =  self.saveBuniessMoreDataSourceModelArrUseChoose[moreSection];
                    BuniessShopRentMoreShaiXuanModel *moreModel = arr[moreRow];
                    switch (moreModel.typeId) {//0710行业类型键值互换 0715换回来行业bunnies 类型type。｜ ‘不限 这个按钮 没用’
                        case 3://business  shopBusinessIdArrays
                            if (isChooseOrCancel) {
                                    [self.queryModelBuniessShop.shopBusinessIdArrays addObject:@(moreModel.ID)];//
                            }else{
                                if ([self.queryModelBuniessShop.shopBusinessIdArrays containsObject: @(moreModel.ID) ]) {
                                    [self.queryModelBuniessShop.shopBusinessIdArrays removeObject:@(moreModel.ID)];
                                } 
                            }

                            break;
                        case 2://type  shopTypeIdArrays
                            if (isChooseOrCancel) {
                                [self.queryModelBuniessShop.shopTypeIdArrays addObject:@(moreModel.ID)] ;
                            }else{
                                if ([self.queryModelBuniessShop.shopTypeIdArrays containsObject: @(moreModel.ID) ]) {
                                    [self.queryModelBuniessShop.shopTypeIdArrays removeObject:@(moreModel.ID)];
                                }
                            }

                            break;
//                        case 3://business 行业 shopBusinessIdArrays
//                            if (isChooseOrCancel) {
//                                [self.queryModelBuniessShop.shopBusinessIdArrays addObject:@(moreModel.id)] ;
//                            }else{
//                                if ([self.queryModelBuniessShop.shopBusinessIdArrays containsObject: @(moreModel.id) ]) {
//                                    [self.queryModelBuniessShop.shopBusinessIdArrays removeObject:@(moreModel.id)];
//                                }
//                            }
//
//                            break;
//                        case 2://type 类型shopTypeIdArrays
//                            if (isChooseOrCancel) {
//                                [self.queryModelBuniessShop.shopTypeIdArrays addObject:@(moreModel.id)] ;
//                            }else{
//                                if ([self.queryModelBuniessShop.shopTypeIdArrays containsObject: @(moreModel.id) ]) {
//                                    [self.queryModelBuniessShop.shopTypeIdArrays removeObject:@(moreModel.id)];
//                                }
//                            }
//
//                            break;
                        case 0:  //source 业主 物业 不限 （本结构只有两个键值 id+type）
                            if (isChooseOrCancel) {
                                self.queryModelBuniessShop.houseSourceId = moreModel.ID;
                            }else{
                                self.queryModelBuniessShop.houseSourceId = 0;
                            }
                            break;
                            
                        default:
                            //其他
                            break;
                    }
                    DLog(@"商铺筛选 ----- %@",[self.queryModelBuniessShop mj_keyValues]);
                    return;
                }
            }
                break;
        }
        
        
    }else{//房屋
        
        switch (chooseSectionNum) {
            case BuniessRentQuyu_SectionNum:
            {
               // BuniessShopOrHouseRentNomalShaiXuanModel *model =  self.saveBuniessQuyuDataSourceModelArr[chooseRowNum];
                BuniessShopOrHouseRentNomalShaiXuanModel *model =  self.saveHouseQuyuDataSourceModelArr[chooseRowNum];
                self.queryModelHouse.houseAreaId =   [NSString stringWithFormat:@"%ld",model.ID];
                
            }
                break;
            case BuniessRentMoney_SectionNum:
            {
//                BuniessShopOrHouseRentNomalShaiXuanModel *model=  self.saveBuniessMoneyDataSourceModelArr[chooseRowNum];
                BuniessShopOrHouseRentNomalShaiXuanModel *model=  self.saveHouseMoneyDataSourceModelArr[chooseRowNum];
                NSString *valueStr = [TextShowWithModelStr textShowWithModelStr:model.houseConstValue];
                NSArray *valueArr = [valueStr componentsSeparatedByString:@","];
                self.queryModelHouse.housePriceMin = [valueArr.firstObject doubleValue];
                self.queryModelHouse.housePriceMax = [valueArr.lastObject doubleValue];
            }
                break;
//            case BuniessRentAreaNum_SectionNum:
//            {
//                BuniessShopOrHouseRentNomalShaiXuanModel *model =  self.saveBuniessAreaNumDataSourceModelArr[chooseRowNum];
//                NSString *valueStr = [TextShowWithModelStr textShowWithModelStr:model.houseConstValue];
//                NSArray *valueArr = [valueStr componentsSeparatedByString:@","];
//                self.queryModelHouse.houseSquareMeterMin = [valueArr.firstObject doubleValue];
//                self.queryModelHouse.houseSquareMeterMax = [valueArr.lastObject doubleValue];
//            }
//                break;
            case HouseRentHuXinNum_SectionNum:
            {
                BuniessShopOrHouseRentNomalShaiXuanModel *model =  self.saveHouseHuxinDataSourceModelArr[chooseRowNum];
                if (model.houseConstCode == 0 ) {
                    self.queryModelHouse.houseTypeCode = @"";// @"0";
                }else{
                    NSString *huXinCodeStr = [NSString stringWithFormat:@"%ld", model.houseConstCode];
                    self.queryModelHouse.houseTypeCode  = huXinCodeStr;
                }
            }
                break;
                
            default://更多
            {
                if (dropIndexPath.section==3) {//更多按钮
                    BOOL isChooseOrCancel = NO;
                    if (data.isSelected==YES) {//选择
                        isChooseOrCancel = YES;
                    }else{//取消
                        isChooseOrCancel = NO;
                    }
                    
                    //更多 组内section row
                    NSInteger moreSection = indexpath.section;
                    NSInteger moreRow = indexpath.row;
                    NSMutableArray *arr =  self.shaixuanHouseMoreDataSourceArr[moreSection];
                    NSDictionary *nameAndModelDic = [NSDictionary dictionaryWithDictionary:arr[moreRow]];
                    BuniessShopOrHouseRentNomalShaiXuanModel *moreModel = [[nameAndModelDic allKeys] containsObject:@"otherData"] ? [nameAndModelDic objectForKey:@"otherData"] : [[BuniessShopRentMoreShaiXuanModel alloc]init];
                    /***
                     if ([model.houseConstName containsString:@"装修"]) {
                     self.queryModelHouse.houseAdvantage = @[@(model.houseConstCode)];
                     }
                     }
                     if (model.houseConstType==11) {// @"租房方式"
                     //        self.queryModelHouse.houseLeasemodeId = model.houseConstCode;//按出租方式搜索code 1不限(默认) 2整租，4合租
                     self.queryModelHouse.houseLeasemodeId = model.houseConstCode; //++多选？
                     
                     }
                     if (model.houseConstType==10) { ///租房类型   @"普通住宅" //按出租类型code搜索  1不限(默认) 2普通住宅 4别墅 8公寓
                     self.queryModelHouse.houseLeasetypeId = model.houseConstCode;
                     }
                     if (model.houseConstType==9) {// @"房屋来源"
                     self.queryModelHouse.houseSourceId = model.houseConstCode;//按房屋来源搜索   1.不限 2.个人 4.物业
                     }
                 
                     //*/
                    switch (moreModel.houseConstType) { //目前都是单选
                        case 9://租房类型 1015本项没有
                            if (isChooseOrCancel) {
                                self.queryModelHouse.houseSourceId = moreModel.houseConstCode;
                            }else{
                                self.queryModelHouse.houseSourceId = 0;
                            }
                            
                            
                            break;
                        case 10://房屋来源 10:@"@"出租房源类型"
                            if (isChooseOrCancel) {
                                self.queryModelHouse.houseLeasetypeId = moreModel.houseConstCode;
                            }else{
                                self.queryModelHouse.houseLeasetypeId = 0;
                            }
                            break;
                        case 11: //租赁方式 业主 物业 不限
                            if (isChooseOrCancel) {
                                self.queryModelHouse.houseLeasemodeId = moreModel.houseConstCode;
                            }else{
                                self.queryModelHouse.houseLeasemodeId = 0;
                            }
                            break;
                        case 12: // 12:: @"房屋亮点
                            if (isChooseOrCancel) {//添加
                                [self.queryModelHouse.houseAdvantageCode addObject:@(moreModel.houseConstCode)] ;
                            }else{//删除
                                if ([self.queryModelHouse.houseAdvantageCode containsObject: @(moreModel.houseConstCode) ]) {
                                    [self.queryModelHouse.houseAdvantageCode removeObject:@(moreModel.houseConstCode)];
                                }
                            }
                            break;
                        default:
                            //其他
                            DLog(@"房屋 更多筛选 其他");
                         
                            break;
                            
                    }
                    DLog(@"房屋筛选 ----- %@",[self.queryModelBuniessShop mj_keyValues]);
                }
            }
                
        }
    }
    
    [self initData];//已有数据
}
/*
 *标题点击方法
 */
- (void)menu:(WMZDropDownMenu *)menu didSelectTitleInSection:
(NSInteger)section btn:(WMZDropMenuBtn*)selectBtn{
    NSLog(@"标题点击方法");//po selectBtn.normalTitle
    if (self.viewType != MainCellRecommendedServiceHourse_Type_BusinessShop && section==2  ) {//房屋的户型选择
    //popv 1016不使用popvsub滚轮了
//        self.chooseHouseTypePickView.hidden = !self.chooseHouseTypePickView.hidden;
    }
    
}
/*
 *确定方法 多个选择
 selectNoramalData 转化后的的模型数据
 selectData 字符串数据
 */
- (void)menu:(WMZDropDownMenu *)menu didConfirmAtSection:
(NSInteger)section selectNoramelData:(NSMutableArray*)selectNoramalData selectStringData:(NSMutableArray*)selectData{
    NSLog(@"确定方法 ");
    if (section==3) {
        NSLog(@"确定方法 更多");
        [self initData];
    }
}

/*
*重置方法
*/
- (void)menu:(WMZDropDownMenu *)menu didReSetAtSection:(NSInteger)section{
    if (section==3) {//更多
        [self buniessAndHouseMoreShaiXuanClearning];
        
    }
}
/*
*监听关闭视图 可做修改标题文本和颜色的操作
*/
- (void)menu:(WMZDropDownMenu *)menu closeWithBtn:(WMZDropMenuBtn*)selectBtn   index:(NSInteger )index{
    if (index==3) {
//        [self buniessAndHouseMoreShaiXuanClearning];//在确认按钮后也会调用到本方法 不可在此做清空
    }
}
//清空筛选 更多项目 的部分条件
- (void)buniessAndHouseMoreShaiXuanClearning{
    //
    self.queryModelBuniessShop.shopBusinessIdArrays = @[].mutableCopy;
    self.queryModelBuniessShop.shopTypeIdArrays = @[].mutableCopy;
    self.queryModelBuniessShop.houseSourceId = 0;
    
    //
    self.queryModelHouse.houseSourceId = 0;
    self.queryModelHouse.houseLeasetypeId = 0;
    self.queryModelHouse.houseLeasemodeId = 0;
    [self initData];
}
//清空当前筛选的全部项目条件 这部分做商铺房屋切换时调用
- (void)buniessAndHouseNamalShaiXuanClearning{

    //房屋
    self.queryModelHouse = [[HouseRentListVcHouseQueryTypesModel alloc]init];
    self.queryModelHouse .houseAdvantage = [NSArray array];//暂不知道是哪个键 保留

    //商铺
    self.queryModelBuniessShop = [[HouseRentListVcBuniessShopQueryTypesModel alloc]init];
    self.queryModelBuniessShop.shopTypeIdArrays = [[NSMutableArray alloc]init];
    self.queryModelBuniessShop.shopBusinessIdArrays = [[NSMutableArray alloc]init];
}
 
/*
 *自定义标题按钮视图  返回配置 参数说明
 offset       按钮的间距
 y            按钮的y坐标   自动会居中
*/
- (NSDictionary*)menu:(WMZDropDownMenu *)menu customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn *)menuBtn{
    if(section != BuniessRentMore_SectionNum){
        menuBtn.position = MenuBtnPositionLeft;
    }else  {
//        [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathLeft PathWidth:MenuK1px heightScale:1 button:menuBtn];
        [WMZDropMenuTool viewPathWithColor: [ThemeManager shareManager].mainTextColor PathType:MenuShadowPathLeft PathWidth:MenuK1px heightScale:1 button:menuBtn];
    }
    return @{@"offset":@(5)};
}

/*
*是否关联 其他标题 即选中其他标题 此标题会不会取消选中状态 default YES 取消，互不关联
*/
- (BOOL)menu:(WMZDropDownMenu *)menu dropIndexPathConnectInSection:(NSInteger)section{
    return NO;
}
/*
*更改选中后的标题
 @param currentTitle 为当前的标题 返回nil 表示用默认的标题
 @param selectBtn 为当前的标题按钮
 @return 可传字符串(更改的字符串标题)
         可传字典(标题和标题颜色) @{@"name":@"标题",@"selectColor":[UIColor redColor]}
*/
- (nullable id)menu:(WMZDropDownMenu *)menu changeTitle:(NSString*)currentTitle selectBtn:(WMZDropMenuBtn*)selectBtn atDropIndexPath:(WMZDropIndexPath *)dropIndexPath dataIndexPath:(NSInteger)row{
//    return @{@"name":currentTitle,@"selectColor":[UIColor whiteColor]};
    return @{@"name":currentTitle,@"selectColor":[ThemeManager shareManager].mainTextColor};
}
//更多 collectionfv确认按钮颜色
- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
    confirmView.confirmBtn.backgroundColor =  Color_38BlueColor;//COlor_Red255;
    [confirmView.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
//动态高度
//如果距离不对 可以自行修改此处
- (CGFloat)popFrameY{

    CGRect rect = [self.tableView convertRect:[self.tableView rectForHeaderInSection:0] toView:[self.tableView superview]];
    rect.origin.y+= (self.tableView.superview.frame.origin.y);
    return CGRectGetMaxY(rect);
}
 

  

@end
