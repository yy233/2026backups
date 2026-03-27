//
//  ParkingMonthlyTenancyPayRenewaGoPayingVC.h
//  Community
//
//  Created by 余莹 on 2021/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParkingMonthlyTenancyPayRenewaGoPayingVC : BaseViewController
@property (nonatomic,strong) NSString *dataOrderIdStr;
@property (nonatomic,assign) double moneyNum;
@property (nonatomic,assign) BOOL isTempCar;//临时车辆类型的支付
@end

NS_ASSUME_NONNULL_END
