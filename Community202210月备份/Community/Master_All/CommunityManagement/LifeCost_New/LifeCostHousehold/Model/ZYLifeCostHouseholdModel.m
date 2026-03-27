//
//  ZYLifeCostHouseholdModel.m
//  Community
//
//  Created by ZY on 2022/1/7.
//

#import "ZYLifeCostHouseholdModel.h"

@implementation ZYLifeCostHouseholdModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"accountEntityList" : [ZYLifeCostHouseholdListModel class]};
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end


@implementation ZYLifeCostHouseholdListModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
