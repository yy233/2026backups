//
//  ZYIssueActivityBottomView.h
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYIssueActivityBottomViewDelegate <NSObject>

- (void)voiceButtonTouchDownEvent;

- (void)voiceButtonTouchUpEvent;

@end

@interface ZYIssueActivityBottomView : UIView

@property (nonatomic, weak) id<ZYIssueActivityBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
