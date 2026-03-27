//
//  ShoppingMallWebViewData.h
//  Community
//
//  Created by 余莹 on 2021/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingMallWebViewData : NSObject
/**
 微信_支付_跳转前所需数据
 */
+ (void)willWeChatInWebViewWithPayOrderType:(ALL_PayOrder_Type)payOrderType withOrderId:(NSString *)orderIdStr withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock;
/**
 支付宝_支付_跳转前所需的数据
 */
+ (void)willZFBInWebViewWithPayOrderType:(ALL_PayOrder_Type)payOrderType withOrderId:(NSString *)orderIdStr withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock;

@end

NS_ASSUME_NONNULL_END
