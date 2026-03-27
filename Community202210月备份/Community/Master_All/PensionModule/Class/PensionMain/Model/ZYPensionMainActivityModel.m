//
//  ZYPensionMainActivityModel.m
//  Community
//
//  Created by ZY on 2021/11/10.
//

#import "ZYPensionMainActivityModel.h"

@implementation ZYPensionMainActivityModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [ZYPensionMainActivityDataModel class]};
}

@end


@implementation ZYPensionMainActivityDataModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
