//
//  ZYQuestionnaireSurveyEditOtherCell.h
//  Community
//
//  Created by ZY on 2022/6/8.
//

#import <UIKit/UIKit.h>
#import "ZYQuestionnaireSurveyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZYQuestionnaireSurveyEditOtherCellBlock)(NSString *str);

@interface ZYQuestionnaireSurveyEditOtherCell : UITableViewCell

@property (nonatomic, strong) ZYQuestionnaireSurveyDetailEntityListOptionModel *model;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, copy) ZYQuestionnaireSurveyEditOtherCellBlock block;

@end

NS_ASSUME_NONNULL_END
