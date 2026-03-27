//
//  MyCarInfoOrParkingOrPayHistoryData.m
//  Community
//
//  Created by 余莹 on 2022/5/11.
//

#import "MyCarInfoOrParkingOrPayHistoryData.h"

#define myCay_DataSubKey  @"records"
 
static NSString *kMyCarInfoList_Url = @"car/selectAppByUserId";
static NSString *kAddOneCar_Url = @"car/insertAppCar";
static NSString *kDeletOneCar_Url = @"car/deleteCar";


static NSString *kMyCarPakingSpotList_Url = @"car-position/myCarPosition";
static NSString *kMyCarPakingSpotAddSubCarPlate_Url = @"car-position-detailed/AddPositionDetailedMain";


static NSString *kMyCarSpotPayHistoryList_Url = @"car-order-month/selectAppOrderMonth";

@implementation MyCarInfoOrParkingOrPayHistoryData

//车辆
+ (void)myCarInfoListWithParms:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools]YrequestGetALLURL:Y_CarSystem_URL_AllLongURL(kMyCarInfoList_Url)  withParams:parms finished:^(id responsObject, NSError *error) {
        
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

//新增车辆
+ (void)myCarAddOneCartWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_CarSystem_URL_AllLongURL(kAddOneCar_Url) withBody:parms finished:^(id responsObject, NSError *error) {
        
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
//删除车辆
+ (void)myCarDeletOneCartWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools]YrequestDeleteALLURL:Y_CarSystem_URL_AllLongURL(kDeletOneCar_Url) withParams:parms finished:^(id responsObject, NSError *error) {
        
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


#pragma mark ===

//车位列表
+ (void)myCarPakingSpotInfoListWithParms:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools]YrequestGetALLURL:Y_CarSystem_URL_AllLongURL(kMyCarPakingSpotList_Url)  withParams:parms finished:^(id responsObject, NSError *error) {
        
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

//添加车辆为主绑定车辆
+ (void)myCarPakingSpotAddSubCarPlateInfoWithBody:(NSMutableDictionary *)body withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools]YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_CarSystem_URL_AllLongURL(kMyCarPakingSpotAddSubCarPlate_Url) withBody:body finished:^(id responsObject, NSError *error) {
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

#pragma mark ===
//缴费历史列表

//data =     {
//    current = 1;
//    extra = "<null>";
//    records =
+ (void)myCarSpotPayHistoryListWithParms:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)block{
 
    [[ToolOfNetWork sharedTools]YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_CarSystem_URL_AllLongURL(kMyCarSpotPayHistoryList_Url) withBody:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                NSMutableArray *getArrs =  ( [[dataDic allKeys] containsObject:myCay_DataSubKey] && isNotNil([dataDic objectForKey:myCay_DataSubKey]) ) ? [dataDic objectForKey:myCay_DataSubKey] : [NSMutableArray array];
                block(getArrs,YES);
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
