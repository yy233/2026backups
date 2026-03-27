//
//  LoginAndUserNetInfoTool.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import "LoginAndUserNetInfoTool.h"

@implementation LoginAndUserNetInfoTool
singleton_implementation(share)

#define addmin_login            @"/admin/login"//获取权限
#define addmin_getAllRole       @"/admin/getAllRole" //获取角色
#define addmin_getAllPermission @"/admin/getAllPermission"//获取权限

- (void)adminLoginActionWithDic:(NSDictionary *)parms withBlock:(void(^)(bool succ,NSDictionary *loginInfoDic))block{
    [[NetWorkSwiftTool share]baseNetPostMethodWithUrl:addmin_login parm:parms header:nil succ:^(NSDictionary * _Nonnull getDic) {
        if (isNil(getDic)) {
            block(false,@{});
        }else{
            block(true,getDic);
        }
    } fail:^(NSError * _Nonnull err) {
        block(false,@{});
    }];
}

- (void)getRoleArrsWithBlock:(void(^)(bool succ,NSArray *getArr))block{
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:addmin_getAllRole parm:@{} header:nil succ:^(NSDictionary * _Nonnull getDic) {
        block(true,getDic[@"all"]);
        
    } fail:^(NSError * _Nonnull err) {
        block(false,@[]);
    }];
}

- (void)getAllPermissionArrsWithBlock:(void(^)(bool succ,NSArray *getArr))block{
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:addmin_getAllPermission parm:@{} header:nil succ:^(NSDictionary * _Nonnull getDic) {
        block(true,getDic[@"all"]);
        
    } fail:^(NSError * _Nonnull err) {
        block(false,@[]);
    }];
}

@end
