//
//  HouseRentVCListViewModel.h
//  Community
//
//  Created by 余莹 on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentVCListViewModel : NSObject
+ (void)getRentVcHouseListArrWithParm:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)block; 
+ (void)getRentVcBuniessShopListArrWithParm:(NSMutableDictionary *)parms WithBlock:(BaseListArrAndSuccessBoolBlock)block;
#pragma mark == 主页用的房屋租赁数据
+ (void)initRentVcHouseListArrToMainVcWithBlock:(BaseListArrAndSuccessBoolBlock)block;
+ (void)upDataRentVcHouseListArrToMainVcWithPageNum:(NSInteger)pageNum WithBlock:(BaseListArrAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
