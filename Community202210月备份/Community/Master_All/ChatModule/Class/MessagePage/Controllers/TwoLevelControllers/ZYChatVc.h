//
//  ZYChatVc.h
//  Community
//
//  Created by ZY on 2021/4/20.
//
// 聊天会话

#import <UIKit/UIKit.h>
#import "ChatVcMsgViewModel.h"


NS_ASSUME_NONNULL_BEGIN



@interface ZYChatVc : ZYPageBaseVc





///**
// 好友类型他方ID 有短的查询类imid 和 长的通讯类uuid (po self.friendUUID zhsj_210cf5172f914d6a92ffa673bd4b2d04@user);
// */
//@property (nonatomic,strong) NSString *friendNickName;//titleL 使用
//
//@property (nonatomic,strong) NSString *friendUUID;//账户id  account类型（在发送消息类型中使用）
//@property (nonatomic,strong) NSString *chatVcWillUseImId;// （在查询接口类型中使用较多）
//
////联系人类型：0 表示不存联系人关系（不可聊天），1:好友、2、群、3、订阅号 4商家、服务号、5陌生人(可聊天)
//@property (nonatomic,assign) BOOL isMoShengRenTypeBoolNotShowRightItem;//租客等陌生人时 不显示右上角 不走资料设置 (有租房情况so不用这个键做各种类型的聊天允许判断)  |1213活动类型 不显示右上角 不走资料设置页
//@property (nonatomic,assign) BOOL isNotChatPersonNotAllowedSendMsgBool;//0不存联系人关系（不可聊天） 5陌生人(可聊天)
//@property (nonatomic,assign) BOOL isDeletPersonNotAllowedSendMsgBool;//好友关系已经删除好友；
////
//@property (nonatomic,strong) NSDictionary *groupInfoDic;//群基础信息dic
////
//@property (nonatomic,strong) NSString *thisChatVcSessionId;//2022 0323 增入 会话id
//@property (nonatomic,assign) ChatVc_Seesion_type thisChatVc_Seesion_type;//会话类型////联系人类型
//// ChatVc_Seesion_type;// ==(to user type)  || ==  0 表示不存联系人关系（不可聊天） 1:好友、2、群、3、订阅号 4商家、服务号、5陌生人(可聊天)
//
//
//

//非群
- (void)fillThisNomalChatVcSubInfoWithClearnUseID:(NSInteger)clearnUseId
                                    withSessionID:(NSString *)thisChatVcSessionId
                            withChatVcToUseType:(ChatVc_Seesion_type)thisChatVc_Seesion_type
                    withNotShowRightItemMSRBool:(BOOL)isMoShengRenTypeBoolNotShowRightItem
                               withWillUseFImId:(NSString *)chatVcWillUseImId
                        withWillUseFAccountUUID:(NSString *)friendUUID
                           withWillUseFNickName:(NSString *)friendNickName
withFriendTypeIsDeletPersonNotAllowedSendMsgBool:(BOOL)isDeletPersonNotAllowedSendMsgBool;


//群
- (void)fillThisGroupTypeChatVcSubInfoWithClearnUseID:(NSInteger)clearnUseId
                                        withSessionID:(NSString *)thisChatVcSessionId
                                withChatVcToUseType:(ChatVc_Seesion_type)thisChatVc_Seesion_type
                                   withGroupInfoDic:(NSDictionary *)groupInfoDic;

@end

NS_ASSUME_NONNULL_END
