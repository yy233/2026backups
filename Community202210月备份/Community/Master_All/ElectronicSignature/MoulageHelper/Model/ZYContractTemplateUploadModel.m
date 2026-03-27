//
//  ZYContractTemplateUploadModel.m
//  Community
//
//  Created by ZY on 2021/5/13.
//

#import "ZYContractTemplateUploadModel.h"

@implementation ZYContractTemplateUploadModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"tempParam" : [ZYContractTemplateUploadTempParamModel class]};
}

@end


@implementation ZYContractTemplateUploadTempParamModel

@end
