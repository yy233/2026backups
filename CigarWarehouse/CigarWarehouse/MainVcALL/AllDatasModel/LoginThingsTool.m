//
//  LoginThingsTool.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/25.
//

#import "LoginThingsTool.h"

@implementation LoginThingsTool
singleton_implementation(share)
//登录
- (void)adminDoLoginActionWithDic:(NSDictionary *)dic withBlock:(LoginNetBlockWithSuccBoolAndDic)block{
    NSString *u = Y_AllURL_Main(admin_login);
    [[NetWorkSwiftTool share]baseNetPostMethodWithUrl:u
                                                   parm:dic
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
       
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
                
            }else if(Response_Check_DataDic_Type){
                block(YES,Response_DataDic);
                
            }else if(Response_Check_DataStr_Type){
                block(YES,Response_DataStr);
                
            }else{
                block(YES,responsObject);
            }
        }else{
          
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_domain
    }];
}

//获取角色
- (void)adminGetAllRolewithBlock:(LoginNetBlockWithSuccBoolAndDic)block{
    NSString *u = Y_AllURL_Main(admin_getAllRole);
    NSDictionary *p = @{};
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                   parm:p
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
            }else{
                block(YES,Response_DataDic);
            }
        }else if(Response_Check_HaveKey_All){
            block(YES,Response_Data_AllKey_Arr);
            
        }else{
            
        }
        
    } fail:^(NSError * _Nonnull err) {
    }];
}

//获取权限
- (void)adminGetAllPermissionithBlock:(LoginNetBlockWithSuccBoolAndDic)block{
    NSString *u = Y_AllURL_Main(admin_getAllPermission);
    NSDictionary *p = @{};
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                   parm:p
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
            }else{
                block(YES,Response_DataDic);
            }
        }else if(Response_Check_HaveKey_All){
            block(YES,Response_Data_AllKey_Arr);
            
        }else{
            
        }
        
    } fail:^(NSError * _Nonnull err) {
    }];
}

@end
