//
//  ZYBalanceDetailModel.m
//  Community
//
//  Created by ZY on 2021/10/15.
//

#import "ZYBalanceDetailModel.h"

@implementation ZYBalanceDetailModel

@end


@implementation ZYBalanceDetailDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"records" : [ZYBalanceDetailDataRecordsModel class]};
}

@end


@implementation ZYBalanceDetailDataRecordsModel

@end
