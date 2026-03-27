//
//  CommunityModel.m
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import "CommunityModel.h"

@implementation CommunityModel
MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}


#pragma mark == 切换房屋前 初始值时 有使用到拷贝
- (id)copyWithZone:(struct _NSZone *)zone
{
    CommunityModel *model = [[[self class] allocWithZone:zone] init];
    model.ID = self.ID;
    model.name  = self.name;
    return model;
}

- (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    CommunityModel *model = [[[self class] allocWithZone:zone] init];
//    CommunityModel *model = [CommunityModel allocWithZone:zone];
    model.ID = self.ID;
    model.name  = self.name;
    
    return model;
}


 
@end
