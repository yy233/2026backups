//
//  ZYCommunityFairIssueTopView.h
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCommunityFairIssueTopViewDelegate <NSObject>

- (void)backButtonEvent;

- (void)previewButtonEvent;

@end

@interface ZYCommunityFairIssueTopView : UIView

@property (nonatomic, weak) id<ZYCommunityFairIssueTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
