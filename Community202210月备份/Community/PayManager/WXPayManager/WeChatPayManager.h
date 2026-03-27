//
//  WXPayManager.h
//  Community
//
//  Created by 余莹 on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
NS_ASSUME_NONNULL_BEGIN

@interface WeChatPayManager : NSObject
singleton_interface(shareManager)

- (BOOL)handleOpenURL:(NSURL *)url;
- (void)hangleWechatPayWithPayReq:(PayReq *)req;
@end

NS_ASSUME_NONNULL_END
