//
//  ZYQuestionnaireSurveyUploadModel.m
//  Community
//
//  Created by ZY on 2022/6/15.
//

#import "ZYQuestionnaireSurveyUploadModel.h"

@implementation ZYQuestionnaireSurveyUploadModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"voteUserEntityList" : [ZYQuestionnaireSurveyUploadEntityLisModel class]};
}

@end


@implementation ZYQuestionnaireSurveyUploadEntityLisModel

@end
