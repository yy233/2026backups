//
//  ZYCommunityFairMarkModel.m
//  Community
//
//  Created by ZY on 2021/8/26.
//

#import "ZYCommunityFairMarkModel.h"

@implementation ZYCommunityFairMarkModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [ZYCommunityFairMarkDataModel class]};
}

@end


@implementation ZYCommunityFairMarkDataModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
