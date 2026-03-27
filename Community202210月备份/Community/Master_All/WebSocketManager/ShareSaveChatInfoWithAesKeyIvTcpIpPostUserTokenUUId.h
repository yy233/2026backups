//
//  ShareSaveAesKey.h
//  Community
//
//  Created by 余莹 on 2021/4/20.
//

#import <Foundation/Foundation.h>
//#import "ChatUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId : NSObject
singleton_interface(sharedUserInfo)

@property (nonatomic,strong) NSString *service_Aes_Key;
@property (nonatomic,strong) NSString *service_Aes_Iv;
@property (nonatomic,strong) NSString *tcp_ip;
@property (nonatomic,strong) NSString *tcp_port;



@property (nonatomic,strong) NSString *userToken;
@property (nonatomic,strong) NSString *userUuid;
@property (nonatomic,strong) ChatUserModel *chatUserMyOwn;

//0901加入键值
@property (nonatomic,strong) NSString *chatUseContactTheMerchantHeader_Token;
 



@end

NS_ASSUME_NONNULL_END
