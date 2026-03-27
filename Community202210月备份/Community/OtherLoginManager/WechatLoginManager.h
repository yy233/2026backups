//
//  WechatLoginManager.h
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import <Foundation/Foundation.h>
#import "MethodsHeader.h"
#import "WXApi.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    Third_LoginOrRegist_Type_Login,
    Third_LoginOrRegist_Type_Regist,
    Third_LoginOrRegist_Type_Err
} Third_LoginOrRegist_Type;

typedef void(^WeChatLoginGetUserInfoBlack)(WeChatLoginUserModel *,Third_LoginOrRegist_Type);


@interface WechatLoginManager : NSObject
singleton_interface(shareManager)

- (void)wxLoginBtnIsTap;
- (void)registerApp;
- (BOOL)handleOpenURL:(NSURL *)url;

@property (nonatomic,copy)WeChatLoginGetUserInfoBlack userInfoblock;
@end

NS_ASSUME_NONNULL_END
