//
//  BuildingNumChooseTableViewController.m
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import "BuildingNumChooseTableViewController.h"
#define Notice_Name_ChooseBuild @"ChooseBuildNotice"
@interface BuildingNumChooseTableViewController ()

@end

@implementation BuildingNumChooseTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefresh];
}

- (void)initNav{
    self.title  = @"选择楼栋";
}
- (void)resetSearchPlaceholder{
    self.headerView.searchBar.placeholder = @"输入楼栋名进行搜索";
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
    
    DLog(@"Community_Type_Building %@",self.baseParms);
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_MAIN_CHOOSE_COMMUNITY withParams:self.baseParms finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if ([[responsObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *resDic = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                    if ([resDic allKeys].count == 0) {
                        Y_SVP_SHOW_ERR_MES(@"暂无数据");
                        return;
                    }else{
//
                      NSArray *keyArr =  [resDic allKeys];
                        if (keyArr.count==0) {
                            Y_SVP_SHOW_ERR_MES(@"暂无数据");
                            return;
                        }else{
                            for (int i = 0; i <keyArr.count; i ++) {
                                NSString *keyStr = [NSString stringWithString:keyArr[i]];
                                if ([keyStr isEqualToString:@"buildingList"]) {
                                    NSMutableArray *buildArr = [NSMutableArray arrayWithArray:resDic[keyStr]];
                                    self.dataSourceArr = [NSMutableArray arrayWithArray:[BuildingModel mj_objectArrayWithKeyValuesArray:buildArr]];
                                    if(self.dataSourceArr.count==0){
                                        Y_SVP_SHOW_ERR_MES(@"暂无楼栋");
                                    }
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.tableView reloadData];
                                    });
                                    
                                }
                            }
 
                        }
                    }
                    
                }else{
                    self.dataSourceArr  = [NSMutableArray arrayWithArray:[BuildingModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr]];
                    if(self.dataSourceArr.count==0){
                        Y_SVP_SHOW_ERR_MES(@"暂无楼栋");
                    }
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

/**
 data =     {
     buildingList =         (
                     {
             building = "测试楼栋改";
             id = 32255761711239168;
             type = building;
         }
     );
     unitList =         (
                     {
             id = 30812494742294528;
             type = unit;
             unit = "测试单元1";
         },
                     {
             id = 30814249387429888;
             type = unit;
             unit = "测试单元2";
         },
                     {
             id = 32560865588940801;
             type = unit;
             unit = "独立单元";
         }
     );
 };
 message = "<null>";
 */
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
    BuildingModel *model = self.dataSourceArr[indexPath.row];
    cell.textLabel.text = model.building;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BuildingModel *model = self.dataSourceArr[indexPath.row];
    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(Notice_Name_ChooseBuild, @{@"userInfo":model});
    [self.navigationController popViewControllerAnimated:YES];
    
    //    FloorChooseTableViewController *floorVc = [[FloorChooseTableViewController alloc]init];
    //    BuildingModel *model = self.dataSourceArr[indexPath.row];
    //    floorVc.buildingId = model.id;
    //    [self.navigationController pushViewController:floorVc animated:YES];
}

@end
