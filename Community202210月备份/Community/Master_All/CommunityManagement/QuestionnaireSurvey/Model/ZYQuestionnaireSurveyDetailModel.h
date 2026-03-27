//
//  ZYQuestionnaireSurveyDetailModel.h
//  Community
//
//  Created by ZY on 2022/6/15.
//

#import <Foundation/Foundation.h>

@class ZYQuestionnaireSurveyDetailEntityListModel, ZYQuestionnaireSurveyDetailEntityListOptionModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYQuestionnaireSurveyDetailModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 提交后是否对外公开统计（0.否 1.是）
@property (nonatomic, assign) BOOL isOpenStatistics;

// 提交后可查看已填内容（0.否 1.是）
@property (nonatomic, assign) BOOL isSeeSubmit;

// 总参与人数量
@property (nonatomic, assign) NSInteger total;

// 标题
@property (nonatomic, copy) NSString *theme;

// 说明
@property (nonatomic, copy) NSString *content;

// 结束时间
@property (nonatomic, copy) NSString *overTime;

// 题目列表
@property (nonatomic, strong) NSArray<ZYQuestionnaireSurveyDetailEntityListModel *> *voteTopicEntityList;

@end


@interface ZYQuestionnaireSurveyDetailEntityListModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 问卷id
@property (nonatomic, copy) NSString *voteId;

// 1单选，2多选，3问答
@property (nonatomic, assign) NSInteger choose;

// 最多选择(默认0无限)
@property (nonatomic, assign) NSInteger maxChoice;

// 最少选择(默认1)
@property (nonatomic, assign) NSInteger minChoice;

// 题目
@property (nonatomic, copy) NSString *content;

// 问答答案
@property (nonatomic, copy) NSString *answerContent;

// 答案列表
@property (nonatomic, strong) NSArray<ZYQuestionnaireSurveyDetailEntityListOptionModel *> *options;

// 问答答案列表
@property (nonatomic, strong) NSArray *answerContentList;

// ---自定义---
// 列表顺序
@property (nonatomic, assign) NSInteger order;

@end


@interface ZYQuestionnaireSurveyDetailEntityListOptionModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 题目id
@property (nonatomic, copy) NSString *topicId;

// 答案
@property (nonatomic, copy) NSString *content;

// 0未选，1选中
@property (nonatomic, assign) BOOL status;

// 是否为其他选项(1.是 0.否)
@property (nonatomic, assign) BOOL isOtherOption;

// 其他答案
@property (nonatomic, copy) NSString *otherContent;

// 票数
@property (nonatomic, assign) NSInteger number;

// ---自定义---
// 0当前用户未投票，1当前用户已投票
@property (nonatomic, assign) BOOL isCurrentStatus;

// 总参与人数量
@property (nonatomic, assign) NSInteger total;

@end

NS_ASSUME_NONNULL_END
