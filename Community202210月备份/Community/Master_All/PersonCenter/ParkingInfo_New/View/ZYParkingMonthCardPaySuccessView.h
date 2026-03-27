//
//  ZYParkingMonthCardPaySuccessView.h
//  Community
//
//  Created by ZY on 2022/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYParkingMonthCardPaySuccessViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYParkingMonthCardPaySuccessView : UIView

@property (nonatomic, weak) id<ZYParkingMonthCardPaySuccessViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
