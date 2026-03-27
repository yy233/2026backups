//
//  ShareUserInfo.h
//  Socialize
//
//  Created by 余莹 on 2023/5/25.
//

#import <Foundation/Foundation.h>
#import "MethodsHeader.h"
#import "UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShareUserInfo : NSObject <NSCopying,NSMutableCopying,NSSecureCoding>

singleton_interface(share);


@property (nonatomic, strong) UserModel *userInfo;//用户模型
@property (nonatomic, assign) BOOL  canCreatZhiboBool;
- (void)saveDefaultsLoginUserInfo:(UserModel *)model;
- (void)getDefaultsLoginUserInfo;
@end

NS_ASSUME_NONNULL_END
