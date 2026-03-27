//
//  ZYCommunityFairTypeModel.m
//  Community
//
//  Created by ZY on 2021/8/26.
//

#import "ZYCommunityFairTypeModel.h"

@implementation ZYCommunityFairTypeModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [ZYCommunityFairTypeDataModel class]};
}

@end


@implementation ZYCommunityFairTypeDataModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end


