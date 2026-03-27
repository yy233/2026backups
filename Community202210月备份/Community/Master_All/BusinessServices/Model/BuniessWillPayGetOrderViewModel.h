//
//  BuniessWillPayGetOrderViewModel.h
//  Community
//
//  Created by 余莹 on 2021/4/14.
//

#import <Foundation/Foundation.h>
#import "WillPayGetOrderViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BuniessWillPayGetOrderViewModel : WillPayGetOrderViewModel
/**
 微信_支付_跳转前所需数据
 */
+ (void)willWeChatPayMoneyNum:(double)moneyNum
            withPayOrderType:(ALL_PayOrder_Type)payOrderType
            withDescriptionStr:(NSString *)descriptionStr
                withOrderData:(NSMutableDictionary *)orderDataDic
            withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock;


/**
 支付宝_支付_跳转前所需的数据
 */
+ (void)willZFBPayMoneyNum:(double)moneyNum
          withPayOrderType:(ALL_PayOrder_Type)payOrderType
             withOrderData:(NSMutableDictionary *)orderDataDic
          withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock;
@end

NS_ASSUME_NONNULL_END
