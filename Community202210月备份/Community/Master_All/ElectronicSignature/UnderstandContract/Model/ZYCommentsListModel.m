//
//  ZYCommentsListModel.m
//  Community
//
//  Created by ZY on 2021/5/24.
//

#import "ZYCommentsListModel.h"

@implementation ZYCommentsListModel

@end


@implementation ZYCommentsListDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"list" : [ZYCommentsListDataListModel class]};
}

@end


@implementation ZYCommentsListDataListModel

@end
