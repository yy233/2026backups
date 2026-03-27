//
//  IMBase.h
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import <Foundation/Foundation.h>
#import "TUILogin.h"
NS_ASSUME_NONNULL_BEGIN

@interface IMBase : NSObject
 
+ (void)imLoginInfoUserID:(NSString *)userid
                  userSig:(NSString *)sig
                withBlockk:(void(^)(BOOL loginStue))loginStuesBlock;

+ (void)imLogoutAction;
@end

NS_ASSUME_NONNULL_END
