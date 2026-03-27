//
//  ZYOwnersVotePlanModel.m
//  Community
//
//  Created by ZY on 2021/8/25.
//

#import "ZYOwnersVotePlanModel.h"

@implementation ZYOwnersVotePlanModel

@end


@implementation ZYOwnersVotePlanDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"list" : [ZYOwnersVotePlanDataListModel class]};
}

@end


@implementation ZYOwnersVotePlanDataListModel

@end
