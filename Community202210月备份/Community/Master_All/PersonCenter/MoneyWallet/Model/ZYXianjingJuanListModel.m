//
//  ZYXianjingJuanListModel.m
//  Community
//
//  Created by ZY on 2021/6/8.
//

#import "ZYXianjingJuanListModel.h"

@implementation ZYXianjingJuanListModel

@end


@implementation ZYXianjingJuanListDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"records" : [ZYXianjingJuanListDataRecordsModel class]};
}

@end


@implementation ZYXianjingJuanListDataRecordsModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
