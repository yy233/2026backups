//
//  ParkingMonthlyTenancyTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/8/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MonthlyRenewBlock)(void);
typedef void(^MonthlyDeletBlock)(void);

@interface ParkingMonthlyTenancyTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *carParkingAddressShowL;
@property (nonatomic,strong) UILabel *typeInfoL;
@property (nonatomic,strong) UILabel *bangDingBeginTimeL;//绑定时间
@property (nonatomic,strong) UILabel *remainingDayNumL;//剩余天数
@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,strong) UIButton *deletBtn;
//
@property (nonatomic,copy) MonthlyRenewBlock  renewBlock;
@property (nonatomic,copy) MonthlyDeletBlock  deletBlock;
//

@end

NS_ASSUME_NONNULL_END
