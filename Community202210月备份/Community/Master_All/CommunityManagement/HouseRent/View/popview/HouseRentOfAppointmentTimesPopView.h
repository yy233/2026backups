//
//  HouseRentOfAppointmentTimesPopView.h
//  Community
//
//  Created by 余莹 on 2021/3/31.
//  预约时间

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HouseRentOfAppointmentTimesPopViewDelegate <NSObject>
- (void)chooseYuyueTimeStrWithReserveDate:(NSString *)reserveDate withReserveTime:(NSString *)reserveTime;
@end

@interface HouseRentOfAppointmentTimesPopView : BasePopView
@property (nonatomic,weak) id <HouseRentOfAppointmentTimesPopViewDelegate> delegate;
- (void)showViewfillDataWithTimeArr:(NSMutableArray *)dayArr withTimeArr:(NSMutableArray *)timeArr;

@end

NS_ASSUME_NONNULL_END
