//
//  ZYEditEventBottomView.h
//  Community
//
//  Created by ZY on 2021/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYEditEventBottomViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYEditEventBottomView : UIView

@property (nonatomic, weak) id<ZYEditEventBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
