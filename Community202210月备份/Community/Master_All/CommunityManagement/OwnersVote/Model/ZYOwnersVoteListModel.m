//
//  ZYOwnersVoteListModel.m
//  Community
//
//  Created by ZY on 2021/8/25.
//

#import "ZYOwnersVoteListModel.h"

@implementation ZYOwnersVoteListModel

@end


@implementation ZYOwnersVoteListDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"list" : [ZYOwnersVoteListDataListModel class]};
}

@end


@implementation ZYOwnersVoteListDataListModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
