//
//  MedicalShopRelatedData.h
//  Community
//
//  Created by 余莹 on 2021/12/9.
//

#import <Foundation/Foundation.h>
#import "MedicalServiceBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedicalShopRelatedData : NSObject

//查询附近的服务z
+ (void)getMedicalNearTheServiceMinNumCountWithBlock:(BaseListArrAndSuccessBoolBlock)block;//主页少量几条
+ (void)getMedicalNearTheServiceFirstPageNumWithBlock:(BaseListArrAndSuccessBoolBlock)block;
+ (void)getMedicalNearTheServiceWithPageNum:(NSInteger)pageNum withBlock:(BaseListArrAndSuccessBoolBlock)block;


////根据分类展示店铺列表 /医疗类型
+ (void)getMedicalShopOnlyMinNumCountWithBlock:(BaseListArrAndSuccessBoolBlock)block;////主页少量几条
+ (void)getMedicalShopFirstPageNumWithBlock:(BaseListArrAndSuccessBoolBlock)block;
+ (void)getMedicalShopWithPageNum:(NSInteger)pageNum withBlock:(BaseListArrAndSuccessBoolBlock)block;

//SOS医疗救助机构
+ (void)getMedicalShopOfSOSAgencyFirstPageNumWithSearchShopNameStr:(NSString *)shopName WithBlock:(BaseListArrAndSuccessBoolBlock)block;
+ (void)getMedicalShopOfSOSAgencyWithSearchShopNameStr:(NSString *)shopName andPageNum:(NSInteger)pageNum withBlock:(BaseListArrAndSuccessBoolBlock)block;

//热门推荐 (用不到这个热门)
+ (void)getHotShopFirstPageNumWithBlock:(BaseListArrAndSuccessBoolBlock)block;
+ (void)getHotShopWithPageNum:(NSInteger)pageNum withBlock:(BaseListArrAndSuccessBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
