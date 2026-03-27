//
//  WillPayGetOrderViewModel.m
//  Community
//
//  Created by 余莹 on 2021/3/11.
//

#import "WillPayGetOrderViewModel.h"

//#import "
@implementation WillPayGetOrderViewModel
/**
 微信_支付_跳转前所需数据
 */
+ (void)willWeChatPayMoneyNum:(double)moneyNum
            withPayOrderType:(ALL_PayOrder_Type)payOrderType
            withDescriptionStr:(NSString *)descriptionStr
            withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock{
    NSString *urlS = @"payment/wxPay";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(payOrderType) forKey:@"tradeFrom"];
    [parms setValue:descriptionStr forKey:@"descriptionStr"];
    [parms setValue:@(moneyNum) forKey:@"amount"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:urlS withParams:parms finished:^(id responsObject, NSError *error) {
        WillWeChatPayUseOrderModelBlock block = willWeChatPayOrderUseModelBlock;
        WillPayOrderInfoModel *model = [[WillPayOrderInfoModel alloc]init];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                model = [WillPayOrderInfoModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                block(model,YES);
            }else{
                block(model,NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(model,NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

/**
 支付宝_支付_跳转前所需的数据
 */
+ (void)willZFBPayMoneyNum:(double)moneyNum
          withPayOrderType:(ALL_PayOrder_Type)payOrderType
          withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock{
    NSString *urlS = @"payment/alipay/order";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(payOrderType) forKey:@"tradeFrom"];
    [parms setValue:@(1) forKey:@"payType"]; //支付宝类型
    [parms setValue:@(moneyNum) forKey:@"totalAmount"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:urlS withParams:parms finished:^(id responsObject, NSError *error) {
        WillWeChatPayUseOrderModelBlock block = willWeChatPayOrderUseModelBlock;
        WillPayOrderInfoModel *model = [[WillPayOrderInfoModel alloc]init];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                model = [WillPayOrderInfoModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                block(model,YES);
            }else{
                block(model,NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(model,NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

//付款成功后订单数据add
+ (void)lifeCostAddOrderWithParms:(NSMutableDictionary *)parms
                    withBaseBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_life_MyCost_detail_PayMoney_Order_Add withParams:parms finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(@{},YES);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
                block(@{},NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            block(@{},NO);
        }
    }];
}

#pragma mark ===  0708 增 物业费  订单合集idArr 比水电气多ids数据  ｜ 0914 可用于车辆缴费等等 公共类
/**
 微信_支付_跳转前所需数据
 */
+ (void)willWeChatPayMoneyNum:(double)moneyNum
            withPayOrderType:(ALL_PayOrder_Type)payOrderType
            withDescriptionStr:(NSString *)descriptionStr
               withOrderIdArr:(NSMutableArray *)orderIdArr //物业ids 车辆缴费id
            withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock{
    NSString *urlS = @"payment/wxPay";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(payOrderType) forKey:@"tradeFrom"];
    [parms setValue:descriptionStr forKey:@"descriptionStr"];
    [parms setValue:@(moneyNum) forKey:@"amount"];
    NSString *allIdStr = [orderIdArr componentsJoinedByString:@","];
    [parms setValue:allIdStr forKey:@"ids"];//物业ids字段
    //—0914 总的下单都要小区id
    [parms setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];//当前社区
    //—0914—————车辆用的数据
    if (payOrderType == payOrder_Type_ParkCar || payOrderType == payOrder_Type_ParkCar_Temp || payOrderType == payOrder_Type_SigningRent) {
        [parms setValue:@"" forKey:@"ids"];//清空物业ids字段
        [parms removeObjectForKey:@"ids"];
        [parms setValue:orderIdArr.firstObject forKey:@"serviceOrderNo"];//清空物业ids字段 使用车辆id 合同id
    }
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:urlS withParams:parms finished:^(id responsObject, NSError *error) {
        WillWeChatPayUseOrderModelBlock block = willWeChatPayOrderUseModelBlock;
        WillPayOrderInfoModel *model = [[WillPayOrderInfoModel alloc]init];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                model = [WillPayOrderInfoModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                block(model,YES);
            }else{
                block(model,NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(model,NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

/**
 支付宝_支付_跳转前所需的数据
 */
+ (void)willZFBPayMoneyNum:(double)moneyNum
          withPayOrderType:(ALL_PayOrder_Type)payOrderType
            withOrderIdArr:(NSMutableArray *)orderIdArr
          withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock{
    NSString *urlS = @"payment/alipay/order";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(payOrderType) forKey:@"tradeFrom"];
    [parms setValue:@(1) forKey:@"payType"]; //支付宝类型
    [parms setValue:@(moneyNum) forKey:@"totalAmount"];//物业这边的金钱数据为了安全 此处传入的数据不被使用 而是后台自己计算
    NSString *allIdStr = [orderIdArr componentsJoinedByString:@","];
    [parms setValue:allIdStr forKey:@"ids"];//
    //—0914 总的下单都要小区id
    [parms setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];//当前社区
    //—0914—————车辆用的数据
    if (payOrderType == payOrder_Type_ParkCar || payOrderType == payOrder_Type_ParkCar_Temp || payOrderType == payOrder_Type_SigningRent) {
        [parms setValue:@"" forKey:@"ids"];//清空物业ids字段
        [parms removeObjectForKey:@"ids"];
        [parms setValue:orderIdArr.firstObject forKey:@"serviceOrderNo"];//清空物业ids字段 使用车辆id 合同id
    }
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:urlS withParams:parms finished:^(id responsObject, NSError *error) {
        WillWeChatPayUseOrderModelBlock block = willWeChatPayOrderUseModelBlock;
        WillPayOrderInfoModel *model = [[WillPayOrderInfoModel alloc]init];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                model = [WillPayOrderInfoModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                block(model,YES);
            }else{
                block(model,NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(model,NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
@end

