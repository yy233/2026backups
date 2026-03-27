//
//  UserInfoRegistWillEnterWhichVcWithData.h
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    UserInfoRegistVC_GoToVC_Type_PersonInfoUnRegistered,//未实名认证
    UserInfoRegistVC_GoToVC_Type_HouseUnRegistered,//实名认证后——未绑定房屋
    UserInfoRegistVC_GoToVC_Type_Registered,//已经实名认证——且已经绑定房屋
} UserInfoRegistVC_GoToVC_Type;

typedef void(^UserInfoRegistGoToVcDataBlock)(UserInfoRegistVC_GoToVC_Type,BOOL);

@interface UserInfoRegistWillEnterWhichVcWithData : NSObject
+ (void)goToWhichVcWithType:(UserInfoRegistGoToVcDataBlock)typeDataBlock;
@end

NS_ASSUME_NONNULL_END
