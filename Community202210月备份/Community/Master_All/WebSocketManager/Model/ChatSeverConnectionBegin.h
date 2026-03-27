//
//  ChatSever.h
//  Community
//
//  Created by 余莹 on 2021/4/26.
//

#import <Foundation/Foundation.h>
//在登录后就连接
NS_ASSUME_NONNULL_BEGIN

@interface ChatSeverConnectionBegin : NSObject

singleton_interface(share)

- (void)initChatWithSocketNeedInfoAndOpenSocket;
@end

NS_ASSUME_NONNULL_END
