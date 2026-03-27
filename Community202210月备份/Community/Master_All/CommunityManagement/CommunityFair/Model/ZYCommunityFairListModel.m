//
//  ZYCommunityFairListModel.m
//  Community
//
//  Created by ZY on 2021/8/26.
//

#import "ZYCommunityFairListModel.h"

@implementation ZYCommunityFairListModel

@end


@implementation ZYCommunityFairListDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"list" : [ZYCommunityFairListDataListModel class]};
}

@end


@implementation ZYCommunityFairListDataListModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
