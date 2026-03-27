//
//  ZYQuestionnaireSurveyEditHeaderView.h
//  Community
//
//  Created by ZY on 2022/6/7.
//

#import <UIKit/UIKit.h>
#import "ZYQuestionnaireSurveyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYQuestionnaireSurveyEditHeaderView : UIView

@property (nonatomic, strong) ZYQuestionnaireSurveyDetailEntityListModel *model;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end

NS_ASSUME_NONNULL_END
