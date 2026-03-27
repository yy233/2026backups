//
//  ZYQuestionnaireSurveyResultVc.h
//  Community
//
//  Created by ZY on 2022/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZYQuestionnaireSurveyResult_Type_Success,   //问卷投票成功
    ZYQuestionnaireSurveyResult_Type_Underway,  //进行中
    ZYQuestionnaireSurveyResult_Type_Over,      //已结束
} ZYQuestionnaireSurveyResult_Type;

@interface ZYQuestionnaireSurveyResultVc : ZYBaseViewController

@property (nonatomic, assign) ZYQuestionnaireSurveyResult_Type type;

@end

NS_ASSUME_NONNULL_END
