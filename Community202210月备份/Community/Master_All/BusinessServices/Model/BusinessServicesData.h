//
//  BusinessServicesData.h
//  Community
//
//  Created by 余莹 on 2021/4/2.
//

#import <Foundation/Foundation.h>

#define click_Address                    @"selectAddress"
#define click_Pay                        @"getFromAndroid"
#define click_FindAcctivity              @"FindActivity"
#define click_getOrderInfo               @"toVideo"

NS_ASSUME_NONNULL_BEGIN
typedef void(^IntgerBlock)(NSInteger i);
typedef void(^StrBlock)(NSString *st);

typedef void(^dataBlock)(NSDate *da);

@interface BusinessServicesData : NSObject

//让后台做订单
+ (void)creatOrderWithDic:(NSMutableDictionary *)getJsDic with:(BaseDicAndSuccessBoolBlock)dicBlock;
//支付
+ (void)shopOrderInfoToPayWithJsGetDic:(NSMutableDictionary *)jsGetDic andOrderInfo:(NSMutableDictionary *)orderInfoDic with:(BaseDicAndSuccessBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
