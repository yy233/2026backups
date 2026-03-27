//
//  ZYContrectAllListModel.m
//  Community
//
//  Created by ZY on 2021/5/24.
//

#import "ZYContrectAllListModel.h"

@implementation ZYContrectAllListModel

@end


@implementation ZYContrectAllListDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"list" : [ZYContrectAllListDataListModel class]};
}

@end


@implementation ZYContrectAllListDataListModel

@end


@implementation ZYContrectAllListDataMapModel

@end

