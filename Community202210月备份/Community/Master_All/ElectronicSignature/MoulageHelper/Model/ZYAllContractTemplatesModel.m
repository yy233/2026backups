//
//  ZYAllContractTemplatesModel.m
//  Community
//
//  Created by ZY on 2021/4/8.
//

#import "ZYAllContractTemplatesModel.h"

@implementation ZYAllContractTemplatesModel

@end


@implementation ZYAllContractTemplatesDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"list" : [ZYAllContractTemplatesDataListModel class]};
}

@end


@implementation ZYAllContractTemplatesDataListModel

@end
