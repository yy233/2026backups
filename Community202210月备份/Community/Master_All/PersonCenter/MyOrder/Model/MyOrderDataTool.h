//
//  MyOrderData.h
//  Community
//
//  Created by 余莹 on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import "MyOrderTool.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyOrderDataTool : NSObject
+ (void)getAllOrderListWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock;
+ (void)getOrderListWithType:(MyOrderListCell_Type)orderType withBlock:(BaseListArrAndSuccessBoolBlock)listBlock;

@end

NS_ASSUME_NONNULL_END
