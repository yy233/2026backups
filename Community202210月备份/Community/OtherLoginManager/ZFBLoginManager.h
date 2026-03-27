//
//  ZFBLoginManager.h
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZFBLoginGetUserInfoBlock)(ZFBLoginModel *,Third_LoginOrRegist_Type);

@interface ZFBLoginManager : NSObject
singleton_interface(shareManager)


- (void)ZfbLoginBtnIsTap;
- (BOOL)handleOpenURL:(NSURL *)url;

@property (nonatomic,copy) ZFBLoginGetUserInfoBlock userInfoBlock;
@end

NS_ASSUME_NONNULL_END
