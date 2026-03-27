//
//  HealthTempAndHeartBaseTotalBrokenLineGraphView.h
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import <UIKit/UIKit.h>
#import "HealthTempHeader.h"
#define Color_BottomLine_Gray    Y_ColorWith16FromRGB(0xF0F1F6)
#define Color_Tip_Orange         Y_ColorWith16FromRGB(0xFFA82B)

////36C8C1  FF0033 状态色
#define Color_Stuste_NomalGreen    Y_ColorWith16FromRGB(0x36C8C1)
#define Color_Stuste_NotNamalRed   Y_ColorWith16FromRGB(0xFF0033)
NS_ASSUME_NONNULL_BEGIN

@interface HealthTempAndHeartBaseTotalBrokenLineGraphView : UIView


- (void)fillTempDayTypeWithData:(HealthGetTempOrHeartOneDayModel *)data;
- (void)fillTempWeakTypeWithData:(HealthGetTempOrHeartOneWeakModel *)data;
- (void)fillTempMonthTypeWithData:(HealthGetTempOrHeartOneMonthModel *)data;
//
- (void)fillHeartDayTypeWithData:(HealthGetTempOrHeartOneDayModel *)data;
- (void)fillHeartWeakTypeWithData:(HealthGetTempOrHeartOneWeakModel *)data;
- (void)fillHeartMonthTypeWithData:(HealthGetTempOrHeartOneMonthModel *)data;

@end

NS_ASSUME_NONNULL_END
