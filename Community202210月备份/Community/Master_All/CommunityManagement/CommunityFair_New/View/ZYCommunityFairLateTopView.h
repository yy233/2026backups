//
//  ZYCommunityFairLateTopView.h
//  Community
//
//  Created by ZY on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCommunityFairLateTopViewDelegate <NSObject>

- (void)searchViewEvent;

- (void)backButtonEvent;

- (void)chatButtonEvent;

@end

@interface ZYCommunityFairLateTopView : UIView

@property (nonatomic, weak) id<ZYCommunityFairLateTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
