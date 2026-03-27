//
//  IntelligentInquirySearchModel.m
//  Community
//
//  Created by 余莹 on 2021/12/14.
//

#import "IntelligentInquirySearchModel.h"

@implementation IntelligentInquirySearchModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"goodsList" : [MedicalServiceBaseModel class],
              @"shopList" : [MedicalStoresBaseModel class],
            };

}
@end
