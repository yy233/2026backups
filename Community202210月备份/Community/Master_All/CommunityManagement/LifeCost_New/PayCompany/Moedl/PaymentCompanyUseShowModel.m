//
//  PaymentCompanyUseShowModel.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import "PaymentCompanyUseShowModel.h"

@implementation PaymentCompanyUseShowModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"queryPaymentBillParamModelList" : @"QueryPaymentBillParamModelListModel", @"createPaymentBillParamsModelList" : @"CreatePaymentBillParamsModelListModel"};
}

@end


@implementation QueryPaymentBillParamModelListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"desc" : @"description"};
}

@end


@implementation CreatePaymentBillParamsModelListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"desc" : @"description"};
}

@end
