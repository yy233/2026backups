//
//  UserCertificationDetailViewModel.m
//  Community
//
//  Created by 余莹 on 2021/7/12.
//

#import "UserCertificationDetailViewModel.h"

@implementation UserCertificationDetailViewModel
+ (void)mainUserDeletRelationWithRelationId:(NSInteger)relationId withBlock:(BaseDicAndSuccessBoolBlock)block//业主 家属id  删除接口
{
    //delet
    NSString *url = @"proprietor/relation/delete";

    
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(relationId) forKey:@"id"];
    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}
+ (void)deletCarWithVcShowTypeBoolIsMainOrFamile:(BOOL)isMainUserBool withCarId:(NSInteger)carId withBlock:(BaseDicAndSuccessBoolBlock)block//业主车 家属车 删除接口
{
    //delet
    NSString *url = @"";
    if (isMainUserBool) {
        url = @"proprietor/user/delCar";
    }else{
        url = @"proprietor/relation/delCar";
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(carId) forKey:@"id"];
    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}

@end
