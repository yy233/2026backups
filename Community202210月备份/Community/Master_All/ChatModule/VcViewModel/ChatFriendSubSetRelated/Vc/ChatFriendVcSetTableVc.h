//
//  ChatFriendVcTableVc.h
//  Community
//
//  Created by 余莹 on 2021/5/17.
//  好友设置vc

#import <UIKit/UIKit.h>
#import "ChatOneUserAndOwnUserTheRelationWithChatVcUseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatFriendVcSetTableVc : ChatBaseTableViewController
//@property (nonatomic,strong) NSString *friendUUID;
@property (nonatomic,strong) NSString *friendNickName;
//
@property (nonatomic,strong) NSString *friendImId;
@property (nonatomic,strong) ChatOneUserAndOwnUserTheRelationWithChatVcUseModel *saveRelationInfoModel;
@end

NS_ASSUME_NONNULL_END
