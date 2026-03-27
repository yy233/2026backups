//
//  IssueManagerBottomListViewModel.h
//  Community
//
//  Created by 余莹 on 2021/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueManagerViewModel : NSObject
//租房管理 房东 已发的 house 列表数据
+ (void)managerVcBottomFangDongTypeWithListBlock:(BaseListArrAndSuccessBoolBlock)blockList;
//租房管理 房东 已发的 buniesShop 列表数据
+ (void)managerVcBottomBuniessShopTypeWithListBlock:(BaseListArrAndSuccessBoolBlock)blockList;


//下架发布的房屋
+ (void)deletDownHouseWithId:(NSInteger)houseId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//下架发布的商铺
+ (void)deletDownBuniessShopWithId:(NSInteger)shopId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;


//0903签约
+ (void)qianYueHouseListWithFangDongOrZuKe:(NSInteger)identityType initWithBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)qianYueBuniessListWithFangDongOrZuKe:(NSInteger)identityType initWithBlock:(BaseDicAndSuccessBoolBlock)block; 

@end

NS_ASSUME_NONNULL_END
