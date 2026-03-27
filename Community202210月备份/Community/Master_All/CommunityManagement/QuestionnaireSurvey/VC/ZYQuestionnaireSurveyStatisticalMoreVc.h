//
//  ZYQuestionnaireSurveyStatisticalMoreVc.h
//  Community
//
//  Created by ZY on 2022/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYQuestionnaireSurveyStatisticalMoreVc : ZYBaseViewController

@property (nonatomic, copy) NSString *titleStr;

// 问卷id
@property (nonatomic, copy) NSString *voteId;

// 题目id
@property (nonatomic, copy) NSString *topicId;

@end

NS_ASSUME_NONNULL_END
