//
//  SmallShppOrderData.h
//  Community
//
//  Created by 余莹 on 2022/3/10.
//

#import <Foundation/Foundation.h>
#import "SmallShopOrderHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SmallShppOrderData : NSObject

+ (void)getOrderDetailInfoWithThisType:(SmallShopOrderDetailVC_Type)orderType andOrderId:(NSInteger)orderId withBlock:(BaseDicAndSuccessBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
