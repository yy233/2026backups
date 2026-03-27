//
//  HealGetTempAbnormalModel.m
//  Community
//
//  Created by 余莹 on 2021/11/22.
//

#import "HealthGetAllAbnormalModel.h"

@implementation HealthGetAllAbnormalModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list":[HealthGetOneAbnormalModel class]}; 
}
@end
