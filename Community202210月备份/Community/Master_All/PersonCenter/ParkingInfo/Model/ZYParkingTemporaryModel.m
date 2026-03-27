//
//  ZYParkingTemporaryModel.m
//  Community
//
//  Created by ZY on 2021/10/27.
//

#import "ZYParkingTemporaryModel.h"

@implementation ZYParkingTemporaryModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [ZYParkingTemporaryDataModel class]};
}

@end


@implementation ZYParkingTemporaryDataModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
