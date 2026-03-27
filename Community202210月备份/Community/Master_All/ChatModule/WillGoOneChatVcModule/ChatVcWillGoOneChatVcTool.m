//
//  ChatVcWillGoOneChatVcTool.m
//  Community
//
//  Created by 余莹 on 2022/3/26.
//

#import "ChatVcWillGoOneChatVcTool.h"
#import "ChatManagerData.h"

@implementation ChatVcWillGoOneChatVcTool
// *陌生人通话申请 跳转信息
+ (void)chatVcPushInfoWithClearnUseID:(NSInteger)clearnUseId withImIdStr:(NSString *)imidStr withThisStrangerChatType:(ChatVc_Stranger_Chat_Application)strangeApplyType withBlock:(ChatWillGoOneChatVcBlock)willPushVcBlock{
  
    if (imidStr.length <= 0 && strangeApplyType == ChatVc_Stranger_Chat_Application_customerSevice) {
        Y_SVP_SHOW_ERR_MES(@"本店铺暂不支持在线聊天！");
        return;
    }else if (imidStr.length <= 0 ){
        Y_SVP_SHOW_ERR_MES(@"对方缺失通信ID,暂不支持在线聊天！");
        return;
    }
    [self userChatApplyWithStrangerImIdStr:imidStr withThisStrangerChatType:strangeApplyType withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            
            ChatWillGoOneChatVcGetApplyInfoModel *chatInfoModel = [ChatWillGoOneChatVcGetApplyInfoModel mj_objectWithKeyValues:dic];
            NSString *sessionIdStr = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.sessionId];

            NSString *ownUUID = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.userAccount];
            NSString *toUserUUID = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.otherAccount];
            NSString *toUserNickName = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.nickName];
            
            if (ownUUID.length<=0 || toUserUUID.length<=0 || sessionIdStr.length<=0) {
                Y_SVP_SHOW_ERR_MES(@"用户信息 暂无即时通讯ID！");
                return;
            }
            if (strangeApplyType == ChatVc_Stranger_Chat_Application_groupChat) {//群--（不会调用）
                dispatch_async(dispatch_get_main_queue(), ^{
                    ZYChatVc *vc = [[ZYChatVc alloc] init];
                    [vc fillThisGroupTypeChatVcSubInfoWithClearnUseID:0 withSessionID:sessionIdStr withChatVcToUseType:ChatVc_Seesion_type_Group withGroupInfoDic:dic];
                    willPushVcBlock(vc,YES);
                    
                });
            }else{//非群 陌生人单聊
                ChatVc_Seesion_type thishatVc_Seesion_type = ChatVc_Seesion_type_StrangerCanChat;
                BOOL isMoShengRenTypeBoolNotShowRightItemBool = YES;
                BOOL isFriendTypeIsDeletNotAllowSendMsgBool = NO;
                NSString *thisChatVcUseSessionId = sessionIdStr;
                NSString *fAccountUUID = toUserUUID;
                NSString *fNickName = toUserNickName;
                NSString *fImid = imidStr;
                if (strangeApplyType == ChatVc_Stranger_Chat_Application_customerSevice || strangeApplyType == ChatVc_Stranger_Chat_Application_merchantBuniess ){//商品聊天多种模块的申请类型
                    thishatVc_Seesion_type = ChatVc_Seesion_type_BuniessShop;
                    
                }else if (strangeApplyType == ChatVc_Stranger_Chat_Application_houserOrstranger){//房主
                     thishatVc_Seesion_type = ChatVc_Seesion_type_StrangerCanChat;
                    
                }else{//其他 -- 给好友类型（不会调用）
                    thishatVc_Seesion_type = ChatVc_Seesion_type_Friend;
                    isMoShengRenTypeBoolNotShowRightItemBool = NO;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    ZYChatVc *vc = [[ZYChatVc alloc] init];
                    [vc fillThisNomalChatVcSubInfoWithClearnUseID:clearnUseId withSessionID:thisChatVcUseSessionId withChatVcToUseType:thishatVc_Seesion_type withNotShowRightItemMSRBool:isMoShengRenTypeBoolNotShowRightItemBool withWillUseFImId:fImid withWillUseFAccountUUID:fAccountUUID withWillUseFNickName:fNickName withFriendTypeIsDeletPersonNotAllowedSendMsgBool:isFriendTypeIsDeletNotAllowSendMsgBool];
                    
                    willPushVcBlock(vc,YES);
                    
                });
            }
        }else{
            Y_SVP_SHOW_ERR_MES(@"请求聊天失败。");
            ZYChatVc *vc = [[ZYChatVc alloc] init];
            willPushVcBlock(vc,NO);
        }

    }];
}

/**
 *陌生人通话申请 接口
 */
+ (void)userChatApplyWithStrangerImIdStr:(NSString *)imidStr withThisStrangerChatType:(ChatVc_Stranger_Chat_Application)strangeChatType withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSString *myLoginGetImId = [ShareUserInfo sharedUserInfo].userInfo.imId;//==token
    NSString *chatUUId = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid;//连接成功后就有值
    NSString *chatOwnUUId = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.account;//nil  在聊天页后才会有值? own为主
    NSString *chatToken = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken;//连接成功后就有值 == [ShareUserInfo sharedUserInfo].userInfo.imId;
    if ([myLoginGetImId isEqualToString:imidStr]) {
        Y_SVP_SHOW_ERR_MES(@"不可以和自己聊天！");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:imidStr forKey:@"toUserImId"];//对方imId
    [parms setValue:@(strangeChatType) forKey:@"type"];//陌生人类型： 1 客服 2 商家 3 房东 4 群聊中发起聊天
    [ChatManagerData chatNomalEncryptionWithDic:parms withBlock:^(NSDictionary * getDic, BOOL success) {
        if (success) {
            return block(getDic,success);
        }else{
            return block(getDic,success);
        }
    }];
}
@end
