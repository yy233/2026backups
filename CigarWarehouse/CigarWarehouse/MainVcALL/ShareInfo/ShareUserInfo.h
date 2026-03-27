//
//  ShareUserInfo.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define NSUserDefaults_Name_UserInfo @"Y_ThisUserInfo"

@interface ShareUserInfo : NSObject <NSCopying,NSMutableCopying,NSSecureCoding>
singleton_interface(share)
@property (nonatomic, strong) UserModel *userInfo;//用户模型
- (void)saveDefaultsLoginUserInfo:(UserModel *)model;
- (void)getDefaultsLoginUserInfo;

@property (nonatomic,copy) NSString *token;
@end

NS_ASSUME_NONNULL_END
