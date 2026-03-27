//
//  ZYQuestionnaireSurveyStatisticalOtherCell.h
//  Community
//
//  Created by ZY on 2022/6/9.
//

#import <UIKit/UIKit.h>
#import "ZYQuestionnaireSurveyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYQuestionnaireSurveyStatisticalOtherCellDelegate <NSObject>

- (void)showButtonEvent:(NSIndexPath *)indexPath;

@end

@interface ZYQuestionnaireSurveyStatisticalOtherCell : UITableViewCell

@property (nonatomic, strong) ZYQuestionnaireSurveyDetailEntityListOptionModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property (nonatomic, weak) id<ZYQuestionnaireSurveyStatisticalOtherCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
