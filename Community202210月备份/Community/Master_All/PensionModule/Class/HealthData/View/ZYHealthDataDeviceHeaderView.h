//
//  ZYHealthDataDeviceHeaderView.h
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYHealthDataDeviceHeaderViewDelegate <NSObject>

- (void)deviceManagerButtonEvent;

@end

@interface ZYHealthDataDeviceHeaderView : UIView

@property (nonatomic, weak) id<ZYHealthDataDeviceHeaderViewDelegate> delegate;
- (void)devSectonHeaderViewShowThisRightBtnBool:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
