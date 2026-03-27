//
//  FloorChooseTableViewController.m
//  Community
//
//  Created by 余莹 on 2020/11/26.
//

#import "FloorChooseTableViewController.h"
#import "FloorModel.h"
@interface FloorChooseTableViewController ()

@end

@implementation FloorChooseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self headerSearchViewHiden:YES];
}

- (void)initNav{
    self.title  = @"选择楼层";
}
- (void)resetSearchPlaceholder{
    self.headerView.searchBar.placeholder = @"输入楼层进行搜索";
}
#pragma mark === addRefresh
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshInitData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)refreshInitData{
    [self initData];
}
- (void)initData{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(Community_Type_Floor) forKey:@"queryType"];
    [parms setValue:@(self.buildingId) forKey:@"id"];
    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_MAIN_CHOOSE_COMMUNITY withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.dataSourceArr  = [NSMutableArray arrayWithArray:[FloorModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr]];
                [self.tableView reloadData];
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    FloorModel *model = self.dataSourceArr[indexPath.row];
    cell.textLabel.text = model.floor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FloorModel *model = self.dataSourceArr[indexPath.row];
    AddressesChooseTableViewController *floorVc = [[AddressesChooseTableViewController alloc]init];
    floorVc.floorId = model.id;
    [self.navigationController pushViewController:floorVc animated:YES];
}
@end
