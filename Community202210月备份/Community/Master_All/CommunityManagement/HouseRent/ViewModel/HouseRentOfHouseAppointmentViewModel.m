//
//  HouseRentOfHouseAppointmentViewModel.m
//  Community
//
//  Created by 余莹 on 2021/3/30.
//

#import "HouseRentOfHouseAppointmentViewModel.h"
#import "ConnectUrl.h"
@implementation HouseRentOfHouseAppointmentViewModel
//预约 展示用的houseinfo
+ (void)houseRentGetHouseInfoOfAppointmentWithParms:(NSDictionary *)parms withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/simpleDetail";
    NSString *allParmsUrl = [ConnectUrl connectUrl:parms.mutableCopy url:url];
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:allParmsUrl withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
           BaseDicAndSuccessBoolBlock block = dicBlock;
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
//预约 选择的pickview data 时间
+ (void)houseRentGetHouseInfoOfAppointmentDaysListAndTimesListWithDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/reserve/datetime";
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
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
//预约 提交
+ (void)houseRentSendAppointmentInfoWithParms:(NSMutableDictionary *)parms withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/reserve/add";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
           BaseDicAndSuccessBoolBlock block = dicBlock;
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
@end
