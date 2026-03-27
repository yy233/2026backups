//
//  ChatShowMessageDataDeal.h
//  Community
//
//  Created by 余莹 on 2021/5/20.
//

#import <Foundation/Foundation.h>

 

NS_ASSUME_NONNULL_BEGIN

@interface ChatShowMessageDataDeal : NSObject
// 发送的数据成功 seq是自增的 为防止错误 在发送成功后 用该seqid替换掉自增的seqid
+ (void)chatMsgListDic:(NSMutableArray *)dataSourceOfMsgList wtihGetRespondOkDic:(NSDictionary *)getRespondOkDic withReplaceSendDicSubSeqIdOkArr:(  void(^)(NSMutableArray * okArr) )replaceDataSourceOfMsgListOkBlook;
//发送的数据失败  处理删除掉当前数据 刷新聊天页 提示用户
+ (void)chatMsgListDic:(NSMutableArray *)dataSourceOfMsgList wtihGetRespondFailDic:(NSDictionary *)getRespondOkDic withReplaceSendDicSubSeqIdOkArr:(  void(^)(NSMutableArray * okArr) )replaceDataSourceOfMsgListOkBlook;
@end

NS_ASSUME_NONNULL_END
