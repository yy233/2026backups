//
//  ZYRedCardListModel.m
//  Community
//
//  Created by ZY on 2021/6/7.
//

#import "ZYRedCardListModel.h"

@implementation ZYRedCardListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [ZYRedCardListDataModel class]};
}

@end


@implementation ZYRedCardListDataModel

@end
