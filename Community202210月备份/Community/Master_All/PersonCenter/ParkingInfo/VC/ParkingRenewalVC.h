//
//  ParkingRenewalVC.h
//  Community
//
//  Created by 余莹 on 2021/8/27.
// 续约

#import <UIKit/UIKit.h>
#import "ParkingMonthlyTenancyAddNewCarVC.h"
#import "ParkingCarBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ParkingRenewalVC : ParkingMonthlyTenancyAddNewCarVC
@property (nonatomic,strong) ParkingCarBaseModel *model; 
@end

NS_ASSUME_NONNULL_END
