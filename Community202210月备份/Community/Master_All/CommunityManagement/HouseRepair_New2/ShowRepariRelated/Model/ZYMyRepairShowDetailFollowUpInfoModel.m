//
//  ZYMyRepairShowDetailFollowUpInfoModel.m
//  Community
//
//  Created by ZY on 2022/4/13.
//

#import "ZYMyRepairShowDetailFollowUpInfoModel.h"

@implementation ZYMyRepairShowDetailFollowUpInfoModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"infoVOS" : [ZYMyRepairShowDetailFollowUpInfoListModel class]};
}

@end


@implementation ZYMyRepairShowDetailFollowUpInfoListModel

@end
