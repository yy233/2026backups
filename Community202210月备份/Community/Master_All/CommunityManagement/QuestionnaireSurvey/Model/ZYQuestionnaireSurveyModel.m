//
//  ZYQuestionnaireSurveyModel.m
//  Community
//
//  Created by ZY on 2022/6/15.
//

#import "ZYQuestionnaireSurveyModel.h"

@implementation ZYQuestionnaireSurveyModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"list" : [ZYQuestionnaireSurveyListModel class]};
}

@end

@implementation ZYQuestionnaireSurveyListModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end
