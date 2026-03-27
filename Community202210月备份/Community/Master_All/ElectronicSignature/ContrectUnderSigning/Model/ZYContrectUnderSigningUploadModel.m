//
//  ZYContrectUnderSigningUploadModel.m
//  Community
//
//  Created by ZY on 2021/5/20.
//

#import "ZYContrectUnderSigningUploadModel.h"

@implementation ZYContrectUnderSigningUploadModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"contractParams" : [ZYContractTemplateUploadTempParamModel class]};;
}

@end
