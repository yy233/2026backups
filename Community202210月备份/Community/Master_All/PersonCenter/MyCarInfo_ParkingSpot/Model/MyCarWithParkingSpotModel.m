//
//  MyCarWithParkingSpotModel.m
//  Community
//
//  Created by 余莹 on 2022/5/6.
//

#import "MyCarWithParkingSpotModel.h"
#import "CarInfoBaseModel.h"

@implementation MyCarWithParkingSpotModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{  @"carNumbers" : [CarInfoBaseModel class]};
}
 
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end
