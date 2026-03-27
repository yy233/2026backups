//
//  LoginUseModel.m
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//

#import "LoginUseModel.h"


#define Url_VerifySignature  @"/user/verifySignature"


@implementation LoginUseModel

+ (void)loginVerifySignatureWithInfo:(LoginUseModel *)model withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSString *allUrl =  Y_AllURL_Main(Url_VerifySignature);
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:model.address] forKey:@"address"];
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:model.signature] forKey:@"signature"];
    //固定参数
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:@"freeper.ios"] forKey:@"platform"];


    [[Y_NetWorkBaseTool sharedTool]YYrequestALLURLPostNotMainQueue:allUrl withParams:parms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        NSLog(@" loginVerifySignatureWithInfo    ===   %@",responsObject);
        if (isNotNil(responsObject)) {
            if (Y_status_IS_Success) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                NSLog(@"dataDic  %@" ,dataDic);
                block(dataDic,YES);

            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
 
    
   
}


//登录验证签时使用
+ (void)loginVerifySignatureWithResultModel:(WebViewUseDataModel_LoginPersonalSign_Sub_resultData *)model withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSString *allUrl =  Y_AllURL_Main(Url_VerifySignature);
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:model.address] forKey:@"address"];
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:model.signature] forKey:@"signature"];
//    [parms setValue:[TextShowWithModelStr textShowWithModelStr:model.message] forKey:@"message"];
    //固定参数
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:@"freeper.ios"] forKey:@"platform"];


    [[Y_NetWorkBaseTool sharedTool]YYrequestALLURLPostNotMainQueue:allUrl withParams:parms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        NSLog(@" loginVerifySignatureWithInfo  parms %@  ===   responsObject %@",parms,responsObject);
        if (isNotNil(responsObject)) {
            if (Y_status_IS_Success) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                if([[dataDic allKeys] containsObject:@"issueTypes"]){
                    NSString *issueTypesStr = [dataDic objectForKey:@"issueTypes"];
                    //验证用户是否已经发行过圈子  //其他情况下 校验另一个接口 如登陆时未发行圈子，发行之后再去创建直播页面
                    if([ShareUserInfo share].userInfo.address.length >0){
                        [ShareUserInfo share].userInfo.issueTypes = issueTypesStr;//更新issueTypes
                    }
                }
                block(dataDic,YES);

            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
 
    
   
}

#define  checkInfo_sixf_Url_UseAddress              @"/user/home/information?address="
#define  checkInfo_sixf_Url_UseImid                 @"/user/home/information?imId="

//直播列表判断创建按钮后续时 使用
+ (void)checkVerifySignaturewithBlock:(BaseDicAndSuccessBoolBlock)block{
    if([ShareUserInfo share].userInfo.address.length<=0){
        block(@{},NO);
        return;
    }
    [self userAddress:[ShareUserInfo share].userInfo.address checkImidAndOtherInfoWithBlock:block];
}
//用户address 查询其他信息
+ (void)userAddress:(NSString *)address checkImidAndOtherInfoWithBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *allUrl = [NSString stringWithFormat:@"%@%@", Y_AllURL_Main(checkInfo_sixf_Url_UseAddress), address];
    [[Y_NetWorkBaseTool sharedTool]YYrequestALLURLGetNotMainQueue:allUrl withParams:@{}.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
         
        if (isNotNil(responsObject)) {
            if (Y_status_IS_Success) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                block(dataDic,YES);

            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
}
//用户imid 查询其他信息
+ (void)userImid:(NSString *)imidStr checkAddressAndOtherInfoWithBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSString *allUrl = [NSString stringWithFormat:@"%@%@", Y_AllURL_Main(checkInfo_sixf_Url_UseImid), imidStr];
    [[Y_NetWorkBaseTool sharedTool]YYrequestALLURLGetNotMainQueue:allUrl withParams:@{}.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
         
        if (isNotNil(responsObject)) {
            if (Y_status_IS_Success) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                block(dataDic,YES);

            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
}
@end
