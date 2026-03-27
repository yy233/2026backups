//
//  ChatVcWillGoOneChatVcTool.h
//  Community
//
//  Created by 余莹 on 2022/3/26.
// 和陌生人聊天 的申请聊天许可的接口

#import <Foundation/Foundation.h>
#import "ZYChatVc.h"
#import "ChatWillGoOneChatVcGetApplyInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

//陌生人类型： 1 客服 2 商家 3 房东 4 群聊中发起聊天 （这是在申请聊天时的接口使用 不是联系人类型 ｜｜｜这个接口中的type 要么写2，要么写3，不支持其他的值）
typedef enum : NSUInteger {
    ChatVc_Stranger_Chat_Application_customerSevice = 2,
    ChatVc_Stranger_Chat_Application_merchantBuniess= 2,
    ChatVc_Stranger_Chat_Application_houserOrstranger  = 3,
    ChatVc_Stranger_Chat_Application_groupChat         = 999,
} ChatVc_Stranger_Chat_Application;



typedef void(^ChatWillGoOneChatVcBlock)(ZYChatVc *willPushVc, BOOL success);

@interface ChatVcWillGoOneChatVcTool : NSObject
// *陌生人通话申请 跳转信息
+ (void)chatVcPushInfoWithClearnUseID:(NSInteger)clearnUseId withImIdStr:(NSString *)imidStr withThisStrangerChatType:(ChatVc_Stranger_Chat_Application)strangeApplyType withBlock:(ChatWillGoOneChatVcBlock)willPushVcBlock; 
@end

NS_ASSUME_NONNULL_END
