//
//  ShoppingMallWebViewData.m
//  Community
//
//  Created by 余莹 on 2021/12/15.
//

#import "ShoppingMallWebViewData.h"

#define webview_Pay_Wx   @"shop/order/newOrder/WeChatPay"//微信支付前的所需数据

#define webview_Pay_Zfb   @"shop/order/newOrder/alipay"//支付宝支付前的所需数据

@implementation ShoppingMallWebViewData
/**
 微信_支付_跳转前所需数据
 */

+ (void)willWeChatInWebViewWithPayOrderType:(ALL_PayOrder_Type)payOrderType withOrderId:(NSString *)orderIdStr withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock{
    [self willWeChatPayMoneyNum:0 withPayOrderType:payOrderType withDescriptionStr:@"shopPay" withOrderData:@{@"orderId":orderIdStr}.mutableCopy withGetOrderInfo:willWeChatPayOrderUseModelBlock];

}
+ (void)willWeChatPayMoneyNum:(double)moneyNum
            withPayOrderType:(ALL_PayOrder_Type)payOrderType
            withDescriptionStr:(NSString *)descriptionStr
                withOrderData:(NSMutableDictionary *)orderDataDic
             withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock{

     NSString *allUrl = [BASE_URL_OnlyAsOfPort stringByAppendingString:webview_Pay_Wx];
    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:allUrl withParams:orderDataDic finished:^(id responsObject, NSError *error) {
    
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:urlS withParams:orderDataDic finished:^(id responsObject, NSError *error) {
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
+ (void)willZFBInWebViewWithPayOrderType:(ALL_PayOrder_Type)payOrderType withOrderId:(NSString *)orderIdStr withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock{
    [self willZFBPayMoneyNum:0 withPayOrderType:payOrderType  withOrderData:@{@"orderId":orderIdStr}.mutableCopy withGetOrderInfo:willWeChatPayOrderUseModelBlock];

}
+ (void)willZFBPayMoneyNum:(double)moneyNum
          withPayOrderType:(ALL_PayOrder_Type)payOrderType
             withOrderData:(NSMutableDictionary *)orderDataDic
          withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock{

    NSString *allUrl = [BASE_URL_OnlyAsOfPort stringByAppendingString:webview_Pay_Zfb];
    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:allUrl withParams:orderDataDic finished:^(id responsObject, NSError *error) {

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
