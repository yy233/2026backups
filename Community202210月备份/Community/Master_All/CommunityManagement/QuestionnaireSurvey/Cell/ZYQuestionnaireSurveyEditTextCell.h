//
//  ZYQuestionnaireSurveyEditTextCell.h
//  Community
//
//  Created by ZY on 2022/6/7.
//

#import <UIKit/UIKit.h>
#import "ZYQuestionnaireSurveyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYQuestionnaireSurveyEditTextCell : UITableViewCell

@property (nonatomic, strong) ZYQuestionnaireSurveyDetailEntityListModel *model;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

NS_ASSUME_NONNULL_END
