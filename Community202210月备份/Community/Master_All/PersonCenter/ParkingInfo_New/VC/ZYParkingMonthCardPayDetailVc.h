//
//  ZYParkingMonthCardPayDetailVc.h
//  Community
//
//  Created by ZY on 2022/5/9.
//

#import <UIKit/UIKit.h>
#import "ZYParkingMonthCardUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZYParking_MonthCard_Type_Add,       // 添加月租卡
    ZYParking_MonthCard_Type_Renewal,   // 续租
}ZYParking_MonthCard_Type;

@interface ZYParkingMonthCardPayDetailVc : ZYBaseViewController

@property (nonatomic, assign) ZYParking_MonthCard_Type type;

@property (nonatomic, strong) ZYParkingMonthCardUploadModel *uploadModel;

@end

NS_ASSUME_NONNULL_END
