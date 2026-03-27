//
//  LifeCostPayHistoryOrderListModel.h
//  Community
//
//  Created by 余莹 on 2022/1/6.
//

#import <Foundation/Foundation.h>
#import "LifeCostPayHistoryOrderSubOrderEntityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayHistoryOrderListModel : NSObject
@property (nonatomic,copy) NSString *dateString;
@property (nonatomic,copy) NSArray *orderEntityList;

@end

NS_ASSUME_NONNULL_END
