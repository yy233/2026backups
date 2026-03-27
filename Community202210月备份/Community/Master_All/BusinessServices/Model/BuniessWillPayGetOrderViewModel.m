//
//  BuniessWillPayGetOrderViewModel.m
//  Community
//
//  Created by 余莹 on 2021/4/14.
//

#import "BuniessWillPayGetOrderViewModel.h"

@implementation BuniessWillPayGetOrderViewModel
/**
 微信_支付_跳转前所需数据
 */
+ (void)willWeChatPayMoneyNum:(double)moneyNum
            withPayOrderType:(ALL_PayOrder_Type)payOrderType
            withDescriptionStr:(NSString *)descriptionStr
                withOrderData:(NSMutableDictionary *)orderDataDic
             withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock{

    NSString *urlS = @"payment/wxPay";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(payOrderType) forKey:@"tradeFrom"];
    [parms setValue:descriptionStr forKey:@"descriptionStr"];
    [parms setValue:@(moneyNum) forKey:@"amount"];
    [parms setValue:orderDataDic forKey:@"orderData"];
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
             withOrderData:(NSMutableDictionary *)orderDataDic
          withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock{
    NSString *urlS = @"payment/alipay/order";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(payOrderType) forKey:@"tradeFrom"];
    [parms setValue:@(1) forKey:@"payType"]; //支付宝类型
    [parms setValue:@(moneyNum) forKey:@"totalAmount"];
    [parms setValue:orderDataDic forKey:@"orderData"];
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
