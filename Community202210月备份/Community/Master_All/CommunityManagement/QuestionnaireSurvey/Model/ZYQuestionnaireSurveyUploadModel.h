//
//  ZYQuestionnaireSurveyUploadModel.h
//  Community
//
//  Created by ZY on 2022/6/15.
//

#import <Foundation/Foundation.h>

@class ZYQuestionnaireSurveyUploadEntityLisModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYQuestionnaireSurveyUploadModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 作答时间
@property (nonatomic, copy) NSString *answerStartTime;

// 提交时间
@property (nonatomic, copy) NSString *submitTime;

// 答题时长（分钟）
@property (nonatomic, assign) NSInteger answerDuration;

@property (nonatomic, strong) NSArray<ZYQuestionnaireSurveyUploadEntityLisModel *> *voteUserEntityList;

@end


@interface ZYQuestionnaireSurveyUploadEntityLisModel : NSObject

// 题目id
@property (nonatomic, copy) NSString *topicId;

// 其他选项内容
@property (nonatomic, copy) NSString *otherContent;

// 问答提交答案
@property (nonatomic, copy) NSString *answerContent;

// 答案列表
@property (nonatomic, strong) NSArray *optionList;

@end

NS_ASSUME_NONNULL_END
