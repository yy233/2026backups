//
//  CommunityChooseTableViewController.m
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import "CommunityChooseTableViewController.h"
#define Notice_Name_ChooseCommunity @"ChooseCommunityNotice"

@interface CommunityChooseTableViewController () <UISearchBarDelegate>


@end

@implementation CommunityChooseTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefresh];
}
- (void)initNav{
    self.title  = @"选择社区";
}
- (void)headerSearchViewHiden:(BOOL)isHiden{
    self.tableView.tableHeaderView = self.communityHeaderView;
    [self.communityHeaderView.nowCityShowBtn setTitle:self.cityModel.name forState:UIControlStateNormal];
    [self.communityHeaderView.nowCityShowBtn addTarget:self action:@selector(nowCityShowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark === addRefresh
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshInitData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)refreshInitData{
    [self initData];
}
#pragma mark == city btn
- (void)nowCityShowBtnAction:(UIButton *)sender{
    //城市列表 城市数据
    DLog(@"城市列表 城市数据")
}
- (void)initData{//城市ID查出小区list
 
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(1) forKey:@"queryType"];
    [parms setValue:@(self.cityId) forKey:@"id"];
     [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_MAIN_CHOOSE_COMMUNITY withParams:parms  finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.dataSourceArr  = [NSMutableArray arrayWithArray:[CommunityModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
               
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}
//模糊搜索时。不用mode和type两个键
- (void)searchInitData{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    /**
     {
     "cityId": 1,
     "lat": 120.3,
     "lon": 215,
     "name": "小区"
     }*/
//    [parms setValue:@(queryType_cityId_GetCommunity) forKey:@"queryType"];
    [parms setValue:@(self.cityId) forKey:@"cityId"];
//    [parms setValue:self.headerView.searchBar.text forKey:@"name"];
    [parms setValue:self.searchTextStr forKey:@"name"];
     BOOL haveLatAndLong = NO;
    if ([ShareUserInfo sharedUserInfo].userInfo.nowLatitude!=0 || [ShareUserInfo sharedUserInfo].userInfo.nowLongitude != 0 || [ShareUserInfo sharedUserInfo].commuityInfo.lat!=0 || [ShareUserInfo sharedUserInfo].commuityInfo.lon!=0 ) {
        haveLatAndLong = YES;
    }
    if (haveLatAndLong) {
        [parms setValue:@([ShareUserInfo sharedUserInfo].userInfo.nowLatitude) forKey:@"lat"];
        [parms setValue:@([ShareUserInfo sharedUserInfo].userInfo.nowLongitude) forKey:@"lon"];//
    }else{
        [parms setValue:@(0) forKey:@"lat"];
        [parms setValue:@(0) forKey:@"lon"];
    }
    [[ToolOfNetWork sharedTools]YrequestPostURL:URL_MAIN_CHOOSE_COMMUNITY_SEARCH withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.dataSourceArr  = [NSMutableArray arrayWithArray:[CommunityModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr]];
                [self.tableView reloadData];
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark - search bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.searchTextStr = searchText;
    if (searchText.length>0) {
        [self searchInitData];
    }else{
        [self initData];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.searchTextStr = searchBar.text;
    if (self.searchTextStr.length > 0) {
        [self searchInitData];
    }else{
        [self initData];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchTextStr = searchBar.text;
    if (self.searchTextStr.length > 0) {
        [self searchInitData];
    }else{
        [self initData];
    }
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];//[UIFont systemFontOfSize:12];
    CommunityModel *model = self.dataSourceArr[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommunityModel *model = self.dataSourceArr[indexPath.row];
    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(Notice_Name_ChooseCommunity, @{@"userInfo":model});
    [self.navigationController popViewControllerAnimated:YES];
}
@end
