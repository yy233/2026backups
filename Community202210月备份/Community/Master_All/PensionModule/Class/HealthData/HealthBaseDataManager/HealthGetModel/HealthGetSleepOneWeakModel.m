//
//  HealthGetSleepOneWeakModel.m
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import "HealthGetSleepOneWeakModel.h"

@implementation HealthGetSleepOneWeakModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"list":[HealthGetSleepOneDayModel class]};
}
@end
