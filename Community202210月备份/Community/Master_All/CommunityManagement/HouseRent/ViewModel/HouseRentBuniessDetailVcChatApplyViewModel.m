//
//  HouseRentBuniessDetailVcChatApplyViewModel.m
//  Community
//
//  Created by 余莹 on 2021/7/5.
//

#import "HouseRentBuniessDetailVcChatApplyViewModel.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
#import "ChatManagerData.h"
#define OPEN_ID              @"dd7186834b30422984643cb446ba0055"
#import "ZYChatVc.h"


@implementation HouseRentBuniessDetailVcChatApplyViewModel
+ (void)HouseRentBuniessDetailVcChatApplyWithImIdStr:(NSString *)imidStr withBlock:(BaseDicAndSuccessBoolBlock)block{
 
    NSString *myLoginGetImId = [ShareUserInfo sharedUserInfo].userInfo.imId;//==token
    NSString *chatUUId = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid;//连接成功后就有值
    NSString *chatOwnUUId = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.account;//nil  在聊天页后才会有值? own为主
    NSString *chatToken = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken;//连接成功后就有值 == [ShareUserInfo sharedUserInfo].userInfo.imId;
    if ([myLoginGetImId isEqualToString:imidStr]) {
        Y_SVP_SHOW_ERR_MES(@"商家不可以和自己聊天！");
        return;
    }
    
//    NSLog(@"HouseRentBuniessDetailVcChatApplyWithImIdStr_________  chatOwnUUId %@ |   chatToken %@ |  chatUUId %@ \n key %@ ,iv %@  " ,chatOwnUUId,chatToken,chatUUId,[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].service_Aes_Key,[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].service_Aes_Iv);
//    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
//    [parms setValue:myLoginGetImId forKey:@"consumerToken"];
//    [parms setValue:imidStr forKey:@"businessToken"];
//    [parms setValue:@"mobile" forKey:@"deviceMark"];
//    [parms setValue:OPEN_ID  forKey:@"consumerOpenId"];//发起方的openid
//    [parms setValue:chatUUId forKey:@"from_user"];
    
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:imidStr forKey:@"toUserImId"];//对方imId
    [parms setValue:@(ChatVc_Stranger_Chat_Application_houserOrstranger) forKey:@"type"];//陌生人类型： 1 客服 2 商家 3 房东 4 群聊中发起聊天
    [ChatManagerData chatNomalEncryptionWithDic:parms withBlock:^(NSDictionary * getDic, BOOL success) {
        if (success) {
            return block(getDic,success);
        }else{
            return block(getDic,success);
        }
    }];
    
}
+ (void)webViewShopBuniessDetailVcChatApplyWithImIdStr:(NSString *)imidStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *myLoginGetImId = [ShareUserInfo sharedUserInfo].userInfo.imId;//==token
    NSString *chatUUId = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid;//连接成功后就有值
    NSString *chatOwnUUId = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.account;//nil  在聊天页后才会有值? own为主
    NSString *chatToken = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken;//连接成功后就有值 == [ShareUserInfo sharedUserInfo].userInfo.imId;
    if ([myLoginGetImId isEqualToString:imidStr]) {
        Y_SVP_SHOW_ERR_MES(@"商家不可以和自己聊天！");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:imidStr forKey:@"toUserImId"];//对方imId
    [parms setValue:@(ChatVc_Stranger_Chat_Application_merchantBuniess) forKey:@"type"];//陌生人类型： 1 客服 2 商家 3 房东 4 群聊中发起聊天
    [ChatManagerData chatNomalEncryptionWithDic:parms withBlock:^(NSDictionary * getDic, BOOL success) {
        if (success) {
            return block(getDic,success);
        }else{
            return block(getDic,success);
        }
    }];
}

@end
