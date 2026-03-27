//
//  ParkingMonthlyTenancyAddNewCarVC.h
//  Community
//
//  Created by 余莹 on 2021/8/6.
// 绑定月租车辆

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParkingMonthlyTenancyAddNewCarVC : BaseTableViewController
@property (nonatomic,strong) NSMutableArray *cellTitleArr;
@property (nonatomic,assign) double saveDanJiaOfMonthly;//每个月单价
- (void)reqDanJiaWithOneMoney;
@end

NS_ASSUME_NONNULL_END
