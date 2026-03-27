//
//  LifeCostPayOrderDetailModel.h
//  Community
//
//  Created by 余莹 on 2022/1/19.
//

#import <Foundation/Foundation.h>
#import "LifeCostPayHistoryOrderSubOrderEntityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayOrderDetailModel : LifeCostPayHistoryOrderSubOrderEntityModel

@property (nonatomic,copy) NSString *orderStatusName;


/**
 
/livingExpensesOrder/v2/orderDetail____{
    code = 0;
    data =     {
        billAmount = 2;
        billId = 146776542775742464;
        billKey = 051245000023;
        company = "北京暖气";
        contactNo = 051245000023;
        createTime = "2022-01-18 17:55:34";
        customerName = "杨波";
        deleted = 0;
        householder = "杨波";
        id = 146779724453122048;
        idStr = 146779724453122048;
        itemCode = 470191419;
        itemId = 172805;
        orderDate = 20220118;
        orderStatus = 3;
        orderStatusName = "缴费成功";
        payAmount = "2.21";
        payType = 3;
        repoPayAmount = "2.21";
        transacNo = 1202201183541189;
        typeId = 20;
        uid = 96616;
        updateTime = "2022-01-18 17:55:47";
 */
@end

NS_ASSUME_NONNULL_END
