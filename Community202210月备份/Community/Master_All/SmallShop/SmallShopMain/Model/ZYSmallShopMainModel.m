//
//  ZYSmallShopMainModel.m
//  Community
//
//  Created by ZY on 2022/3/10.
//

#import "ZYSmallShopMainModel.h"

@implementation ZYSmallShopMainModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"value1" : [ZYSmallShopMainValue1Model class]};
}

@end


@implementation ZYSmallShopMainValue1Model

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end


@implementation ZYSmallShopMainValue3Model

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"records" : [ZYSmallShopMainValue3RecordsModel class]};
}

@end


@implementation ZYSmallShopMainValue3RecordsModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
