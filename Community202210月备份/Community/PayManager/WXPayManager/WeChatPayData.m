//
//  WXPayData.m
//  Community
//
//  Created by 余莹 on 2022/4/6.
//

#import "WeChatPayData.h"
#import "WeChatAndZfbPayWillGetModel.h"


#define WeChat_Pay_Url_UseOrderNum          @"zhsj/cabinet/pay/payOrder"      //小店
#define WeChat_Pay_Url_UseCarPackInfoID     @"api/v1/proprietor/car/pay/info"  //停车缴费
#define WeChat_Pay_Url_LifePayPropertyFee   @"api/v1/proprietor/propertyFeeOrder/payPropertyFee" //生活缴费_物业缴费


@implementation WeChatPayData

//用订单str去调起微信支付
+ (void)weChatPayOfOrderNumStr:(NSString *)orderStr {
    NSLog(@"微信支付等待调起");
    NSDictionary *params = @{@"orderNumber" : orderStr};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue: [NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, WeChat_Pay_Url_UseOrderNum]   withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSLog(@"微信支付调起ing");
                    WeChatAndZfbPayWillGetModel *model =  [WeChatAndZfbPayWillGetModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                    PayReq *req = [[PayReq alloc] init];
                    req.openID = [TextShowWithModelStr textShowWithModelStr:model.appid];
                    req.nonceStr = [TextShowWithModelStr textShowWithModelStr:model.noncestr];
                    req.timeStamp = [[TextShowWithModelStr textShowWithModelStr:model.timestamp] intValue];
                    req.package = [TextShowWithModelStr textShowWithModelStr:model.package];
                    req.partnerId = [TextShowWithModelStr textShowWithModelStr:model.partnerid];
                    req.prepayId = [TextShowWithModelStr textShowWithModelStr:model.prepayid];
                    req.sign = [TextShowWithModelStr textShowWithModelStr:model.sign];
                    [[WeChatPayManager shareManager] hangleWechatPayWithPayReq:req];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
    
}

//停车缴费
+ (void)weChatPayOfCarParkingUseIdStr:(NSString *)idStr{
    NSDictionary *params = @{
        @"payType":@(2),
        @"carOrderRecordId" : idStr};

    [[ToolOfNetWork sharedTools] YYrequestALLURLPostNotMainQueue: [NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, WeChat_Pay_Url_UseCarPackInfoID]   withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSLog(@"微信支付调起ing");
                    WeChatAndZfbPayWillGetModel *model =  [WeChatAndZfbPayWillGetModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                    PayReq *req = [[PayReq alloc] init];
                    req.openID = [TextShowWithModelStr textShowWithModelStr:model.appid];
                    req.nonceStr = [TextShowWithModelStr textShowWithModelStr:model.noncestr];
                    req.timeStamp = [[TextShowWithModelStr textShowWithModelStr:model.timestamp] intValue];
                    req.package = [TextShowWithModelStr textShowWithModelStr:model.package];
                    req.partnerId = [TextShowWithModelStr textShowWithModelStr:model.partnerid];
                    req.prepayId = [TextShowWithModelStr textShowWithModelStr:model.prepayid];
                    req.sign = [TextShowWithModelStr textShowWithModelStr:model.sign];
                    [[WeChatPayManager shareManager] hangleWechatPayWithPayReq:req];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
    
}


//用生活缴费 Id组 去调起微信支付
+ (void)weChatPayOfLiftCostIdStrArr:(NSArray *)idStrArr{
    
    NSDictionary *params = @{
        @"type":@(1),
        @"financeOrderIdList" : idStrArr};//discountedAmount 非必须

    [[ToolOfNetWork sharedTools] YYrequestALLURLPostNotMainQueue: [NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, WeChat_Pay_Url_LifePayPropertyFee]   withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSLog(@"微信支付调起ing");
                    WeChatAndZfbPayWillGetModel *model =  [WeChatAndZfbPayWillGetModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                    PayReq *req = [[PayReq alloc] init];
                    req.openID = [TextShowWithModelStr textShowWithModelStr:model.appid];
                    req.nonceStr = [TextShowWithModelStr textShowWithModelStr:model.noncestr];
                    req.timeStamp = [[TextShowWithModelStr textShowWithModelStr:model.timestamp] intValue];
                    req.package = [TextShowWithModelStr textShowWithModelStr:model.package];
                    req.partnerId = [TextShowWithModelStr textShowWithModelStr:model.partnerid];
                    req.prepayId = [TextShowWithModelStr textShowWithModelStr:model.prepayid];
                    req.sign = [TextShowWithModelStr textShowWithModelStr:model.sign];
                    [[WeChatPayManager shareManager] hangleWechatPayWithPayReq:req];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
    
}


 

@end
