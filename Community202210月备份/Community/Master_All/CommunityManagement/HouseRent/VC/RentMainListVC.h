//
//  RentMainListVC.h
//  Community
//
//  Created by 余莹 on 2021/6/21.
////旧的筛选 保留原本的代码

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//typedef enum : NSUInteger {
//    MainCellRecommendedServiceHourse_Type_BusinessShop=0,//商铺
//    MainCellRecommendedServiceHourse_Type_RentHouse=1,//租房
//} MainCellRecommendedServiceHourse_Rent_Type;
@interface RentMainListVC : BaseViewController 
@property (nonatomic,assign) MainCellRecommendedServiceHourse_Rent_Type viewType;
@end

NS_ASSUME_NONNULL_END
