//
//  WebSocketGroupChatVc.m
//  Community
//
//  Created by 余莹 on 2021/4/25.
//

#import "WebSocketGroupChatVc.h"
#import "ChatManagerData.h"
#import "SocketRocketUtility.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
@interface WebSocketGroupChatVc ()

@end

@implementation WebSocketGroupChatVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"某群聊";
    self.tableView.backgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:0.3];
    [self.tableView reloadData];
    [self initRightNavItem];
    [self initHistoryMsg];
    
    // Do any additional setup after loading the view.
}
- (void)initRightNavItem{
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [navRightBtn setTitle:@"发送文本" forState:UIControlStateNormal];
     navRightBtn.bounds = CGRectMake(0 , 0, 24, 24);
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoRightBarItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:infoRightBarItem animated:YES];
}
- (void)navRightBtnAction{
    DLog(@"______________navRightBtnAction______________");
    [self groupChatTestSned];
}
#pragma mark ==
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceOfList.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }

    NSDictionary *dic = self.dataSourceOfList[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
 //    cell.textLabel.text =  [NSString stringWithString:dic[@"to_user"]];//
    cell.textLabel.text =  [NSString stringWithString:dic[@"from_user"]];//自己
    NSString *content = [[NSDictionary dictionaryWithDictionary:dic[@"text"]] objectForKey:@"content"];
    cell.detailTextLabel.text = content;
    if ([cell.textLabel.text isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]) {
        cell.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.5];
    }else{
        cell.backgroundColor  = [[UIColor redColor] colorWithAlphaComponent:0.2];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSDictionary *dic = self.dataSourceOfList[indexPath.row];
//    //test 聊天
//    NSString *to_uuid =  [NSString stringWithString:dic[@"to_user"]];
//    NSString *fromUUId = [NSString stringWithString:dic[@"from_user"]];
//    NSString *info = [NSString stringWithFormat:@" %@-- to --%@",fromUUId,to_uuid];
//    NSString  *sequence_id = [NSString stringWithString:dic[@"sequence_id"]];
////    Y_SVP_SHOW_INFO_MES(info);
//    DLog(@"didSelectRowAtIndexPath  %@",info);
//   
//    if (indexPath.row==0) {
//        //聊天
//        [self groupChatTestSned];
//       
//    }else{
////        //撤回
////        [self drawOneMessageWithSequenceId:sequence_id];
////        [self deletOneMessageWithSequenceId:sequence_id];
//    }
// 
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //聊天
    [self groupChatTestSned];
}
- (void)groupChatTestSned{
    NSLog(@"------------群 聊天----------------------");
//    [ChatManagerData chatWillSendTextTypeWithStr:@"聊天文本类型1111111111111" withGroupId:self.groupId   withBlock:^(NSDictionary * dic) {
//        NSString *jsons = [Tool jsonStrWithDic:dic];
//        [[SocketRocketUtility instance]sendData: jsons];
//        //        [[SocketRocketUtility instance]sendData: dic[@"data"]];
//    }];
}

#pragma mark == 消息位点同步
- (void)initHistoryMsg{
    WEAKSELF
    [ChatManagerData getOneFriendChatMsgListWithGroupID:self.groupId withBlock:^(NSDictionary * dic, BOOL success) {
        NSLog(@"消息位点同步_____群___%@",dic);
        if ([[dic allKeys]containsObject:@"messages"]) {
            weakSelf.dataSourceOfList = [NSMutableArray arrayWithArray:   [dic objectForKey:@"messages"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
@end
