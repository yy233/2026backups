//
//  RentMainListVC.m
//  Community
//
//  Created by 余莹 on 2021/6/21.
// 新的租赁主页列表 商铺+房屋

#import "RentMainListVC.h"
#import "HouseRentHouseDetailVc.h"
#import "HouseRentBuniessShopDetailVc.h"
//view
#import "HouseRentNavSearchView.h"
#import "HouseRentHeaderView.h"
#import "HouseRentSectionHeaderView.h"
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

#define Cell_H  100
#define Cell_headerView_H  50
#define Cell_sectionheaderView_H  30
@interface RentMainListVC ()<HouseRentHeaderViewChooseTypeDelegate,HouseRentSectionHeaderViewDelegate,HouseBuniesShopSectionHeaderViewDeleagete,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,HouseRentChooseHouseTypeViewOkBtnDelegate,HouseRentChooseHouseMoreViewOkBtnDelegate,GHDropMenuDelegate,GHDropMenuDataSource,WMZDropMenuDelegate>
//商铺筛选
//@property (nonatomic , strong)GHDropMenu *dropMenuBuniessShop;
{
    WMZDropDownMenu *menu;
    BOOL showDetail;
}
//
@property (nonatomic,strong) HouseRentNavSearchView *navSearchView;
@property (nonatomic,strong) HouseRentHeaderView *headerView;
@property (nonatomic,strong) HouseRentSectionHeaderView *sectionHeaderViewHouse;
@property (nonatomic,strong) HouseBuniesShopSectionHeaderView *sectionHeaderViewBuniess;
@property (nonatomic,strong) HouseRentChooseHouseTypeView *chooseHouseTypePickView;
@property (nonatomic,strong) HouseRentChooseHouseMoreView *chooseHouseMoreView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSString *searchTextStr;
@property (nonatomic,strong) NSMutableArray *dataSourceHouse;
@property (nonatomic,strong) NSMutableArray *dataSourceBuniessShop;
@property (nonatomic,strong) HouseRentListVcHouseQueryTypesModel *queryModelHouse;
@property (nonatomic,strong) HouseRentListVcBuniessShopQueryTypesModel *queryModelBuniessShop;
@property (nonatomic,assign) NSInteger pageNum;
//
@property (nonatomic,strong) NSMutableArray *houseSaveMoreSelectedModelArr;

//保留原本的代码
@end

@implementation RentMainListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTextStr = @"";
    [self initView];
    [self addRefresh];
    Y_SVP_SHOW_MES_IsDealing
    [self initData];
    [self initBuniessShopChooseMenu];//商铺筛选view
}
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
    [HouseRentVCListViewModel getRentVcBuniessShopListArrWithParm:parms WithBlock:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
        });
        if (success) {
            self.pageNum += 1;
            self.dataSourceBuniessShop = [NSMutableArray arrayWithArray:[HouseRentListVcBuniessShopCellModel mj_objectArrayWithKeyValuesArray:arr]];
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
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(self.pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
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

#pragma mark === ChooseType
- (void)houseRentHeaderViewChooseTypeSubBtnTouchChooseType:(MainCellRecommendedServiceHourse_Rent_Type)type{
    self.viewType  = type;
    if (self.viewType == MainCellRecommendedServiceHourse_Type_RentHouse) {
        self.sectionHeaderViewHouse.hidden = NO;
        self.sectionHeaderViewBuniess.hidden = YES;
    }else{
        self.sectionHeaderViewHouse.hidden = YES;
        self.sectionHeaderViewBuniess.hidden = NO;
    }
    NSLog(@"切换 %lu",(unsigned long)type);
    Y_SVP_SHOW_MES_IsDealing
    [self initData];
    
}

#pragma mark ===
- (void)initView{
    [self navView];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    //house 筛选view
    [self.view addSubview: self.sectionHeaderViewHouse];
    [_sectionHeaderViewHouse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sectionHeaderViewHouse.superview.mas_top).offset(Cell_headerView_H);//chooseBtn
        make.left.equalTo(_sectionHeaderViewHouse.superview.mas_left);
        make.right.equalTo(_sectionHeaderViewHouse.superview.mas_right);
        make.height.offset(Cell_sectionheaderView_H);
    }];
    //buniess 筛选view
    [self.view addSubview: self.sectionHeaderViewBuniess];
    [_sectionHeaderViewBuniess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sectionHeaderViewHouse.superview.mas_top).offset(Cell_headerView_H);//chooseBtn
        make.left.equalTo(_sectionHeaderViewHouse.superview.mas_left);
        make.right.equalTo(_sectionHeaderViewHouse.superview.mas_right);
        make.height.offset(Cell_sectionheaderView_H);
    }];
    if (self.viewType == MainCellRecommendedServiceHourse_Type_RentHouse) {
        self.sectionHeaderViewHouse.hidden = NO;
        self.sectionHeaderViewBuniess.hidden = YES;
    }else{
        self.sectionHeaderViewHouse.hidden = YES;
        self.sectionHeaderViewBuniess.hidden = NO;
    }
    [self.headerView setNowBtnSelectedWithType:self.viewType];//当前商铺or租房
    
    //
    [self.view addSubview:self.chooseHouseTypePickView];
    self.chooseHouseTypePickView.hidden = YES;
    //
    [self.view addSubview:self.chooseHouseMoreView];
    self.chooseHouseMoreView.hidden = YES;
    
}
#pragma mark --- search   searchStr
//QueryType_CitySearchText
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.searchTextStr = searchText;
    if (searchText.length>0) {
        //        [self getSearchTextSourceData];
    }else{
        //普通数据
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
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
    [infoRightBtn newAnBtnWithImg:[UIImage imageNamed:@"head_news_night"]];
    infoRightBtn.bounds = CGRectMake(0 , 0, 24, 24);
    [infoRightBtn addTarget:self action:@selector(infoRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoRightBarItem = [[UIBarButtonItem alloc]initWithCustomView:infoRightBtn];
    [self.navigationItem setRightBarButtonItem:infoRightBarItem animated:YES];
}
- (void)infoRightItemAction:(UIButton *)sender{
    NSLog(@"右按钮");
}
#pragma mark === delegate
- (void)chooseNoCell{
    [self sectionHeightUpEqutoCellsectionheaderViewH];
}
- (void)sectionHeightUpEqutoCellsectionheaderViewH{//会挡住不可点击 在sectionHeaderViewHouse内更改高度
    //    self.sectionHeaderViewHouse.userInteractionEnabled = NO;//会一次性使用后不可再用
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sectionHeaderViewHouse mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(Cell_sectionheaderView_H);
        }];
    });
}
- (void)touchUpHouseCityQuBtn{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [HouseRentVcAllQueryTypesChooseViewModel getCityQuArr:^(NSArray * arr, BOOL success) {
        if (success) {
            Y_SVP_DISMISS
            DLog(@"%@",arr);//name
            //            dispatch_async(dispatch_get_main_queue(), ^{});
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sectionHeaderViewHouse mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(Screen_H-KNavBarHeight-Cell_headerView_H);//底部==selfbottom
                }];
                [self.sectionHeaderViewHouse showTableViewWithArr:arr withType:cell_type_city];
            });
            
        }
    }];
    DLog()
}
- (void)chooseCellWithCityDic:(NSDictionary *)citydic{
    NSLog(@"citydic= %@",citydic);
    [self.sectionHeaderViewHouse.cityQuBtn setTitle:citydic[@"name"] forState:UIControlStateNormal];
    self.queryModelHouse.houseAreaId = citydic[@"id"];
    [self initHouseListData];//加载新数据
    [self sectionHeightUpEqutoCellsectionheaderViewH];
}
- (void)touchUpHouseMoneyBtn{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [HouseRentVcAllQueryTypesChooseViewModel getMoneyArr:^(NSArray * arr, BOOL success) {//租金
        if (success) {
            Y_SVP_DISMISS
            DLog(@"%@",arr);//
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sectionHeaderViewHouse mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(Screen_H-KNavBarHeight-Cell_headerView_H);//底部==selfbottom
                }];
                [self.sectionHeaderViewHouse showTableViewWithArr:arr withType:cell_type_money];
            });
        }
    }];
    DLog()
}
- (void)chooseCellWithMoneyDic:(NSDictionary *)moneydic{
    NSLog(@"moneydic= %@",moneydic);
    NSArray *a =  [moneydic[@"houseConstValue"] componentsSeparatedByString:@","];
    if (a.count==2) {
        [self.sectionHeaderViewHouse.moneyBtn setTitle:moneydic[@"houseConstName"] forState:UIControlStateNormal];
        self.queryModelHouse.housePriceMin = [a.firstObject doubleValue];
        self.queryModelHouse.housePriceMax = [a.lastObject doubleValue];
        [self initHouseListData];//加载新数据
    }
    [self sectionHeightUpEqutoCellsectionheaderViewH];
}
//HouseTyp弃用下拉框 使用滚轮
- (void)touchUpHouseHouseTypeBtn{
    [self.sectionHeaderViewHouse hiddenTableView];//还原其他筛选
    [self.sectionHeaderViewHouse hiddenMoreView];
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
    [self sectionHeightUpEqutoCellsectionheaderViewH];
    self.chooseHouseTypePickView.hidden = YES;
}
//房屋租_更多_筛选
- (void)touchUpHouseMoreBtn{
    [HouseRentVcAllQueryTypesChooseViewModel getMoreArr:^(NSDictionary * dic, BOOL success) {
        if (success) {
            DLog(@"%@",dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.chooseHouseMoreView showHouseMoreChooseViewWithAnimationWithDic:dic withSelectModelArr:self.houseSaveMoreSelectedModelArr];
            });
        }
    }];
}
- (void)chooseCellWithMoreDic:(NSDictionary *)moredic{//more 多个键值
    [self sectionHeightUpEqutoCellsectionheaderViewH];
    NSLog(@"moredic= %@",moredic);
}
#pragma  mark == 房屋 更多
- (void)houseMoreChooseWithArr:(NSMutableArray *)arr{
    
    if (arr.count==0) {//重置 空
        self.houseSaveMoreSelectedModelArr = [[NSMutableArray alloc]init];
        self.queryModelHouse.houseAdvantage  = @[];
        self.queryModelHouse.houseLeasemodeId = 1;
        self.queryModelHouse.houseLeasetypeId = 1;
        self.queryModelHouse.houseSourceId = 1;
        [self initHouseListData];//加载新数据
        return;
    }else{
        self.houseSaveMoreSelectedModelArr = arr;
    }
    
    // 非空
    HouseRentMoreShaixuanModel *model = arr.lastObject;
    
    NSLog(@"---房屋 更多----%@",model.houseConstName);
    if (model.houseConstType==12) {//    @"押一付一"  可短租等
        // @"出租房源类型"
        if ([model.houseConstName containsString:@"装修"]) {
            self.queryModelHouse.houseAdvantage = @[@(model.houseConstCode)];
        }
    }
    if (model.houseConstType==11) {// @"租房方式"
        //        self.queryModelHouse.houseLeasemodeId = model.houseConstCode;//按出租方式搜索code 1不限(默认) 2整租，4合租
        self.queryModelHouse.houseLeasemodeId = model.houseConstCode; //++多选？
        
    }
    if (model.houseConstType==10) { //   @"普通住宅" //按出租类型code搜索  1不限(默认) 2普通住宅 4别墅 8公寓
        self.queryModelHouse.houseLeasetypeId = model.houseConstCode;
    }
    if (model.houseConstType==9) {// @"房屋来源"
        self.queryModelHouse.houseSourceId = model.houseConstCode;//按房屋来源搜索   1.不限 2.个人 4.物业
    }
    [self initHouseListData];//加载新数据
    
    //    self.queryModelHouse.houseAdvantage = @[model.]
    //    model.houseConstType =
    
    //    self.queryModelHouse.
    //
    
}
//- (void)touchUpHouseMoreBtn{
//    [HouseRentVcAllQueryTypesChooseViewModel getMoreArr:^(NSDictionary * dic, BOOL success) {
//        if (success) {
//            DLog(@"%@",dic);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.sectionHeaderViewHouse mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.offset(Screen_H-KNavBarHeight-Cell_headerView_H);//底部==selfbottom
//                }];
//                [self.sectionHeaderViewHouse showMoreViewWithDic:dic];
//            });
//        }
//    }];
//    DLog()
//}
//- (void)chooseCellWithMoreDic:(NSDictionary *)moredic{//more 多个键值
//    [self sectionHeightUpEqutoCellsectionheaderViewH];
//    NSLog(@"moredic= %@",moredic);
//}
#pragma mark === delegate
- (void)touchUpBuniesShopCityQuBtn{
    Y_SVP_SHOW_SUCCESS_MES(@"当前城市 暂不支持商铺筛选");
    
    
    
    
    
    [HouseRentVcAllQueryTypesChooseViewModel getCityQuArr:^(NSArray * arr, BOOL success) {
        if (success) {
            DLog(@"%@",arr);
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });//name
        }
    }];
    DLog()
}
- (void)touchUpBuniesShopMoneyBtn{
    Y_SVP_SHOW_SUCCESS_MES(@"当前城市 暂不支持商铺筛选");
    
    
    
    
    
    [HouseRentVcAllQueryTypesChooseViewModel getMoneyArr:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
    DLog()
}
- (void)touchUpBuniesShopAreaSpaceBtn{
    Y_SVP_SHOW_SUCCESS_MES(@"当前城市 暂不支持商铺筛选");
    
    
    
    
    
    [HouseRentVcAllQueryTypesChooseViewModel getBuniessAreaSpaceeArr:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
    DLog()
}
- (void)touchUpBuniesShopMoreBtn{
    Y_SVP_SHOW_SUCCESS_MES(@"当前城市 暂不支持商铺筛选");
    
    
    
    
    
    [HouseRentVcAllQueryTypesChooseViewModel getBuniessMoreArr:^(NSDictionary * dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //more
        });
    }];
    DLog()
}
#pragma mark ===
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{//50 30
    //筛选view处理
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        self.sectionHeaderViewHouse.hidden = NO;
        self.sectionHeaderViewBuniess.hidden = YES;
        [_sectionHeaderViewHouse mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sectionHeaderViewHouse.superview.mas_top).offset(Cell_headerView_H-scrollView.contentOffset.y);//chooseBtn
        }];
        //        if (scrollView.contentOffset.y<=Cell_headerView_H) {
        //            self.sectionHeaderViewHouse.hidden = NO;
        //
        //            [_sectionHeaderViewHouse mas_updateConstraints:^(MASConstraintMaker *make) {
        //                make.top.equalTo(_sectionHeaderViewHouse.superview.mas_top).offset(Cell_headerView_H-scrollView.contentOffset.y);//chooseBtn
        //            }];
        //        }else{
        //            [_sectionHeaderViewHouse mas_updateConstraints:^(MASConstraintMaker *make) {
        //                make.top.equalTo(_sectionHeaderViewHouse.superview.mas_top).offset(Cell_headerView_H);//chooseBtn
        //            }];
        //            self.sectionHeaderViewHouse.hidden = YES;
        //        }
    }else{//商铺
        self.sectionHeaderViewHouse.hidden = YES;
        self.sectionHeaderViewBuniess.hidden = NO;
        [_sectionHeaderViewBuniess mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sectionHeaderViewHouse.superview.mas_top).offset(Cell_headerView_H-scrollView.contentOffset.y);//chooseBtn
            make.left.equalTo(_sectionHeaderViewHouse.superview.mas_left);
            make.right.equalTo(_sectionHeaderViewHouse.superview.mas_right);
            make.width.offset(Cell_sectionheaderView_H);
        }];
        //        if (scrollView.contentOffset.y<=Cell_headerView_H) {
        //            self.sectionHeaderViewHouse.hidden = NO;
        //            [_sectionHeaderViewHouse mas_updateConstraints:^(MASConstraintMaker *make) {
        //                make.top.equalTo(_sectionHeaderViewHouse.superview.mas_top).offset(Cell_headerView_H-scrollView.contentOffset.y);//chooseBtn
        //                make.left.equalTo(_sectionHeaderViewHouse.superview.mas_left);
        //                make.right.equalTo(_sectionHeaderViewHouse.superview.mas_right);
        //                make.width.offset(Cell_sectionheaderView_H);
        //            }];
        //        }else{
        //            [_sectionHeaderViewHouse mas_updateConstraints:^(MASConstraintMaker *make) {
        //                make.top.equalTo(_sectionHeaderViewHouse.superview.mas_top).offset(Cell_headerView_H);//chooseBtn
        //                make.left.equalTo(_sectionHeaderViewHouse.superview.mas_left);
        //                make.right.equalTo(_sectionHeaderViewHouse.superview.mas_right);
        //                make.width.offset(Cell_sectionheaderView_H);
        //            }];
        //            self.sectionHeaderViewHouse.hidden = YES;
        //        }
    }
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
    //用于给sectionHeaderViewHouse sectionHeaderViewBuniess 占位
    if (self.viewType==MainCellRecommendedServiceHourse_Type_RentHouse) {   //房屋
        return [UIView new];
    }else{
        return [UIView new];
    }
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

#pragma mark ===
- (HouseRentNavSearchView *)navSearchView{
    if (!_navSearchView) {
        _navSearchView = [[HouseRentNavSearchView alloc]initWithFrame: CGRectMake(0, 0, Screen_W-100, KNavBarHeight)];
    }
    return _navSearchView;
}
- (HouseRentHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HouseRentHeaderView alloc]init];//商铺 租房 切换的headerview
        _headerView.delegate = self;
    }
    return _headerView;
}
- (HouseRentSectionHeaderView *)sectionHeaderViewHouse{
    if (!_sectionHeaderViewHouse) {
        _sectionHeaderViewHouse = [[HouseRentSectionHeaderView alloc]init];
        _sectionHeaderViewHouse.frame =  CGRectMake(0, 0, Screen_W, Screen_H-KNavBarHeight-50);//50 choose切换btn
        _sectionHeaderViewHouse.delegate = self;
    }
    return _sectionHeaderViewHouse;
}
- (HouseBuniesShopSectionHeaderView *)sectionHeaderViewBuniess{
    if (!_sectionHeaderViewBuniess) {
        _sectionHeaderViewBuniess = [[HouseBuniesShopSectionHeaderView alloc]init];
        _sectionHeaderViewBuniess.frame =  CGRectMake(0, 0, Screen_W, Screen_H-KNavBarHeight-50);//50 choose切换btn
        _sectionHeaderViewBuniess.delegateBuniesShop = self;
    }
    return _sectionHeaderViewBuniess;
}
- (HouseRentChooseHouseTypeView *)chooseHouseTypePickView{
    if (!_chooseHouseTypePickView) {
        _chooseHouseTypePickView = [[HouseRentChooseHouseTypeView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    }
    _chooseHouseTypePickView.delegate = self;
    return _chooseHouseTypePickView;
}
- (HouseRentChooseHouseMoreView *)chooseHouseMoreView{
    if (!_chooseHouseMoreView) {
        _chooseHouseMoreView = [[HouseRentChooseHouseMoreView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-KNavBarHeight)];
    }
    _chooseHouseMoreView.delegate = self;
    return _chooseHouseMoreView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
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
        //        _queryModelHouse.houseAdvantage = [NSArray array];
        //        _queryModelHouse.searchText = @"";
        //        _queryModelHouse.houseTypeCode = @"";
        //        _queryModelHouse.houseAreaId = @"";
    }
    return _queryModelHouse;
}
- (HouseRentListVcBuniessShopQueryTypesModel *)queryModelBuniessShop{
    if (_queryModelBuniessShop) {
        _queryModelBuniessShop = [[HouseRentListVcBuniessShopQueryTypesModel alloc]init];
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

#pragma mark =========================================================================== 商铺的筛选
//- (void)initBuniessShopChooseMenu{
////    /** 配置筛选菜单模型 */
//    GHDropMenuModel *configuration = [[GHDropMenuModel alloc]init];
//    /** 配置筛选菜单是否记录用户选中 默认NO */
//    configuration.recordSeleted = NO;
//    /** 设置数据源 */
//    configuration.titles = [configuration creaDropMenuData];
//    CGRect menuFram =  CGRectMake(0, 0, Screen_W, 30); //self.sectionHeaderViewBuniess.frame;
//    GHDropMenu *dropMenu =  [GHDropMenu creatDropMenuWithConfiguration:configuration frame:menuFram  dropMenuTitleBlock:^(GHDropMenuModel * _Nonnull dropMenuModel) {
//
//    } dropMenuTagArrayBlock:^(NSArray * _Nonnull tagArray) {
//
//    }];
//    dropMenu.delegate = self;
//    dropMenu.durationTime = 0.5;
//    self.dropMenuBuniessShop = dropMenu;
//    [self.sectionHeaderViewBuniess addSubview:dropMenu];
//}
- (void)initBuniessShopChooseMenu{
    
    
    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(0)
    .wCollectionViewCellSelectTitleColorSet(MenuColor(0xFF513c))
    .wCollectionViewSectionRecycleCountSet(3)
    .wMaxHeightScaleSet(0.6)
    .wBorderShowSet(YES)
    .wBorderUpDownShowSet(YES)
    .wCellSelectShowCheckSet(NO);
    
    menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    //    [self.view addSubview:menu];
}

- (void)showData:(BOOL)show{
    if (showDetail == show) return;
    [menu updateData:show?@[@"不限",@"一室",@"两室",@"三室",@"四室及以上"]:nil AtDropIndexPathSection:2 AtDropIndexPathRow:1];
    CGFloat timeHeight = show?150:-150;
    CGRect dataViewRect = menu.dataView.frame;
    dataViewRect.size.height += timeHeight;
    menu.dataView.frame = dataViewRect;
    for (UICollectionView *collectionView in menu.showView) {
        if ([collectionView isKindOfClass:[UICollectionView class]]) {
            CGRect collectionViewRect = collectionView.frame;
            collectionViewRect.size.height += timeHeight;
            collectionView.frame = collectionViewRect;
            [collectionView reloadData];
        }
    }
    CGRect confirmViewRect = menu.confirmView.frame;
    confirmViewRect.origin.y += timeHeight;
    menu.confirmView.frame = confirmViewRect;
    showDetail = show;
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
        @{@"name":@"全广州",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
        @{@"name":@"租金",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
        @{@"name":@"户型",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
        @{@"name":@"更多",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 2;
    }else if (section == 2){
        return 2;
    }else if (section == 3){
        return 4;
    }
    
    return 1;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0){
        if (dropIndexPath.row == 0) return @[@"附近",@{@"name":@"区域"},@"地铁",@"学校"];
        if (dropIndexPath.row == 1) return @[@"1号线",@"2号线",@"3号线",@"4号线",@"5号线",
                                             @"1号线",@"2号线",@"3号线",@"4号线",@"5号线",
                                             @"1号线",@"2号线",@"3号线",@"4号线",@"5号线"];
    }else if (dropIndexPath.section == 1){
        return @[@"500元以下",@"500-1000",@"1000-1500",@"1500-2000",@"2500-3000",@"2500-3000",@"2500-3000",];
    }else if (dropIndexPath.section == 2){
        if (dropIndexPath.row == 0) return @[@"展开",@"收缩"];
    }else if (dropIndexPath.section == 3){
        if (dropIndexPath.row == 0) return @[@"不限",@"个人",@"经纪人",@"品牌公寓"];
        if (dropIndexPath.row == 1) return @[@"不限",@"安选"];
        if (dropIndexPath.row == 2) return @[@"不限",@"压一付一",@"压一付一",@"压一付一",@"压一付一",
                                             @"压一付一",@"压一付一",
                                             @"压一付一",@"压一付一",@"压一付一",@"压一付一",
                                             @"压一付一",@"压一付一",@"压一付一",@"压一付一"];
        if (dropIndexPath.row == 3) return @[@"不限",@"东",@"西",@"南",@"北",@"南北"];
    }
    return @[];
}

#define titleArr1 @[@"卧室",@"户型"]
#define titleArr2 @[@"房间来源",@"验真情况",@"房源特色",@"朝向"]
- (NSString *)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 2){
        return titleArr1[dropIndexPath.row];
    }else if (dropIndexPath.section == 3){
        return titleArr2[dropIndexPath.row];
    }
    return @"";
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return 3;
}
/*
 *是否关联 其他标题 即选中其他标题 此标题会不会取消选中状态 default YES
 */
- (BOOL)menu:(WMZDropDownMenu *)menu dropIndexPathConnectInSection:(NSInteger)section{
    return NO;
}

//- (NSDictionary*)menu:(WMZDropDownMenu *)menu  customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn*)menuBtn{
//    if (section == 1) {
//        //选中中间清除其他所有选中
//        menuBtn.clear = YES;
//    }
//    return @{};
//}


/*
 *互斥的标题数组 即互斥不能同时选中 返回标题对应的section (配合关联代理使用更加)
 */
//- (NSArray*)mutuallyExclusiveSectionsWithMenu:(WMZDropDownMenu *)menu{
//    return @[@(0),@(1)];
//}



- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (dropIndexPath.section == 0 || dropIndexPath.section == 1) {
        return 50;
    }
    return 35;
}

- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 2||dropIndexPath.section == 3) {
        return MenuUICollectionView;
    }
    return MenuUITableView;
}

- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    if (section==3) {
        return MenuHideAnimalLeft;
    }
    return MenuHideAnimalTop;
}

- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    if (section==3) {
        return MenuShowAnimalRight;
    }
    return MenuShowAnimalBottom;
}


- (UITableViewCell*)menu:(WMZDropDownMenu *)menu cellForUITableView:(WMZDropTableView *)tableView AtIndexPath:(NSIndexPath *)indexpath dataForIndexPath:(WMZDropTree *)model{
    if (tableView.dropIndex.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        cell.textLabel.text = model.name;
        cell.textLabel.textColor = model.isSelected?MenuColor(0xFF513c):MenuColor(0x666666);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellNULL"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellNULL"];
        }
        return cell;
    }
    return nil;
}
- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0&&dropIndexPath.row == 1)  return YES;
    else if (dropIndexPath.section == 1) return YES;
    return NO;
}

- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
    confirmView.showBorder = NO;
    confirmView.resetFrame = [NSValue valueWithCGRect:CGRectMake(0, 0,0 , confirmView.frame.size.height)];
    confirmView.confirmFrame = [NSValue valueWithCGRect:CGRectMake(0, 0,confirmView.frame.size.width , confirmView.frame.size.height)];
    confirmView.confirmBtn.backgroundColor = MenuColor(0xFF513c);
    [confirmView.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}



-  (void)menu:(WMZDropDownMenu *)menu didSelectRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath dataIndexPath:(NSIndexPath *)indexpath data:(WMZDropTree *)data{
    if (dropIndexPath.section == 0 && dropIndexPath.row == 1) {
        if (indexpath.row == 0) {
            [menu updateDataConfig:@{@"isSelected":@(NO)} AtDropIndexPathSection:2 AtDropIndexPathRow:0 AtIndexPathRow:2];
        }
    }else if (dropIndexPath.section == 2 && dropIndexPath.row == 0) {
        if (indexpath.row == 0) {
            data.isSelected?[self showData:YES]:[self showData:NO];
        }else{
            data.isSelected?[self showData:NO]:[self showData:YES];
        }
    }
}

@end
