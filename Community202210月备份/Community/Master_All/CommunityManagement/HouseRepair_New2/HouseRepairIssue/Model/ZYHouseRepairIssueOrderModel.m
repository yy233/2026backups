//
//  ZYHouseRepairIssueOrderModel.m
//  Community
//
//  Created by ZY on 2022/4/12.
//

#import "ZYHouseRepairIssueOrderModel.h"

@implementation ZYHouseRepairIssueOrderModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"children" : [ZYHouseRepairIssueOrderChildrenModel class]};
}

@end


@implementation ZYHouseRepairIssueOrderChildrenModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
