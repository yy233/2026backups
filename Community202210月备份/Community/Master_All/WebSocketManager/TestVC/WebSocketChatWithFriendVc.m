//
//  WebSocketChatWithFriendVc.m
//  Community
//
//  Created by 余莹 on 2021/4/23.
//

#import "WebSocketChatWithFriendVc.h"
#import "ChatManagerData.h"
#import "SocketRocketUtility.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"

@interface WebSocketChatWithFriendVc ()

@end

@implementation WebSocketChatWithFriendVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.title = self.friendUUID;
    // Do any additional setup after loading the view.
    [self initHistoryMsg];
    [self initNotice];
}


- (void)initNotice{
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketDidCloseNote object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote:) name:kWebSocketdidReceiveMessageNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote_ChatMsg:) name:kWebSocketdidReceiveMessage_NoticeName_ChatMsg object:nil];

//
}
- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    //在成功后需要做的操作。。。
        
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSString * message = note.object;
    NSLog(@"收到服务端发送过来的消息 %@",message);
}
 
 
#pragma mark ===
- (void)SRWebSocketdidReceiveMessageNote_ChatMsg:(NSNotification *)notice{
    //
    [self textMsgInfo:notice.object];
}

- (void)textMsgInfo:(NSDictionary *)getMsgDic{
    DLog(@"%@",getMsgDic);
    NSDictionary *textDic = [NSDictionary dictionaryWithDictionary: getMsgDic[kWebSocketMsgTypeObj_Text]];
    NSString *textConStr = [textDic objectForKey:@"content"];
//    NSString *f = [getMsgDic objectForKey:@"from_user"];
    [self.dataSourceOfList addObject:getMsgDic];
    [self.tableView reloadData];
}


- (void)sendAskInfoWithGetMsgDic:(NSDictionary *)getMsgDic{
    NSLog(@"_______________________________________________________回复ack信息");
    [ChatManagerData chatWillSnedReceiveAckwithGetMsgDic:getMsgDic withBlock:^(NSDictionary * dic) {
        NSString *jsons = [Tool jsonStrWithDic:dic];
        [[SocketRocketUtility instance]sendData: jsons];
    }];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
#pragma mark ==  好友聊天信息 7天內数据
- (void)initHistoryMsg{
    WEAKSELF
    [ChatManagerData getOneFriendChatHistoryMsgListWithFriendUUID:self.friendUUID withBlock:^(NSDictionary * dic, BOOL success) {
//        NSLog(@"消息位点同步________%@",dic);
        if ([[dic allKeys]containsObject:@"messages"]) {
            weakSelf.dataSourceOfList = [NSMutableArray arrayWithArray:   [dic objectForKey:@"messages"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
#pragma mark ==  好友聊天信息 按 SeqId
//- (void)initHistoryMsg{
//    WEAKSELF
//    [ChatManagerData getOneFriendChatMsgListWithBeginSeqId:@"5" withEndSeqId:@"30" withFriendUUID:self.friendUUID withBlock:^(NSDictionary * dic, BOOL success) {
////        NSLog(@"消息位点同步________%@",dic);
//        if ([[dic allKeys]containsObject:@"messages"]) {
//            weakSelf.dataSourceOfList = [NSMutableArray arrayWithArray:   [dic objectForKey:@"messages"]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.tableView reloadData];
//            });
//        }
//    }];
//}

 
- (NSMutableArray *)dataSourceOfList{
    if (!_dataSourceOfList) {
        _dataSourceOfList = [[NSMutableArray alloc]init];
    }
    return _dataSourceOfList;
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
 //    cell.textLabel.text =  [NSString stringWithString:dic[@"to_user"]];//
    cell.textLabel.text =  [NSString stringWithString:dic[@"from_user"]];//
    cell.textLabel.font = [UIFont systemFontOfSize:10];
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
    NSDictionary *dic = self.dataSourceOfList[indexPath.row];
    //test 聊天
    NSString *to_uuid =  [NSString stringWithString:dic[@"to_user"]];
    NSString *fromUUId = [NSString stringWithString:dic[@"from_user"]];
    NSString *info = [NSString stringWithFormat:@" %@-- to --%@",fromUUId,to_uuid];
    NSString  *sequence_id = [NSString stringWithString:dic[@"sequence_id"]];
//    Y_SVP_SHOW_INFO_MES(info);
    DLog(@"didSelectRowAtIndexPath  %@",info);
   
    if (indexPath.row==0) {
        //聊天
        [self chatTestSned];
       
    }else{
//        //撤回
//        [self drawOneMessageWithSequenceId:sequence_id];
        [self deletOneMessageWithSequenceId:sequence_id];
    }
 
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //聊天
    [self chatTestSned];
}
- (void)chatTestSned{
    NSLog(@"------------聊天----------------------");
    
    if (self.friendUUID.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"uuid 空");
        return;
    }
//    [ChatManagerData chatWillSendTextTypeWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withStr:@"聊天文本类型1111111111111哈哈哈哈哈哈哈哈888880" withFriendUUId:self.friendUUID withDicBlockAndWillSendDataDicBlock:^(NSArray * arr) {
//        NSString *jsons = [Tool jsonStrWithDic:arr.firstObject];
//        [[SocketRocketUtility instance]sendData: jsons];
//        //        [[SocketRocketUtility instance]sendData: dic[@"data"]];
//    }];
}

- (void)drawOneMessageWithSequenceId:(NSString *)seqId{
    NSLog(@"------------撤回----------------------");
    [ChatManagerData chatInfoWithUndoOneMessageWithSequenceId:seqId withFriendId:self.friendUUID withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            DLog(@"撤回成功 === %@",dic);
        }
    }];
}
- (void)deletOneMessageWithSequenceId:(NSString *)seqId{
    NSLog(@"------------删除----------------------");
    [ChatManagerData chatInfoDeletOneMessageWithSequenceId:seqId withFriendId:self.friendUUID withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            DLog(@"删除成功 === %@",dic);
        }
    }];
}
@end
