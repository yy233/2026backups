//
//  MedicalStoresBaseModel.m
//  Community
//
//  Created by 余莹 on 2021/12/9.
//

#import "MedicalStoresBaseModel.h"

@implementation MedicalStoresBaseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end
