//
//  MainAllTypeImInfoData.m
//  Community
//
//  Created by 余莹 on 2021/9/4.
//

#import "MainAllTypeImInfoData.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
#import "ChatManagerData.h"
#define kMobile              @"mobile"
//#define kMobile              [JGSaveIdShare sharedUserInfo].registrationID

@implementation MainAllTypeImInfoData
/**
 
 #define Message_Push_Module_ImURL_getImMessageList                        @"zhsj/im/message/session/page" //获取用户会话列表
 #define Message_Push_Module_ImURL_ImMessageListOrOneMessage_Clear         @"zhsj/im/message/session/clear" //获取用户会话列表清除接口
 #define Message_Push_Module_ImURL_getMessageChatSubPage                   @"zhsj/im/message/chatMsg/pageMsg" //某类型 子列表*/

+ (void)initImMessageListWithArrBlcok:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setValue:@(1) forKey:@"pageNum"];
    [self getImMessageListWithBodyDic:bodyDic withArrBlcok:block];
}

+ (void)upDataImMessageListWithPageNum:(NSInteger)pageNum withArrBlcok:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setValue:@(pageNum) forKey:@"pageNum"];
    [self getImMessageListWithBodyDic:bodyDic withArrBlcok:block];
}

+ (void)getImMessageListWithBodyDic:(NSMutableDictionary *)bodyDic withArrBlcok:(BaseListArrAndSuccessBoolBlock)block{
    [bodyDic setValue:@(Y_PAGE_SIZE) forKey:@"pageSize"];
    [bodyDic setValue:@(1) forKey:@"format"]; //作用于last_chat_msg字段    * format 为0 表示使用之前的消息格式      * format 为1 表示使用新版的消息格式
    NSString *allUrl = BASE_Message_Push_Module_Default_URL(Message_Push_Module_ImURL_getImMessageList);
    [[ToolOfNetWork sharedTools]YrequestImInfoPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
        
            [ChatManagerData toolImMesssageInfoResponsObject:responsObject withChangeToDicBlock:^(NSDictionary * dic, BOOL success) {
                if (success) {
                    DLog(@"总推送消息菜单 --- %@",dic);
                    NSArray *arr =  [[dic allKeys] containsObject:@"data"]? [NSArray arrayWithArray:[dic objectForKey:@"data"]] : [[NSArray alloc]init];;
                    block(arr,success);
                }
            }];
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION;
        }
    }];
}
//___总推送类分页消息 同 chatvc历史消息 一样接口
// 分类型列表消息数据 用toUser对方聊天号获取
+ (void)initImMessageListWithToUser:(NSString *)toUser withArrBlcok:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setValue:@(1)   forKey:@"pageNum"];
    [bodyDic setValue:toUser forKey:@"toUser"];
    [self getImMessageListWithToUserWithBodyDic:bodyDic withArrBlcok:block];
}
+ (void)upDataImMessageListWithToUser:(NSString *)toUser withPageNum:(NSInteger)pageNum withArrBlcok:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setValue:@(pageNum) forKey:@"pageNum"];
    [bodyDic setValue:toUser     forKey:@"toUser"];
    [self getImMessageListWithToUserWithBodyDic:bodyDic withArrBlcok:block];
}
+ (void)getImMessageListWithToUserWithBodyDic:(NSMutableDictionary *)bodyDic withArrBlcok:(BaseListArrAndSuccessBoolBlock)block{
    [bodyDic setValue:@(Y_PAGE_SIZE) forKey:@"pageSize"];
    [bodyDic setValue:@(1)           forKey:@"format"]; //作用于last_chat_msg字段    * format 为0 表示使用之前的消息格式      * format 为1 表示使用新版的消息格式
    NSString *allUrl = BASE_Message_Push_Module_Default_URL(Message_Push_Module_ImURL_getMessageChatSubPage);
    [[ToolOfNetWork sharedTools]YrequestImInfoPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            [ChatManagerData toolImMesssageInfoResponsObject:responsObject withChangeToDicBlock:^(NSDictionary * dic, BOOL success) {
                if (success) {
                    DLog(@"总推送消息菜单 --- %@",dic);
                    NSArray *arr =  [[dic allKeys] containsObject:@"data"]? [NSArray arrayWithArray:[dic objectForKey:@"data"]] : [[NSArray alloc]init];;
                    block(arr,success);
                }
            }];
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION;
        }
    }];
}


//清空记录
+ (void)deleImMessageWithParms:(NSMutableDictionary *)bodyDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *allUrl = BASE_Message_Push_Module_Default_URL(Message_Push_Module_ImURL_ImMessageListOrOneMessage_Clear);
    [[ToolOfNetWork sharedTools]YrequestImInfoPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            [ChatManagerData toolImMesssageInfoResponsObject:responsObject withChangeToDicBlock:^(NSDictionary * dic, BOOL success) {
                if (success) {
                    DLog(@"总推送消息菜单清除 bodyDic=%@--- %@",bodyDic,dic);
                    NSArray *arr =  [[dic allKeys] containsObject:@"data"]? [NSArray arrayWithArray:[dic objectForKey:@"data"]] : [[NSArray alloc]init];;
                    block(arr,success);
                }
            }];
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION;
        }
    }];
}
@end
