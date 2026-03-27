//
//  ZYQuestionnaireSurveyBottomView.h
//  Community
//
//  Created by ZY on 2022/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYQuestionnaireSurveyBottomViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYQuestionnaireSurveyBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (nonatomic, weak) id<ZYQuestionnaireSurveyBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
