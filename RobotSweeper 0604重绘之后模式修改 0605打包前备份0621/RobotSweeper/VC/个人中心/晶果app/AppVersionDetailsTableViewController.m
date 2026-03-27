//
//  AppVersionDetailsTableViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/12/20.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "AppVersionDetailsTableViewController.h"

@interface AppVersionDetailsTableViewController ()
@property (nonatomic,strong)NSMutableArray *arrOfDetailInfo;
@end

@implementation AppVersionDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"客户端更新详情",nil);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self initData];
}
- (void)initData{
    _arrOfDetailInfo = [[NSMutableArray alloc]init];
    if (_strOfVersionDetail.length>0) {
        if (_oneIsSorTwoIsC==1) {
            self.title = NSLocalizedString(@"机器人软件更新详情",nil);
            if ([_strOfVersionDetail containsString:@";"]) {
                _arrOfDetailInfo = [NSMutableArray arrayWithArray: [_strOfVersionDetail componentsSeparatedByString:@";"]];
            }else{
                  _arrOfDetailInfo = [NSMutableArray arrayWithArray: [_strOfVersionDetail componentsSeparatedByString:@"；"]];
            }
           
        }else if (_oneIsSorTwoIsC==2){
            self.title = NSLocalizedString(@"机器人硬件更新详情",nil);
            if ([_strOfVersionDetail containsString:@";"]) {
                _arrOfDetailInfo = [NSMutableArray arrayWithArray: [_strOfVersionDetail componentsSeparatedByString:@";"]];
            }else{
                _arrOfDetailInfo = [NSMutableArray arrayWithArray: [_strOfVersionDetail componentsSeparatedByString:@"；"]];
            }
        }else{
            _arrOfDetailInfo = [NSMutableArray arrayWithArray: [_strOfVersionDetail componentsSeparatedByString:@"\n"]];
        }

        
        
        [self.tableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==1) {
        return _arrOfDetailInfo.count;
    }else{
        return 1;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    if (indexPath.section == 0) {//版本
         cell.textLabel.textAlignment = NSTextAlignmentCenter;
         cell.textLabel.text =  [NSString stringWithFormat:@"Version %@",_strOfVersionNum];
         cell.textLabel.font = [UIFont systemFontOfSize:16];
    }else if (indexPath.section == 2){//更新时间
         cell.textLabel.textAlignment = NSTextAlignmentRight;
         cell.textLabel.text = _strOfVersionUpTime;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }else{//更新内容
        
//            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.text = _arrOfDetailInfo[indexPath.row];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        
    }
   
    
    return cell;
}
 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
