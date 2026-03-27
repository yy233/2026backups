//
//  WebSocketAllSessionListVc.m
//  Community
//
//  Created by 余莹 on 2021/4/25.
//

#import "WebSocketAllSessionListVc.h"
#import "WebSocketGroupChatVc.h"
@interface WebSocketAllSessionListVc ()

@end

@implementation WebSocketAllSessionListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    if (self.isAllGroupSectionList) {
        self.title = @"群列表";
    }else{
        self.title = @"好友列表";
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isAllGroupSectionList) {
        return self.groupsArr.count;
    }else{
        return self.friendsArr.count;
    }
    return 0;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
 
//    if (tableView==self.friendReInfoList) {
//        NSDictionary *dic = self.arrOfFReqList[indexPath.row];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.contentView.backgroundColor = [UIColor clearColor];
////        cell.textLabel.text =  [dic[@"toNickname"] stringByAppendingString:dic[@"to_user"]];//
//        cell.textLabel.text =  [NSString stringWithString:dic[@"to_user"]];//
//        cell.textLabel.font = [UIFont systemFontOfSize:10];
//    }
    
   
    if (self.isAllGroupSectionList) {
        NSDictionary *dic = self.groupsArr[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        if ([[dic allKeys]containsObject:@"groupUuid"]) {
            cell.textLabel.text =  [@"群==" stringByAppendingString:dic[@"groupUuid"]];//
        }else{
            cell.textLabel.text =  @"群列表_错误数据";//
        }
     
        cell.textLabel.font = [UIFont systemFontOfSize:11];
    }else{
        NSDictionary *dic = self.friendsArr[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.text =  [@"touser==" stringByAppendingString:dic[@"to_user"]];//
        cell.textLabel.font = [UIFont systemFontOfSize:11];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isAllGroupSectionList) {
        NSDictionary *dic = self.groupsArr[indexPath.row];
     
        if ([[dic allKeys]containsObject:@"groupUuid"]) {
            NSString *groupID = [NSString stringWithString:dic[@"groupUuid"]];;//
            DLog(@"群======= %@",groupID);
            WebSocketGroupChatVc *vc = [[WebSocketGroupChatVc alloc]init];
            vc.groupId = groupID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            NSString *err =  @"群列表_错误数据";//
            Y_SVP_SHOW_ERR_MES(err);
        }
     
         
    }else{
        NSDictionary *dic = self.friendsArr[indexPath.row];
  
        NSString *friendUUID = [NSString stringWithString:dic[@"to_user"]];
     
    }
}
@end
