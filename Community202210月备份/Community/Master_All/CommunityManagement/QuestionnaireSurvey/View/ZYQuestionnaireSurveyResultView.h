//
//  ZYQuestionnaireSurveyResultView.h
//  Community
//
//  Created by ZY on 2022/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYQuestionnaireSurveyResultViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYQuestionnaireSurveyResultView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, weak) id<ZYQuestionnaireSurveyResultViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
