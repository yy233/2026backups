//
//  ZYLifeCostAddGroupBottomView.h
//  Community
//
//  Created by ZY on 2022/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYLifeCostAddGroupBottomViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYLifeCostAddGroupBottomView : UIView

@property (nonatomic, weak) id<ZYLifeCostAddGroupBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
