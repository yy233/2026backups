//
//  AddressesChooseTableViewController.m
//  Community
//
//  Created by 余莹 on 2020/11/26.
//

#import "AddressesChooseTableViewController.h"
#import "AddressModel.h"
@interface AddressesChooseTableViewController ()

@end

@implementation AddressesChooseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self headerSearchViewHiden:YES];
}

- (void)initNav{
    self.title  = @"选择门牌号";
}
- (void)resetSearchPlaceholder{
    self.headerView.searchBar.placeholder = @"输入门牌进行搜索";
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
    [parms setValue:@(Community_Type_Addresses) forKey:@"queryType"];
    [parms setValue:@(self.floorId) forKey:@"id"];
    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_MAIN_CHOOSE_COMMUNITY withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.dataSourceArr  = [NSMutableArray arrayWithArray:[AddressModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr]];
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
    AddressModel *model = self.dataSourceArr[indexPath.row];
    cell.textLabel.text = model.door;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddressModel *model = self.dataSourceArr[indexPath.row];
    [self popUserCertificationVcWithName:model.door And:model.ID];
    /**
     (lldb) po self.navigationController.viewControllers
     <__NSFrozenArrayM 0x2813db960>(
     <CommunityManagementMainVC: 0x159e62e20>,
     <UserInfoRegistVC: 0x15ad5b160>,
     <UserCertificationViewController: 0x15adb2310>,
     <CityChooseTableViewController: 0x15c0a7630>,
     <CommunityChooseTableViewController: 0x15c20d900>,
     <UnitChooseTableViewController: 0x15c22bb80>,
     <BuildingNumChooseTableViewController: 0x15c242b80>,
     <FloorChooseTableViewController: 0x15c253620>,
     <AddressesChooseTableViewController: 0x15c262940>
     */
}
@end
