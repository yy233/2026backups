//
//  MyCarInfoData.m
//  Community
//
//  Created by 余莹 on 2021/8/21.
//

#import "MyCarInfoData.h"

@implementation MyCarInfoData
/**
 type 2表示月租车辆，3表示我的车辆
 如果类型为2必须要穿社区id
20220415增加社区ID参数 list和add接口 我的房屋都加了
 */

+ (void)getMyCarListWithBlcok:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/car/getCars";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(3) forKey:@"type"];
    [parms setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
//    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {//0827更换
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

+ (void)addMyCarWithCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/car/add";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:carInfoDic  finished:^(id responsObject, NSError *error) {
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


+ (void)editMyCarWithCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/car/update";
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:url withParams:carInfoDic  finished:^(id responsObject, NSError *error) {
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
+ (void)deletMyCarWithId:(NSInteger)carId withBlock:(BaseDicAndSuccessBoolBlock)block{
        NSString *url = @"proprietor/car/delete";
        [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueue:url withParams:@{@"id":@(carId)}.mutableCopy finished:^(id responsObject, NSError *error) {
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
