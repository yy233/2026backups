//
//  ChatShowMessageDataDeal.m
//  Community
//
//  Created by 余莹 on 2021/5/20.
//

#import "ChatShowMessageDataDeal.h"
#import "ChatFriendMessageModel.h"
@implementation ChatShowMessageDataDeal
// 发送的数据seq是自增的 为防止错误 在发送成功后 用该seqid替换掉自增的seqid
 
+ (void)chatMsgListDic:(NSMutableArray *)dataSourceOfMsgList wtihGetRespondOkDic:(NSDictionary *)getRespondOkDic withReplaceSendDicSubSeqIdOkArr:(  void(^)(NSMutableArray * okArr) )replaceDataSourceOfMsgListOkBlook{
    DLog(@"--------------服务器的回复 SendOk kkkk-------  %@",getRespondOkDic);
    NSString *seqIdStr = @"";
    NSString *msgIdStr = @"";
    if (!  ( [[getRespondOkDic allKeys]containsObject:@"msg_id"] && [[getRespondOkDic allKeys]containsObject:@"seqId"] )) {
        return;
    }else{
        seqIdStr = [NSString stringWithString:[getRespondOkDic objectForKey:@"sequence_id"]];
        msgIdStr = [NSString stringWithString:[getRespondOkDic objectForKey:@"msg_id"]];
    }
    for (int i = 0; i < dataSourceOfMsgList.count; i ++) {
        ChatFriendMessageModel *msgModel  = [ChatFriendMessageModel mj_objectWithKeyValues: dataSourceOfMsgList[i]];
        if ( [msgIdStr isEqualToString: [TextShowWithModelStr textShowWithModelStr:msgModel.msg_id]] ) {
            [dataSourceOfMsgList replaceObjectAtIndex:i withObject:getRespondOkDic];
            if (isNotNil(dataSourceOfMsgList)) {
                replaceDataSourceOfMsgListOkBlook(dataSourceOfMsgList);
            }
            return;
        }
    }
    
}
+ (void)chatMsgListDic:(NSMutableArray *)dataSourceOfMsgList wtihGetRespondFailDic:(NSDictionary *)getRespondOkDic withReplaceSendDicSubSeqIdOkArr:(  void(^)(NSMutableArray * okArr) )replaceDataSourceOfMsgListOkBlook{
    DLog(@"--------------服务器的回复 SendFFFFFFFFFail -------  %@",getRespondOkDic);
    NSString *msgIdStr = @"";
    if ( (![[getRespondOkDic allKeys]containsObject:@"msg_id"] )) {
        return;
    }else{
        msgIdStr = [NSString stringWithString:[getRespondOkDic objectForKey:@"msg_id"]];
    }
    for (int i = 0; i < dataSourceOfMsgList.count; i ++) {
        ChatFriendMessageModel *msgModel  = [ChatFriendMessageModel mj_objectWithKeyValues: dataSourceOfMsgList[i]];
        if ( [msgIdStr isEqualToString: [TextShowWithModelStr textShowWithModelStr:msgModel.msg_id]] ) {
               [dataSourceOfMsgList removeObjectAtIndex:i];//删除列表里面的该数据 然后返回当前列表
            if (isNotNil(dataSourceOfMsgList)) {
                replaceDataSourceOfMsgListOkBlook(dataSourceOfMsgList);
            }
            return;
        }
    }
    
}
/**
 *--------------服务器的回复 SendFFFFFFFFFail -------  {
 "create_time" = 1621482679092;
 "from_user" = 2a314f0322884e1b927e89a636ac0ec2;
 "msg_id" = mdlmunuupchamnfevnjikkwiwxxguxvg;
 "msg_type" = response;
 noSynchronizedDevice = mobile;
 response =     {
     "err_code" = 405;
     "err_info" = "You and him are not friends yet!";
 };
 "to_user" = 2a314f0322884e1b927e89a636ac0ec2222;
}
(lldb
 */
@end
