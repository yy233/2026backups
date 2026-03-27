//
//  LifeCostPaymentOnePayProgressEndCredentialsDetailModel.h
//  Community
//
//  Created by 余莹 on 2021/3/19.
//

#import <Foundation/Foundation.h>
#import "LifeCostPaymentOneEndBillOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPaymentOnePayProgressEndCredentialsDetailModel : LifeCostPaymentOneEndBillOrderDetailModel
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *orderTime;
@end

NS_ASSUME_NONNULL_END
