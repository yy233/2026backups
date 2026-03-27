//
//  ZYContractKnowledgeListModel.m
//  Community
//
//  Created by ZY on 2021/5/17.
//

#import "ZYContractKnowledgeListModel.h"

@implementation ZYContractKnowledgeListModel

@end


@implementation ZYContractKnowledgeListDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"list" : [ZYContractKnowledgeListDataListModel class]};
}

@end


@implementation ZYContractKnowledgeListDataListModel

@end
