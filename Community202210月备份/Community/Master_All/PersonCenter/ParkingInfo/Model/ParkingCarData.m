//
//  ParkingCarData.m
//  Community
//
//  Created by 余莹 on 2021/8/25.
//

#import "ParkingCarData.h"

@implementation ParkingCarData

/**
 //临时缴费
 + (void)lingShiGetMyCarListWithBlcok:(BaseListArrAndSuccessBoolBlock)block{
     NSString *url = @"proprietor/car/getCars";
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
 + (void)lingShiAddCarWithParkCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
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
 */

/**
//绑定
+ (void)parkingAddCarWithParkCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSString *url = @"proprietor/car/bindingMonthCar";
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
*/



#pragma mark =====

//绑定月租车辆
+ (void)parkingBindingMonthCarWithParkCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/car/bindingMonthCar";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:carInfoDic  finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSString *dataOrderStr =  Y_ResponsObject_dataStr;
                block(@{@"OrderIdStr":dataOrderStr},YES);
                
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

//月租车辆续约
+ (void)parkingRenewMonthCarWithParkCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/car/renewMonthCar";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:carInfoDic  finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSString *dataOrderStr =  Y_ResponsObject_dataStr;
                block(@{@"OrderIdStr":dataOrderStr},YES);
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

//删除月租车辆
+ (void)parkingDeletMonthCarWithParkCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/car/deleteMonthCar";
    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueue:url withParams:carInfoDic finished:^(id responsObject, NSError *error) {
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


#pragma mark ==

//月租缴费
//月租缴费车辆查询
/**
 type 2表示月租车辆，3表示我的车辆
 如果类型为2必须要穿社区id
 */
+ (void)parkingMonthlyTypeCarListWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/car/getCars";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(2) forKey:@"type"];
    [parms setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
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

//缴费记录
+ (void)payParkingHistoryListWithType:(ParkingCar_Type)type withListBlock:(BaseListArrAndSuccessBoolBlock)block{
    //type 暂时仅仅月租缴费记录
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(9999) forKey:@"size"];
    NSMutableDictionary *q = [NSMutableDictionary dictionaryWithObject:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [parms setValue:q forKey:@"query"];
    NSString *url = @"proprietor/car/getMonthOrder";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:Y_ResponsObject_dataDic];
                NSArray *list =  [[dic  allKeys] containsObject:@"list"] ? [NSArray arrayWithArray:[dic objectForKey:@"list"]] : [[NSArray alloc]init];
                block(list,YES);
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

//1103一条月租缴费记录详情
+ (void)payMonthsOneOrderInfoWithIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block{
//    NSString *url = @"proprietor/car/getOrder";
//    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{@"id":idStr}.mutableCopy  finished:^(id responsObject, NSError *error) {
//    [[ToolOfNetWork sharedTools]YrequestGetURLNoMainQueueWithBodyNotParms:url withBody:@{@"id":idStr}.mutableCopy finished:^(id responsObject, NSError *error) {
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:@{@"id":idStr}.mutableCopy finished:^(id responsObject, NSError *error) {
    NSString *url = [NSString stringWithFormat: @"proprietor/car/getOrder?id=%@",idStr];
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.mutableCopy  finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataDic,YES);
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
//查询当前小区空置车位
+ (void)parkingGetPositionInfoWithCommunityInfoDic:(NSMutableDictionary *)communityInfoDic withBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/car/getPosition";
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:communityInfoDic  finished:^(id responsObject, NSError *error) {
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

//输入月份获取应缴金额
+ (void)parkineGetMoneyWithNowInfoDic:(NSMutableDictionary *)communityInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/car/payPositionFees";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:communityInfoDic  finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
               CGFloat money =  [[responsObject allKeys] containsObject:@"data"]?[[responsObject objectForKey:@"data"] floatValue]:0.0;
                NSDictionary *dic = @{@"M":@(money)};
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
