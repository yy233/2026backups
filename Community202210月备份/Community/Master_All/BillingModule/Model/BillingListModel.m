//
//  BillingListModel.m
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import "BillingListModel.h"

@implementation BillingListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"balanceChanges":[BillingListSubOneInfoDetailModel class],
    };
}
@end
