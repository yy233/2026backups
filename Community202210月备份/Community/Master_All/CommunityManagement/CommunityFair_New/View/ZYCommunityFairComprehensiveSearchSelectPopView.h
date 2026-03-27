//
//  ZYCommunityFairComprehensiveSearchSelectPopView.h
//  Community
//
//  Created by ZY on 2022/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCommunityFairComprehensiveSearchSelectPopViewDelegate <NSObject>

- (void)popTableViewEvent;

- (void)popViewContentViewEventWithIndex:(NSInteger)index;

@end

@interface ZYCommunityFairComprehensiveSearchSelectPopView : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<ZYCommunityFairComprehensiveSearchSelectPopViewDelegate> delegate;

- (void)showCommunityFairComprehensiveSearchSelectPopViewWithSuperView:(UIView *)superView;

- (void)hiddenCommunityFairComprehensiveSearchSelectPopView;

@end

NS_ASSUME_NONNULL_END
