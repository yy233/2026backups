//
//  ZYContractTemplatesTypeModel.m
//  Community
//
//  Created by ZY on 2021/4/15.
//

#import "ZYContractTemplatesTypeModel.h"

@implementation ZYContractTemplatesTypeModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [ZYContractTemplatesTypeDataModel class]};
}

@end


@implementation ZYContractTemplatesTypeDataModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"Id" : @"id"};
}

@end
