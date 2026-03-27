//
//  ZYCommunityFairIssueBottomView.h
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCommunityFairIssueBottomViewDelegate <NSObject>

- (void)issueButtonEvent;

@end

@interface ZYCommunityFairIssueBottomView : UIView

@property (nonatomic, weak) id<ZYCommunityFairIssueBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
