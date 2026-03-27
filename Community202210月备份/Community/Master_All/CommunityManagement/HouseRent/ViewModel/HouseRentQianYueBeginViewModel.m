//
//  HouseRentQianYueBeginViewModel.m
//  Community
//
//  Created by 余莹 on 2021/9/2.
//

#import "HouseRentQianYueBeginViewModel.h"

@implementation HouseRentQianYueBeginViewModel
//发起签约
+ (void)initiateQianYueWithHouseOrBuniessInfoDic:(NSMutableDictionary *)parms Block:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"lease/house/v2/initContract";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms  finished:^(id responsObject, NSError *error) {
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
