//
//  ZYQuestionnaireSurveyStatisticalMoreModel.h
//  Community
//
//  Created by ZY on 2022/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYQuestionnaireSurveyStatisticalMoreModel : NSObject

// 总条数
@property (nonatomic, assign) NSInteger total;

// 题目内容
@property (nonatomic, copy) NSString *content;

// 答案列表
@property (nonatomic, strong) NSArray *list;

@end

NS_ASSUME_NONNULL_END
