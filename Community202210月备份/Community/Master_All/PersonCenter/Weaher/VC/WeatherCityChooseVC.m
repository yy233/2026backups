//
//  WeatherCityChooseVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/25.
//

#import "WeatherCityChooseVC.h"

#import "CityChooseTableViewController.h"

#import "WeatherCityChooseHeaderView.h"
#import "WeatherCityChooseTopCityCell.h"
#import "WeatherCityChooseSectionHeaderViewWithTextLabel.h"
#import "WeatherCityChooseCell.h"
//Topcell 热门城市
#define WeatherCityChooseTopCityCell_Identifier @"WeatherCityChooseTopCityCell"
//#define cityItem_Max_H 50
//#define cityItem_OneLine_MaxNum 3
#define cityItem_Max_H 40
#define cityItem_OneLine_MaxNum 4
// 普通列表
#define cityCell_Nomal_H 60
//header
//#define CerTableViewCell_Height_cell_HeaderView 30
#define Notice_Name_ChooseCity  @"ChooseCityNotice"


@interface WeatherCityChooseVC () <WeatherCityChooseTopCityCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong) CityChooseHeadView *headerView;//弃用
@property (nonatomic,strong) WeatherCityChooseHeaderView *headerView;

@property(nonatomic, strong) UITableView *tableView;



@end

@implementation WeatherCityChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    [self initView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    //    [self initData];//冗余
    [self addRefresh];
}

- (void)initView{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableView *)tableView{
    if (!_tableView ){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(ios 11.0,*)) {
            // 针对 11.0 以上的iOS系统进行处理
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableView registerClass:[WeatherCityChooseTopCityCell class] forCellReuseIdentifier:WeatherCityChooseTopCityCell_Identifier];
        [_tableView registerClass:[WeatherCityChooseCell class] forCellReuseIdentifier:@"WeatherCityChooseCell_Identifier"];
    }
    return _tableView;
}


//重写
- (void)setupNavigationBarStyleWithMainColor{
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor
//    }];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]
    }];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].chooseUserCityAndOtherVcBackgroundColor] forBarMetrics:UIBarMetricsDefault];//
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];//
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self chanVcBackColor];
}
- (void)chanVcBackColor{
//    self.view.backgroundColor = [ThemeManager shareManager].chooseUserCityAndOtherVcBackgroundColor;
    self.view.backgroundColor = [UIColor whiteColor];
}
 
#pragma mark === addRefresh
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshInitData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)refreshInitData{
    [self getTopSourceData];//热门城市
    if (self.searchTextStr.length > 0) {//列表2种
        [self getSearchTextSourceData];//搜索文本 对应 单个的list
    }else{
        [self getBottomSourceData];//普通no搜索文本 对应的 建值字母的header 分组的list
    }
}

#pragma mark --- search  queryType=4&searchStr=be
//QueryType_CitySearchText
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.searchTextStr = searchText;
    if (searchText.length>0) {
        [self getSearchTextSourceData];
    }else{
        [self getBottomSourceData];//普通数据
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    if (self.searchTextStr.length > 0) {
        [self getSearchTextSourceData];
    }else{
        [self getBottomSourceData];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (self.searchTextStr.length > 0) {
        [self getSearchTextSourceData];
    }else{
        [self getBottomSourceData];
    }
    
}
#pragma mark == searchInitData
- (void)getSearchTextSourceData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(QueryType_CitySearchText) forKey:@"queryType"];
    [params setValue:self.searchTextStr forKey:@"searchStr"];
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_MAIN_CHOOSE_CITY withParams:params finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (isNotNil(Y_ResponsObject_dataArr)) {
                    //                    NSLog(@"__________searchInitData %@",responsObject[@"data"]);
                    self.searchSourceArr = [NSMutableArray arrayWithArray:Y_ResponsObject_dataArr];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    
                }
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark === initData
- (void)initData{
    [self getTopSourceData];
    [self getBottomSourceData];
}
- (void)getTopSourceData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(QueryType_HotCity) forKey:@"queryType"];
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_MAIN_CHOOSE_CITY withParams:params finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (isNotNil(Y_ResponsObject_dataArr)) {
                    self.topSourceArr = [NSMutableArray arrayWithArray:[CityChooseModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    
                }//else  空数据
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
- (void)getBottomSourceData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(QueryType_City) forKey:@"queryType"];
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_MAIN_CHOOSE_CITY withParams:params finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (isNotNil(Y_ResponsObject_dataArr)) {
                    self.bottomListSourceDic = [NSDictionary dictionaryWithDictionary: Y_ResponsObject_dataDic].mutableCopy;
                    NSArray *oldTitleArray = [NSArray arrayWithArray:[self.bottomListSourceDic allKeys]];//乱序
                    self.bottomListHeaderTitleSourceArr = [NSMutableArray arrayWithArray:[oldTitleArray sortedArrayUsingSelector:@selector(compare:)]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchTextStr.length > 0) {//
        return  1+1;//没有大写字母的这个层级，热门城市不变
    }else{
        return 1+self.bottomListHeaderTitleSourceArr.count;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return 1;
    }else{
        if (self.searchTextStr.length > 0) {//
            return  self.searchSourceArr.count;
        }else{
            NSString *key = [NSString stringWithString:self.bottomListHeaderTitleSourceArr[section-1]];
            NSArray *arrOfRow = [NSArray arrayWithArray:[self.bottomListSourceDic objectForKey:key]];
            return arrOfRow.count;
        }
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        CGFloat y = cityCell_Nomal_H;
        if (self.topSourceArr.count>0) {
            y = ceilf((float)self.topSourceArr.count/cityItem_OneLine_MaxNum)*cityItem_Max_H +10;
        }
        return y;
    }else{
        return cityCell_Nomal_H;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"热门城市";
    }else{
        if (self.searchTextStr.length > 0) {//
            return @"搜索结果";
        }else{
            return [NSString stringWithString:self.bottomListHeaderTitleSourceArr[section-1]];//字母
        }
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CerTableViewCell_Height_cell_HeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WeatherCityChooseSectionHeaderViewWithTextLabel *headerView = [[WeatherCityChooseSectionHeaderViewWithTextLabel alloc]initWithFrame:CGRectZero];
    if (section==0) {
        headerView.titleLabel.text = @"热门城市";
    }else{
        if (self.searchTextStr.length > 0) {//
            headerView.titleLabel.text = @"搜索结果";
        }else{
            headerView.titleLabel.text =  self.bottomListHeaderTitleSourceArr[section-1];//字母
            
        }
    }
    return headerView;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.bottomListHeaderTitleSourceArr;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {//热门城市
        WeatherCityChooseTopCityCell *cell = [tableView dequeueReusableCellWithIdentifier:WeatherCityChooseTopCityCell_Identifier];
        if (!cell) {
            cell = [[WeatherCityChooseTopCityCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:WeatherCityChooseTopCityCell_Identifier];
        }
        if (self.topSourceArr.count>0) {
            cell.delegate = self;
            cell.dataSourceArr = self.topSourceArr;//数组
        }
        return cell;
    }else{
        if (self.searchTextStr.length > 0) {//
            WeatherCityChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherCityChooseCell_Identifier"];
            if (!cell) {
                cell = [[WeatherCityChooseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"WeatherCityChooseCell_Identifier"];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
//            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            NSArray *arrOfRowModel = [CityChooseModel mj_objectArrayWithKeyValuesArray:self.searchSourceArr];
            CityChooseModel *model = arrOfRowModel[indexPath.row];
            cell.textLabel.text = model.name;
            return cell;
            
        }else{
            WeatherCityChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherCityChooseCell_Identifier"];
            if (!cell) {
                cell = [[WeatherCityChooseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"WeatherCityChooseCell_Identifier"];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
//            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            if (indexPath.section==0) {//
                cell.textLabel.text = [NSString stringWithFormat:@"%ld---section==0-",(long)indexPath.row];//?
            }else{
                //test
                //            NSString *key = [NSString stringWithString:self.bottomListHeaderTitleSourceArr[indexPath.section-1]];
                //            NSArray *arrOfRow = [NSArray arrayWithArray:[self.bottomListSourceDic objectForKey:key]];
                //            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary:arrOfRow[indexPath.row]];
                //            cell.textLabel.text = [NSString stringWithFormat:@"%ld----%@",(long)indexPath.row,[cityDic objectForKey:@"name"]];
                //model
                NSString *key = [NSString stringWithString:self.bottomListHeaderTitleSourceArr[indexPath.section-1]];
                NSArray *arrOfRowModel = [CityChooseModel mj_objectArrayWithKeyValuesArray:[self.bottomListSourceDic objectForKey:key]];
                CityChooseModel *model = arrOfRowModel[indexPath.row];
                cell.textLabel.text = model.name;
                
                
            }
            return cell;
        }
    }
    
}
#pragma mark ---did select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转到下一级别 换成返回上级+notice
    [self didBottomCellIndexPatch:indexPath];
}
- (void)didBottomCellIndexPatch:(NSIndexPath *)indexPath{
    if (indexPath.section>0) {//非热门城市
        if (self.searchTextStr.length > 0) {//
            NSArray *arrOfRowModel = [CityChooseModel mj_objectArrayWithKeyValuesArray:self.searchSourceArr];
            if (arrOfRowModel.count>=indexPath.row) {
                CityChooseModel *model = arrOfRowModel[indexPath.row];
               // NSLog(@"searchcell index  === %ld,%@",(long)model.id,model.name);
                [self popVcWithCityModel:model];
            }
        }else{
            NSString *key = [NSString stringWithString:self.bottomListHeaderTitleSourceArr[indexPath.section-1]];
            //        NSArray *arrOfRow = [NSArray arrayWithArray:[self.bottomListSourceDic objectForKey:key]];
            NSArray *arrOfRowModel = [CityChooseModel mj_objectArrayWithKeyValuesArray:[self.bottomListSourceDic objectForKey:key]];
            CityChooseModel *model = arrOfRowModel[indexPath.row];
            //NSLog(@"didBottomCellIndexPatch === %ld,%@",(long)model.id,model.name);
            [self popVcWithCityModel:model];
        }
    }
}
#pragma mark === topCityTableViewCellBtnAction 热门城市model
-(void)topCityTableViewCellBtnAction:(UIButton *)sender{
    NSInteger indexNum = sender.tag-Main_SUB_CityChoose_TopCityItem_TAG;
    CityChooseModel *model = self.topSourceArr[indexNum];
   // NSLog(@"topCityCellBtnAction === %ld,%@",(long)model.id,model.name);
    [self popVcWithCityModel:model];
}
#pragma mark === push
- (void)popVcWithCityModel:(CityChooseModel *)model{
    NSDictionary *userInfoDic = @{@"userInfo":model};
    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(Notice_Name_ChooseCity, userInfoDic);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ==== getter
#pragma mark -- headview
- (WeatherCityChooseHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[WeatherCityChooseHeaderView alloc]initWithFrame:CGRectMake(0 , 0, Screen_W, 40)];
        _headerView.searchBar.delegate = self;
        _headerView.searchBar.placeholder = @"输入城市名、拼音或者首字母查询";
    }
    return _headerView;
}

- (NSMutableArray *)topSourceArr{
    if (!_topSourceArr) {
        _topSourceArr = [NSMutableArray array];
    }
    return _topSourceArr;
}
- (NSMutableArray *)bottomListHeaderTitleSourceArr{
    if (!_bottomListHeaderTitleSourceArr) {
        _bottomListHeaderTitleSourceArr = [NSMutableArray array];
    }
    return _bottomListHeaderTitleSourceArr;
}
- (NSMutableDictionary *)bottomListSourceDic{
    if (!_bottomListSourceDic) {
        _bottomListSourceDic = [NSMutableDictionary dictionary];
    }
    return _bottomListSourceDic;
}

- (NSString *)searchTextStr{
    if (!_searchTextStr) {
        _searchTextStr = @"";
    }
    return _searchTextStr;
}
- (NSMutableArray *)searchSourceArr{
    if (!_searchSourceArr) {
        _searchSourceArr = [NSMutableArray array];
    }
    return _searchSourceArr;
}

#pragma mark - other

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
}

@end
