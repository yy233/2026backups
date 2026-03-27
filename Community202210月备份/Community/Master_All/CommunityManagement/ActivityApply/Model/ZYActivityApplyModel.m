//
//  ZYActivityApplyModel.m
//  Community
//
//  Created by ZY on 2021/8/23.
//

#import "ZYActivityApplyModel.h"

@implementation ZYActivityApplyModel

@end


@implementation ZYActivityApplyDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"list" : [ZYActivityApplyDataListModel class]};
}

@end


@implementation ZYActivityApplyDataListModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
