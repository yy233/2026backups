//
//  ZYAccessRecordModel.m
//  Community
//
//  Created by ZY on 2022/4/27.
//

#import "ZYAccessRecordModel.h"

@implementation ZYAccessRecordModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"records" : [ZYAccessRecordDataModel class]};
}

@end


@implementation ZYAccessRecordDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"entityList" : [ZYAccessRecordDataListModel class]};
}

@end


@implementation ZYAccessRecordDataListModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
