//
//  HealthGetTempOneDayData.m
//  Community
//
//  Created by 余莹 on 2021/11/22.
//

#import "HealthGetTempOrHeartOneDayModel.h"

@implementation HealthGetTempOrHeartOneDayModel
 
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list":[healthGetTempOrHeartListObjModel class]};
}

@end
