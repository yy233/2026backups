//
//  AppVersionInfoListTableViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/12/20.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "AppVersionInfoListTableViewController.h"
#import "AppVersionDetailsTableViewController.h"
@interface AppVersionInfoListTableViewController ()
@property (nonatomic,strong) NSMutableArray *dataArrOfAppVersionInfo;
@end

@implementation AppVersionInfoListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.tableFooterView = [UIView new];
    [self initData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = NSLocalizedString(@"客户端更新日志",nil);
   
}
#pragma mark --  版本历史信息
- (void)initData{
    _dataArrOfAppVersionInfo = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"page",@"999",@"limit", nil];//得到全部数据
    [[ToolOfNetWork sharedTools]endXml];
    [[ToolOfNetWork sharedTools]YrequestGetURL:S_getIOSLogList withParams:parm finished:^(id responsObject, NSError *error) {
        if (_Success) {
             _dataArrOfAppVersionInfo = responsObject[@"list"];
            [self.tableView reloadData];
        }else{
            NSLog(@"ios更新历史list erro");
        }
       
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArrOfAppVersionInfo.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
     
     if (!cell) {
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
     }
     cell.textLabel.text = [_dataArrOfAppVersionInfo[indexPath.row] objectForKey:@"iosVersion"];
     cell.detailTextLabel.text = [_dataArrOfAppVersionInfo[indexPath.row] objectForKey:@"iosUpdateTime"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    AppVersionDetailsTableViewController *versionDetailInfo = [[AppVersionDetailsTableViewController alloc]init];
    versionDetailInfo.strOfVersionDetail = [_dataArrOfAppVersionInfo[indexPath.row] objectForKey:@"iosContont"];
    versionDetailInfo.strOfVersionNum = [_dataArrOfAppVersionInfo[indexPath.row] objectForKey:@"iosVersion"];
    versionDetailInfo.strOfVersionUpTime = [_dataArrOfAppVersionInfo[indexPath.row] objectForKey:@"iosUpdateTime"];
    self.title = @"";
    [self.navigationController pushViewController:versionDetailInfo animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
