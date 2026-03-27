//
//  UserModel.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface UserLoginUseModel : NSObject
@property (nonatomic ,copy) NSString *acccount;
@property (nonatomic ,copy) NSString *password;
@end

@interface UserModel : NSObject <NSSecureCoding,NSObject, NSCoding>
@property (nonatomic ,copy) NSString *username;
@property (nonatomic ,copy) NSString *password;
@property (nonatomic ,assign) NSInteger  level;
@property (nonatomic, copy) NSString *token;

@end

NS_ASSUME_NONNULL_END
