//
//  ZYEventRemindModel.m
//  Community
//
//  Created by ZY on 2021/11/11.
//

#import "ZYEventRemindModel.h"

@implementation ZYEventRemindModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"records" : [ZYEventRemindRecordsModel class]};
}

@end


@implementation ZYEventRemindRecordsModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
