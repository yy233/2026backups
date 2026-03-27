//
//  ZYHouseRepairIssueRecordPopView.h
//  Community
//
//  Created by ZY on 2022/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYHouseRepairIssueRecordPopViewDelegate <NSObject>

// 按下事件
- (void)voiceButtonTouchDownEvent;

// 松开事件
- (void)voiceButtonTouchUpEvent;

@end

@interface ZYHouseRepairIssueRecordPopView : UIView

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, weak) id<ZYHouseRepairIssueRecordPopViewDelegate> delegate;

- (void)showHouseRepairIssueRecordPopView;

- (void)hiddenHouseRepairIssueRecordPopView;

@end

NS_ASSUME_NONNULL_END
