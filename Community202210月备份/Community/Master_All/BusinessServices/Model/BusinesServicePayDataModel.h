//
//  BusinesServicePayData.h
//  Community
//
//  Created by 余莹 on 2021/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinesServicePayDataModel : WillPayGetOrderViewModel
 /**
  addressUuid = "";
  deliveryFee = 2;
  deliveryWay = 1;
  shopUuid = string;*/

@property (nonatomic,strong) NSString *addressUuid;
@property (nonatomic,strong) NSString *shopUuid;
@property (nonatomic,assign) double deliveryFee;
@property (nonatomic,assign) NSString *storeName;
@property (nonatomic,assign) NSInteger deliveryWay;

@end

NS_ASSUME_NONNULL_END

