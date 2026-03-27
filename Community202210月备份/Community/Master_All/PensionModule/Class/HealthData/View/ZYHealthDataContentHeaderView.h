//
//  ZYHealthDataContentHeaderView.h
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYHealthDataContentHeaderViewDetegate <NSObject>

- (void)refreshButtonEvent;

@end

@interface ZYHealthDataContentHeaderView : UIView

@property (nonatomic, weak) id<ZYHealthDataContentHeaderViewDetegate> delegate;

@end

NS_ASSUME_NONNULL_END
