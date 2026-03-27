//
//  LifeCostAddNewCostViewModel.h
//  Community
//
//  Created by 余莹 on 2021/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostAddNewCostViewModel : NSObject
//+ (void)initAddNewCostCompanyArrWithTypeId:(NSInteger)typeId withCityId:(NSInteger)cityId with:(BaseListArrAndSuccessBoolBlock)listBlock;
//+ (void)moreAddNewCostCompanyArrWithTypeId:(NSInteger)typeId withCityId:(NSInteger)cityId WithPageNum:(NSInteger)pageNum with:(BaseListArrAndSuccessBoolBlock)listBlock;
//+ (void)getAddNewCostCompanyArrWithTypeId:(NSInteger)typeId withCityId:(NSInteger)cityId with:(BaseListArrAndSuccessBoolBlock)listBlock;
+ (void)getAddNewCostCompanyArrWithTypeId:(NSInteger)typeId withCityId:(NSInteger)cityId withSearchStr:(NSString *)searchStr with:(BaseListArrAndSuccessBoolBlock)listBlock;

/**
 新增缴费 ===  假账单接口
 */
+ (void)addNewLifeCostPayWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
@end

NS_ASSUME_NONNULL_END
