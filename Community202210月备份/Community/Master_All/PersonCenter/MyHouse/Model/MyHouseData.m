//
//  MyHouseData.m
//  Community
//
//  Created by 余莹 on 2021/8/18.
//

#import "MyHouseData.h"

@implementation MyHouseData
//查询当前房子 用户的人物关系列表
+ (void)getMyHousePersonsRelationListDataWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/user/house/details";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
            }else{
                block(@{},NO);
//                Y_SVP_SHOW_ERR_MESSAGE//
                //Y_SVP_SHOW_INFO_MES(@"您在当前小区没有房屋，可添加您的房屋");
                Y_SVP_SHOW_INFO_MES(@"您在当前小区没有房屋");//1020去除了添加操作 提示信息调整
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//当前业主用户的情况下 批量删除 家属租客等次级关系人
+ (void)deletMyHousePersonsRelationsWithIdsArr:(NSArray *)idsArr withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/user/house/members/delete";
    NSString *idsStr = [idsArr componentsJoinedByString:@","];
    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueue:url withParams:@{@"ids":idsStr}.mutableCopy finished:^(id responsObject, NSError *error) {
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
//当前业主用户情况下   家属租客的新增 0426 两种结果普通有url 关怀模式职业成功的响应无值
+ (void)addMyHousePersonsRelationsWithPersonInfoDic:(NSMutableDictionary *)personInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/user/house/members/save";
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:url withParams:personInfoDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSString *urlStr = [NSString stringWithFormat:@"%@",Y_ResponsObject_dataStr];
                if (urlStr.length>5) {//普通模式 需要接口数据去h5 ---------- Y_ResponsObject_dataStr url或1 用length0来判断会是错误的数据
                    NSDictionary *dic = @{@"URL":urlStr};
                    block(dic,YES);
                }else{
                    block(@{},YES);//关怀模式
                }
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
//家属详情编辑更新新版信息
+ (void)updateMyHousePersonWithFlamilyInfoDic:(NSMutableDictionary *)personInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/houseMember/update";
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:url withParams:personInfoDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSString *urlStr = [NSString stringWithFormat:@"%@",Y_ResponsObject_dataStr];
                NSLog(@"myHouse upData getinfo == %@",urlStr);
                //关怀变成手机号模式 走url?还是直接成功也是一个url
                if (urlStr.length>5 && [urlStr containsString:@"http"]) {//普通模式 需要接口数据去h5 ---------- Y_ResponsObject_dataStr url或1 用length0来判断会是错误的数据
                    NSDictionary *dic = @{@"URL":urlStr};
                    block(dic,YES);
                }else{
                    block(@{},YES);//关怀模式
                }
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


//当前业主用户情况下  房屋的新增
+ (void)addMyHouseWithHouseInfoDic:(NSMutableDictionary *)houseInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
 
    NSString *url = @"proprietor/user/house/attestation";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:houseInfoDic finished:^(id responsObject, NSError *error) {
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




//根据小区查询所有当前业主认证过房子 （用户是业主身份关系的房子）
+ (void)getMyHousesHaveBeenCertifiedListDataWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/user/house/selectHouse";
    [self getHouseListWithUrl:url withBlock:block];
}


//根据小区查询所有当前业主认证过房子 （用户是任意关联身份关系的房子）
+ (void)getMyHousesHaveRelattionListWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/user/house/switchoverHouse";
    [self getHouseListWithUrl:url withBlock:block];
}


+ (void)getHouseListWithUrl:(NSString *)url withBlock:(BaseListArrAndSuccessBoolBlock)block{
   // NSInteger communityId = 1;
//    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{@"communityId":@(communityId)}.mutableCopy finished:^(id responsObject, NSError *error) {
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
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
 
     
@end
