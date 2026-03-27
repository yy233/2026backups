//
//  HouseRentVCTypeChooseViewModel.h
//  Community
//
//  Created by 余莹 on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentVcAllQueryTypesChooseViewModel : NSObject
//房屋
+ (void)getCityQuArr:(BaseListArrAndSuccessBoolBlock)listArrBlock;
+ (void)getMoneyArr:(BaseListArrAndSuccessBoolBlock)listArrBlock;
+ (void)getHouseTypeArr:(BaseListArrAndSuccessBoolBlock)listArrBlock;
+ (void)getMoreArr:(BaseDicAndSuccessBoolBlock)dicArrBlock;
//商铺
+ (void)getBuniessShopMoneyArr:(BaseListArrAndSuccessBoolBlock)listArrBlock;
+ (void)getBuniessAreaSpaceeArr:(BaseListArrAndSuccessBoolBlock)listArrBlock;
+ (void)getBuniessMoreArr:(BaseDicAndSuccessBoolBlock)dicArrBlock;
@end

NS_ASSUME_NONNULL_END
