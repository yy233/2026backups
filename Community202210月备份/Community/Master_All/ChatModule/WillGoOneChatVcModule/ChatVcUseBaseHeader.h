//
//  ChatVcUseBaseHeader.h
//  Community
//
//  Created by 余莹 on 2022/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//联系人类型
typedef enum : NSUInteger {
    ChatVc_Seesion_type_ContChat = 0,
    ChatVc_Seesion_type_Friend = 1,
    ChatVc_Seesion_type_Group = 2,
    ChatVc_Seesion_type_GGH   = 3,
    ChatVc_Seesion_type_BuniessShop = 4,
    ChatVc_Seesion_type_StrangerCanChat = 5,
} ChatVc_Seesion_type; // ==(to user type)  || ==  0 表示不存联系人关系（不可聊天） 1:好友、2、群、3、订阅号 4商家、服务号、5陌生人(可聊天)


@interface ChatVcUseBaseHeader : NSObject

@end

NS_ASSUME_NONNULL_END
