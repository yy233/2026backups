//
//  ZYReportAboutRepairApplyBottomView.h
//  Community
//
//  Created by ZY on 2022/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYReportAboutRepairApplyBottomViewDelegate <NSObject>

// 按下事件
- (void)voiceButtonTouchDownEvent;

// 松开事件
- (void)voiceButtonTouchUpEvent;

@end

@interface ZYReportAboutRepairApplyBottomView : UIView

@property (nonatomic, weak) id<ZYReportAboutRepairApplyBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
