//
//  ZYSmallShopServiceModel.m
//  Community
//
//  Created by ZY on 2022/3/10.
//

#import "ZYSmallShopServiceModel.h"

@implementation ZYSmallShopServiceModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"records" : [ZYSmallShopServiceRecordsModel class]};
}

@end


@implementation ZYSmallShopServiceRecordsModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
