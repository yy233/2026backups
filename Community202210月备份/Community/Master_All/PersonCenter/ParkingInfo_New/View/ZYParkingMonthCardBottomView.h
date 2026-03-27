//
//  ZYParkingMonthCardBottomView.h
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYParkingMonthCardBottomViewDelegate <NSObject>

- (void)buyButtonEvent;

@end

@interface ZYParkingMonthCardBottomView : UIView

@property (nonatomic, weak) id<ZYParkingMonthCardBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
