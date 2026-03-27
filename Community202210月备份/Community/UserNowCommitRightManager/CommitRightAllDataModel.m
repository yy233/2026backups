//
//  CommitRightModel.m
//  Community
//
//  Created by 余莹 on 2021/8/18.
//

#import "CommitRightAllDataModel.h"

@implementation CommitRightAllDataModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"permissions":[CommitRightIdsModel class]};
}
@end
