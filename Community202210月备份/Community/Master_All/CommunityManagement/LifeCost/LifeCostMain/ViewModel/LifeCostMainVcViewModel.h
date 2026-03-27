//
//  LifeCostMainVcViewModel.h
//  Community
//
//  Created by 余莹 on 2021/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostMainVcViewModel : NSObject
+ (void)getLifeCostMyCostArrWith:(BaseListArrAndSuccessBoolBlock)listBlock;
+ (void)getLifeCostAddNewCostArrWithCotyid:(NSInteger)cityId  with:(BaseListArrAndSuccessBoolBlock)listBlock;
@end

NS_ASSUME_NONNULL_END
