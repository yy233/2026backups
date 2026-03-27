//
//  ZYCityModel.m
//  Community
//
//  Created by ZY on 2022/1/5.
//

#import "ZYCityModel.h"

@implementation ZYCityModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"cityCategoryModelList" : [ZYCityListModel class], @"cityHotCategoryModelList" : [ZYCityListModel class]};
}

@end


@implementation ZYCityListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"cityModelList" : [ZYCityListDataModel class]};
}

@end


@implementation ZYCityListDataModel

@end
