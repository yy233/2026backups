//
//  ZYSmallShopContainerRentDetailModel.m
//  Community
//
//  Created by ZY on 2022/3/11.
//

#import "ZYSmallShopContainerRentDetailModel.h"

@implementation ZYSmallShopContainerRentDetailModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"cabinetPriceDtos" : [ZYSmallShopContainerRentDetailCabinetModel class]};
}

@end


@implementation ZYSmallShopContainerRentDetailCabinetModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
