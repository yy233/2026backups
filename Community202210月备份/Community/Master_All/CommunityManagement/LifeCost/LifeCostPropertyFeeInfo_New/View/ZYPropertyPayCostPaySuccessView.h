//
//  ZYPropertyPayCostPaySuccessView.h
//  Community
//
//  Created by ZY on 2022/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYPropertyPayCostPaySuccessViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYPropertyPayCostPaySuccessView : UIView

@property (nonatomic, weak) id<ZYPropertyPayCostPaySuccessViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
