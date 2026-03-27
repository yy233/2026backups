//
//  ZYCommunityFairComprehensiveSearchFiltratePopView.h
//  Community
//
//  Created by ZY on 2022/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCommunityFairComprehensiveSearchFiltratePopViewDelegate <NSObject>

- (void)closeButtonEvent;

- (void)resetButtonEvent;

- (void)okButtonEvent;

@end

@interface ZYCommunityFairComprehensiveSearchFiltratePopView : UIView

@property (nonatomic, weak) id<ZYCommunityFairComprehensiveSearchFiltratePopViewDelegate> delegate;

- (void)showCommunityFairComprehensiveSearchFiltratePopView;

- (void)hiddenCommunityFairComprehensiveSearchFiltratePopView;

@end

NS_ASSUME_NONNULL_END
