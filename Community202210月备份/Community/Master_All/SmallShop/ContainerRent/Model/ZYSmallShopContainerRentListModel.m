//
//  ZYSmallShopContainerRentListModel.m
//  Community
//
//  Created by ZY on 2022/3/10.
//

#import "ZYSmallShopContainerRentListModel.h"

@implementation ZYSmallShopContainerRentListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"records" : [ZYSmallShopContainerRentListRecordsModel class]};
}

@end


@implementation ZYSmallShopContainerRentListRecordsModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
