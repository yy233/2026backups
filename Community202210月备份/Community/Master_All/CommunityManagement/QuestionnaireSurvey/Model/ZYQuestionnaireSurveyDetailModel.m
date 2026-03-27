//
//  ZYQuestionnaireSurveyDetailModel.m
//  Community
//
//  Created by ZY on 2022/6/15.
//

#import "ZYQuestionnaireSurveyDetailModel.h"

@implementation ZYQuestionnaireSurveyDetailModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"voteTopicEntityList" : [ZYQuestionnaireSurveyDetailEntityListModel class]};
}

@end


@implementation ZYQuestionnaireSurveyDetailEntityListModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"options" : [ZYQuestionnaireSurveyDetailEntityListOptionModel class]};
}

@end


@implementation ZYQuestionnaireSurveyDetailEntityListOptionModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
