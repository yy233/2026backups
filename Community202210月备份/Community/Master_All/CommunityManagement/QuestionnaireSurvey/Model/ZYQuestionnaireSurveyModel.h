//
//  ZYQuestionnaireSurveyModel.h
//  Community
//
//  Created by ZY on 2022/6/15.
//

#import <Foundation/Foundation.h>

@class ZYQuestionnaireSurveyListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYQuestionnaireSurveyModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<ZYQuestionnaireSurveyListModel *> *list;

@end


@interface ZYQuestionnaireSurveyListModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 提交后是否对外公开统计（0.否 1.是）
@property (nonatomic, assign) BOOL isOpenStatistics;

// 提交后可查看已填内容（0.否 1.是）
@property (nonatomic, assign) BOOL isSeeSubmit;

// 0当前用户未投票，1当前用户已投票
@property (nonatomic, assign) BOOL status;

// 1待发布，2进行中，3已结束
@property (nonatomic, assign) NSInteger voteStatus;

// 标题
@property (nonatomic, copy) NSString *theme;

// 说明
@property (nonatomic, copy) NSString *content;

// 结束时间
@property (nonatomic, copy) NSString *overTime;

@end

NS_ASSUME_NONNULL_END
