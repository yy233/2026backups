//
//  HouseRentOfHouseAppointmentViewModel.h
//  Community
//
//  Created by 余莹 on 2021/3/30.
// 预约

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentOfHouseAppointmentViewModel : NSObject
//预约 展示用的houseinfo
+ (void)houseRentGetHouseInfoOfAppointmentWithParms:(NSDictionary *)parms withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//预约 选择的pickview data 时间
+ (void)houseRentGetHouseInfoOfAppointmentDaysListAndTimesListWithDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//预约 提交
+ (void)houseRentSendAppointmentInfoWithParms:(NSMutableDictionary *)parms withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

@end

NS_ASSUME_NONNULL_END
