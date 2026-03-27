//
//  LifeCostMainVcTopGroupSectionModel.m
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import "LifeCostMainVcTopGroupSectionModel.h"

@implementation LifeCostMainVcTopGroupSectionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"accountEntityList" : [LifeCostMainVcTopGroupSubAccountEntityModel class]};
}
@end
