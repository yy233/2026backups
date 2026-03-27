//
//  ZYHealthDataDeviceFooterView.h
//  Community
//
//  Created by ZY on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYHealthDataDeviceFooterViewDelegate <NSObject>

- (void)goButtonEvent;

@end

@interface ZYHealthDataDeviceFooterView : UIView

@property (nonatomic, weak) id<ZYHealthDataDeviceFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
