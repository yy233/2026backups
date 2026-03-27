//
//  AppleLoginManager.h
//  Community
//
//  Created by 余莹 on 2021/5/31.
//

#import <Foundation/Foundation.h>
typedef void(^AppleLoginGetUserInfoBlock)(AppleLoginModel *,Third_LoginOrRegist_Type);
NS_ASSUME_NONNULL_BEGIN

@interface AppleLoginManager : NSObject
singleton_interface(shareManager);
- (void)appleLoginBtnIsTap;
- (void)performExistingAccountSetupFlows;
@property (nonatomic,copy) AppleLoginGetUserInfoBlock userInfoBlock;
@end
 
NS_ASSUME_NONNULL_END
