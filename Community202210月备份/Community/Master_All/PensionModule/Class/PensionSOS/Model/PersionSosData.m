//
//  PersionSosData.m
//  Community
//
//  Created by 余莹 on 2021/11/27.
//

#import "PersionSosData.h"
#import "ZYPensionUrlHeader.h"


// 查询sos家属和机构信息
#define kGetFamilysAndAgencysURL    @"zhsj/yiliao/myself/sos/select"
//紧急sos
#define kGetSOSURL                  @"zhsj/yiliao/myself/sos"

//地图数据 查 增
#define kSoSAddressInfoGetURL       @"zhsj/yiliao/myself/sos/findTheWay"
#define kSoSAddressInfoSaveURL      @"zhsj/yiliao/myself/sos/saveRoute"

// 添加关联家属
#define kAddFamilyURL               @"zhsj/yiliao/myself/sos/saveFamily"
// 修改关联家属
#define kEditFamilyURL              @"zhsj/yiliao/myself/sos/updateFamily"
//删除关联家属
#define kDelteFamilyURL             @"zhsj/yiliao/myself/sos/deleteFamily"


// 添加关联机构
#define kAddAgencyURL              @"zhsj/yiliao/myself/sos/saveAgency"
// 修改关联机构
#define kEditAgencyURL             @"zhsj/yiliao/myself/sos/updateAgency"
// 删除关联机构
#define kDelteAgencyURL            @"zhsj/yiliao/myself/sos/deleteAgency"

@implementation PersionSosData

#pragma mark ===  获取家属列表 （
+ (void)getFamileWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools] YYrequestALLURLPostNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kFamilyListUrl] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {

        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataArr,YES);
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}

#pragma mark == 紧急sos
+ (void)sosOfNowFamilyId:(NSString *)familyIdStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = [kPensionBaseUrl stringByAppendingString:kGetSOSURL];
    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:url withParams:@{@"familyId":familyIdStr}.mutableCopy finished:^(id responsObject, NSError *error) {
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

//sos找路 获取 存过的地址终点信息
+ (void)sosfindTheWayWithGetAnAddressInfowithBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = [NSString stringWithFormat: @"%@%@",kPensionBaseUrl , kSoSAddressInfoGetURL];
    [[ToolOfNetWork sharedTools]YrequestGetALLURL:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
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

//sos提交 地址终点信息
+ (void)sosSaveAnNewDestinationAddressWithParms:(NSMutableDictionary *)parms  withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSString *url = [NSString stringWithFormat: @"%@%@",kPensionBaseUrl , kSoSAddressInfoSaveURL];
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
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

#pragma mark == 查询sos家属和机构信息
+ (void)getFamilysAndAgencysListOfNowFamilyId:(NSString *)familyIdStr WithBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = [NSString stringWithFormat: @"%@%@",kPensionBaseUrl , kGetFamilysAndAgencysURL];
    if (familyIdStr.length==0) {
    }else{
        url = [NSString stringWithFormat: @"%@%@?familyId=%@",kPensionBaseUrl , kGetFamilysAndAgencysURL ,familyIdStr];
    }
  
    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
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

#pragma mark ==  家属
+ (void)addFamilysOfNowFamilyId:(NSString *)familyIdStr withNameStr:(NSString *)nameStr withMobile:(NSString *)mobileStr  withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = [kPensionBaseUrl stringByAppendingString:kAddFamilyURL];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:familyIdStr forKey:@"familyId"];
    [parms setValue:nameStr forKey:@"name"];
    [parms setValue:mobileStr forKey:@"mobile"];
    [self postAllUrl:url withPamrms:parms withDicBlock:block];
   
}
+ (void)editFamilysOfNowFamilyId:(NSString *)familyIdStr withNameStr:(NSString *)nameStr withMobile:(NSString *)mobileStr withChangeInfoId:(NSString *)changeInfoId withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = [kPensionBaseUrl stringByAppendingString:kEditFamilyURL];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:familyIdStr forKey:@"familyId"];
    [parms setValue:nameStr forKey:@"name"];
    [parms setValue:mobileStr forKey:@"mobile"];
    [parms setValue:changeInfoId forKey:@"id"];
    [self putAllUrl:url withPamrms:parms withDicBlock:block];
   
}
+ (void)editFamilysOfNowFamilyId:(NSString *)familyIdStr  withDeletInfoId:(NSString *)deletInfoId withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = [kPensionBaseUrl stringByAppendingString:kDelteFamilyURL];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:familyIdStr forKey:@"familyId"];
    [parms setValue:deletInfoId forKey:@"id"];
    [self deletAllUrl:url withPamrms:parms withDicBlock:block];
   
}

#pragma mark == 机构
+ (void)addAgencyOfNowFamilyId:(NSString *)familyIdStr withAgencyIdStr:(NSString *)agencyIdStr  withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = [kPensionBaseUrl stringByAppendingString:kAddAgencyURL];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:familyIdStr forKey:@"familyId"];
    [parms setValue:agencyIdStr forKey:@"agencyId"];
    [self postAllUrl:url withPamrms:parms withDicBlock:block];
   
}
+ (void)editAgencyOfNowFamilyId:(NSString *)familyIdStr withAgencyIdStr:(NSString *)agencyIdStr   withOldWillChangeInfoId:(NSString *)changeInfoId withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = [kPensionBaseUrl stringByAppendingString:kEditAgencyURL];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:familyIdStr forKey:@"familyId"];
    [parms setValue:agencyIdStr forKey:@"agencyId"];//shopid ---id
    [parms setValue:changeInfoId forKey:@"id"];//旧数据ID
    [self putAllUrl:url withPamrms:parms withDicBlock:block];
   
}
+ (void)editAgencysOfNowFamilyId:(NSString *)familyIdStr   withDeletInfoId:(NSString *)deletInfoId  withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = [kPensionBaseUrl stringByAppendingString:kDelteAgencyURL];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:familyIdStr forKey:@"familyId"];
    [parms setValue:deletInfoId forKey:@"id"];
    [self deletAllUrl:url withPamrms:parms withDicBlock:block];
   
}

//
+ (void)postAllUrl:(NSString *)url withPamrms:(NSMutableDictionary *)params withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:params finished:^(id responsObject, NSError *error) {
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
+ (void)putAllUrl:(NSString *)url withPamrms:(NSMutableDictionary *)params withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestPUTALLURLNoMainQueue:url withParams:params finished:^(id responsObject, NSError *error) {
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
+ (void)deletAllUrl:(NSString *)url withPamrms:(NSMutableDictionary *)params withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestDeleteALLURL:url withParams:params finished:^(id responsObject, NSError *error) {
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
