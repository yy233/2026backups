//
//  ParkingMonthlyTenancyPayRenewalPopDatePickView.h
//  Community
//
//  Created by 余莹 on 2021/8/7.
// 暂不用这个

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YesActionBlock)(NSString *);

@interface ParkingMonthlyTenancyPayRenewalPopDatePickView : BasePopView
 
@property (nonatomic,strong) UIDatePicker *pickV;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *yesBtn;

@property (nonatomic,assign) YesActionBlock yesBlock;

@end

NS_ASSUME_NONNULL_END
