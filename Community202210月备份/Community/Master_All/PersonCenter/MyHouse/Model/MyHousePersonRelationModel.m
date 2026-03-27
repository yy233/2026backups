//
//  MyHousePersonRelationModel.m
//  Community
//
//  Created by 余莹 on 2021/8/18.
//

#import "MyHousePersonRelationModel.h"

@implementation MyHousePersonRelationModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"members":[MyHousePersonRelationSubMemberModel class]};
}
@end
