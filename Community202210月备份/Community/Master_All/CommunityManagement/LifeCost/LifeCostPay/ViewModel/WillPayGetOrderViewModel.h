//
//  WillPayGetOrderViewModel.h
//  Community
//
//  Created by 余莹 on 2021/3/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



typedef void(^WillWeChatPayUseOrderModelBlock)(WillPayOrderInfoModel *, BOOL);

@interface WillPayGetOrderViewModel : NSObject
/**
 微信_支付_跳转前所需数据
 */
+ (void)willWeChatPayMoneyNum:(double)moneyNum
            withPayOrderType:(ALL_PayOrder_Type)payOrderType
            withDescriptionStr:(NSString *)descriptionStr
            withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock;


/**
 支付宝_支付_跳转前所需的数据
 */
+ (void)willZFBPayMoneyNum:(double)moneyNum
          withPayOrderType:(ALL_PayOrder_Type)payOrderType
          withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock;

//付款成功后订单数据add
+ (void)lifeCostAddOrderWithParms:(NSMutableDictionary *)parms
                    withBaseBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

#pragma mark ===  0708 增 物业费  订单合集idArr
/**
 微信_支付_跳转前所需数据
 */
+ (void)willWeChatPayMoneyNum:(double)moneyNum
            withPayOrderType:(ALL_PayOrder_Type)payOrderType
            withDescriptionStr:(NSString *)descriptionStr
               withOrderIdArr:(NSMutableArray *)orderIdArr
             withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock;

+ (void)willZFBPayMoneyNum:(double)moneyNum
          withPayOrderType:(ALL_PayOrder_Type)payOrderType
            withOrderIdArr:(NSMutableArray *)orderIdArr 
          withGetOrderInfo:(WillWeChatPayUseOrderModelBlock)willWeChatPayOrderUseModelBlock;
@end

NS_ASSUME_NONNULL_END
