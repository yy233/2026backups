//
//  LifeCostPayHistoryOrderListModel.m
//  Community
//
//  Created by 余莹 on 2022/1/6.
//

#import "LifeCostPayHistoryOrderListModel.h"

@implementation LifeCostPayHistoryOrderListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"orderEntityList" : [LifeCostPayHistoryOrderSubOrderEntityModel class]};
}
@end
