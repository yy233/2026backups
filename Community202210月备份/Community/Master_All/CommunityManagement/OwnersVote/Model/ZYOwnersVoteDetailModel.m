//
//  ZYOwnersVoteDetailModel.m
//  Community
//
//  Created by ZY on 2021/8/25.
//

#import "ZYOwnersVoteDetailModel.h"

@implementation ZYOwnersVoteDetailModel

@end


@implementation ZYOwnersVoteDetailDataModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end


@implementation ZYOwnersVoteDetailDataVoteTopicEntityModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"options" : [ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel class]};
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end


@implementation ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
