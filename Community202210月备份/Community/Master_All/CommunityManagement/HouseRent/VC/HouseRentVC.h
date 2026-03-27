//
//  HouseRentVC.h
//  Community
//
//  Created by 余莹 on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MainCellRecommendedServiceHourse_Type_BusinessShop=0,//商铺
    MainCellRecommendedServiceHourse_Type_RentHouse=1,//租房
} MainCellRecommendedServiceHourse_Rent_Type;
@interface HouseRentVC : BaseViewController
@property (nonatomic,assign) MainCellRecommendedServiceHourse_Rent_Type viewType;
@end

NS_ASSUME_NONNULL_END
