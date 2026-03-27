//
//  LoginThingsTool.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/25.
//

#import <Foundation/Foundation.h>

//登录
#define  admin_login             @"/admin/login"
//获取角色
#define  admin_getAllRole        @"/admin/getAllRole"
//获取权限
#define  admin_getAllPermission  @"/admin/getAllPermission"

NS_ASSUME_NONNULL_BEGIN

typedef  void(^LoginNetBlockWithSuccBoolAndDic)(BOOL succ,id dataThings);

@interface LoginThingsTool : NSObject
singleton_interface(share)


//登录
- (void)adminDoLoginActionWithDic:(NSDictionary *)dic withBlock:(LoginNetBlockWithSuccBoolAndDic)block;
//获取角色
- (void)adminGetAllRolewithBlock:(LoginNetBlockWithSuccBoolAndDic)block;
//获取权限
- (void)adminGetAllPermissionithBlock:(LoginNetBlockWithSuccBoolAndDic)block;


@end

NS_ASSUME_NONNULL_END
