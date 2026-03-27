//
//  ZYProcessEvidenceModel.m
//  Community
//
//  Created by ZY on 2021/9/1.
//

#import "ZYProcessEvidenceModel.h"

@implementation ZYProcessEvidenceModel

@end


@implementation ZYProcessEvidenceDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"processRecordTimestampParamList" : [ZYProcessEvidenceDataListModel class]};
}

@end


@implementation ZYProcessEvidenceDataListModel

@end


@implementation ZYProcessEvidenceDataListDataModel

@end
